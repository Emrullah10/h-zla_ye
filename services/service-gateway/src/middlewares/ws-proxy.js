import { createProxyMiddleware } from 'http-proxy-middleware';
import cookie from 'cookie';
import cookieSignature from 'cookie-signature';
import appConfig from '../../packages/modules/config/index.js';
import { verifyAccessToken } from '../utils/token.js';

export function setupWsProxy(server, app) {
  const wsProxy = createProxyMiddleware({
    target: appConfig.serviceCourierUrl,
    changeOrigin: true,
    ws: true,
    pathRewrite: { '^/ws/courier': '/ws' },
    onProxyReqWs: (proxyReq, req) => {
      if (req.user) {
        proxyReq.setHeader('X-User-Id', req.user.userId);
        proxyReq.setHeader('X-User-Role', req.user.role || '');
      }
    },
  });

  app.use('/ws/courier', wsProxy);

  server.on('upgrade', (req, socket, head) => {
    if (!req.url.startsWith('/ws/courier')) return;

    const cookies = cookie.parse(req.headers.cookie || '');
    const raw = cookies.accessToken;
    const signedValue = raw && raw.startsWith('s:') ? raw.slice(2) : raw;
    const unsigned = signedValue ? cookieSignature.unsign(signedValue, appConfig.cookieSecret) : false;

    if (!unsigned) {
      socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
      socket.destroy();
      return;
    }

    try {
      req.user = verifyAccessToken(unsigned);
    } catch {
      socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
      socket.destroy();
      return;
    }

    wsProxy.upgrade(req, socket, head);
  });
}
