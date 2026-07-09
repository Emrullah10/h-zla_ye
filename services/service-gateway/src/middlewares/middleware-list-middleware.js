import { verifyAccessToken } from '../utils/token.js';

const PUBLIC_PATHS = ['/api/auth/login', '/app/health', '/openapi-ui/'];
function isPublicPath(url) {
  return PUBLIC_PATHS.some((p) => url.startsWith(p));
}

export function authenticateJwt(req, res, next) {
  const url = req.url || req.path;

  // CORS preflight'ı bypass
  if (req.method === 'OPTIONS') return next();

  // Public path'ler bypass
  if (isPublicPath(url)) return next();

  const accessToken = req.signedCookies?.accessToken || req.cookies?.accessToken;

  if (!accessToken) {
    return res.status(401).json({ status: 'error', message: 'Unauthorized' });
  }

  try {
    const decoded = verifyAccessToken(accessToken);
    req.user = decoded;
    next();
  } catch {
    return res.status(401).json({ status: 'error', message: 'Invalid or expired token' });
  }
}
