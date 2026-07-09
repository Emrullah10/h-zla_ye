import { createProxyMiddleware } from 'http-proxy-middleware';

const PUBLIC_PATHS = ['/api/auth/login', '/app/health'];

function isPublicPath(url) {
  return PUBLIC_PATHS.some((p) => url.startsWith(p));
}

export function createProxy(targetUrl) {
  return createProxyMiddleware({
    target: targetUrl,
    changeOrigin: true,
    onProxyReq: (proxyReq, req, res) => {
      proxyReq.removeHeader('X-Frame-Options');

      // Backend CORS gateway-only ayarlı — origin'i gateway URL'ine maskele
      proxyReq.setHeader('Origin', 'http://127.0.0.1:4000');

      if (req.user) {
        proxyReq.setHeader('X-User-Id', req.user.userId);
        proxyReq.setHeader('X-User-Role', req.user.role || '');
      }

      const method = req.method.toUpperCase();
      if (['GET', 'HEAD', 'OPTIONS'].includes(method)) return;
      if (isPublicPath(req.url)) return;

      const csrfToken = req.headers['x-xsrf-token'];
      const csrfCookie = req.signedCookies?.['XSRF-TOKEN'] ?? req.cookies?.['XSRF-TOKEN'];
      if (!csrfToken || csrfToken !== csrfCookie) {
        res.status(403).json({ status: 'error', message: 'Invalid CSRF token' });
        return;
      }
    },
    onProxyRes: (proxyRes, req, res) => {
      // Browser CORS: proxy response'a Access-Control-Allow-Origin ekle
      const origin = req.headers.origin;
      if (origin) {
        proxyRes.headers['access-control-allow-origin'] = origin;
        proxyRes.headers['access-control-allow-credentials'] = 'true';
        // Backend'in kendi CORS header'larını temizle (çakışmasın)
        delete proxyRes.headers['access-control-allow-methods'];
      }

      const method = req.method.toUpperCase();
      if (['GET', 'HEAD', 'OPTIONS'].includes(method)) {
        const xsrfToken = Math.random().toString(36).slice(2) + Date.now().toString(36);
        res.cookie('XSRF-TOKEN', xsrfToken, { sameSite: 'lax' });
      }
    },
  });
}
