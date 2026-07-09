import appConfig from '../packages/modules/config/index.js';
import { createProxy } from './middlewares/http-proxy-middleware.js';
import { refreshTokenService, deleteTokenFromRedis, verifyAccessToken, createToken } from './utils/token.js';

export function setupProxyRoutes(app) {
  // Lazy: appConfig boot zamanında dolu olur
  const upstreams = [
    { basePath: '/api/auth', url: appConfig.serviceAuthUrl },
    { basePath: '/api/courier', url: appConfig.serviceCourierUrl },
    { basePath: '/api/onboarding', url: appConfig.serviceOnboardingUrl },
    { basePath: '/api/admin', url: appConfig.serviceAdminUrl },
  ];
  for (const { basePath, url } of upstreams) {
    app.use(basePath, createProxy(url));
  }
}

// Dinamik: Redis'ten gelen servis listesine göre proxy kur
export function setupDynamicProxyRoutes(app, services) {
  for (const service of services) {
    if (service.basePath && service.url) {
      app.use(service.basePath, createProxy(service.url));
    }
  }
}

export function addGatewayRoutes(app) {
  // Login: auth servisini doğrudan çağır, başarılıysa cookie set et
  app.post('/api/auth/login', async (req, res) => {
    try {
      const upstream = appConfig.serviceAuthUrl;
      const upstreamRes = await fetch(`${upstream}/api/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(req.body ?? {}),
      });

      const data = await upstreamRes.json().catch(() => ({}));

      if (!upstreamRes.ok) {
        return res.status(upstreamRes.status).json(data);
      }

      await createToken({
        payload: {
          userId: data.userId,
          role: data.role,
          userPermissionList: data.userPermissionList,
        },
        response: res,
      });

      const xsrfToken = Math.random().toString(36).slice(2) + Date.now().toString(36);
      res.cookie('XSRF-TOKEN', xsrfToken, { sameSite: 'lax' });

      let onboardingStatus = data.role === 'admin' ? 'approved' : null;
      if (data.role === 'courier') {
        try {
          const onboardingRes = await fetch(`${appConfig.serviceOnboardingUrl}/api/onboarding/status`, {
            headers: { 'X-User-Id': data.userId, 'X-User-Role': data.role },
          });
          if (onboardingRes.ok) {
            const onboardingData = await onboardingRes.json().catch(() => ({}));
            onboardingStatus = onboardingData.status ?? null;
          }
        } catch { /* onboarding servisine ulaşılamazsa null bırak */ }
      }

      return res.json({
        status: 'success',
        userId: data.userId,
        role: data.role,
        userPermissionList: data.userPermissionList,
        driver: data.driver,
        onboardingStatus,
      });
    } catch (err) {
      return res.status(502).json({ status: 'error', message: 'Auth service unreachable', detail: err?.message });
    }
  });

  // Token yenile
  app.post('/api/gateway/refresh', (req, res) => refreshTokenService({ req, res }));

  // Logout
  app.post('/api/gateway/logout', async (req, res) => {
    const accessToken = req.signedCookies?.accessToken;
    if (accessToken) {
      try {
        const decoded = verifyAccessToken(accessToken);
        await deleteTokenFromRedis(decoded.userId, decoded.guid);
      } catch { /* token geçersiz olsa bile cookie'leri sil */ }
    }

    const isProd = appConfig.nodeEnv === 'production';
    res.clearCookie('accessToken', { httpOnly: true, signed: true, sameSite: 'strict', secure: isProd });
    res.clearCookie('refreshToken', { httpOnly: true, signed: true, sameSite: 'strict', secure: isProd });
    res.clearCookie('XSRF-TOKEN', { sameSite: 'lax' });
    res.json({ status: 'success' });
  });

  // Me
  app.get('/api/gateway/me', async (req, res) => {
    if (!req.user) return res.status(401).json({ status: 'error', message: 'Unauthorized' });
    const { userId, role, userPermissionList } = req.user;

    // Courier (driver) ise onboarding status'unu da iliştir (F5 sonrası stale olmasın)
    let onboardingStatus = null;
    if (role === 'courier') {
      try {
        const upstream = appConfig.serviceOnboardingUrl;
        const upstreamRes = await fetch(`${upstream}/api/onboarding/status`, {
          headers: {
            'X-User-Id': userId,
            'X-User-Role': role,
          },
        });
        if (upstreamRes.ok) {
          const data = await upstreamRes.json().catch(() => ({}));
          onboardingStatus = data.status ?? data.onboardingStatus ?? null;
        }
      } catch { /* status alınamazsa null bırak */ }
    }

    res.json({ status: 'success', userId, role, userPermissionList, onboardingStatus });
  });

  // Health
  app.get('/app/health', (_req, res) => {
    res.json({
      status: 'ok',
      service: 'hızla-gateway',
      upstreams: Object.keys({
        'service-auth': appConfig.serviceAuthUrl,
        'service-courier': appConfig.serviceCourierUrl,
        'service-onboarding': appConfig.serviceOnboardingUrl,
        'service-admin': appConfig.serviceAdminUrl,
      }),
    });
  });
}
