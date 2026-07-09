import jwt from 'jsonwebtoken';
import fs from 'fs';
import appConfig from '../../packages/modules/config/index.js';
import datasources from '../../packages/modules/datasource/index.js';
import { REDIS_KEYS } from '../constants/index.js';
import { v4 as uuidv4 } from 'uuid';

function getPrivateKey() {
  return fs.readFileSync(appConfig.jwtPrivateKeyPath, 'utf8');
}

function getPublicKey() {
  return fs.readFileSync(appConfig.jwtPublicKeyPath, 'utf8');
}

async function deleteOldTokens(userId) {
  const redis = datasources.coreAppRedis.client;
  const pattern = `${REDIS_KEYS.TOKEN_PREFIX}:${userId}:*`;
  const keys = await redis.keys(pattern);
  if (keys.length > 0) {
    await redis.del(...keys);
  }
}

export async function createToken({ payload, response }) {
  const guid = uuidv4();
  const privateKey = getPrivateKey();

  const accessTokenPayload = {
    userId: payload.userId,
    role: payload.role,
    userPermissionList: payload.userPermissionList,
    guid,
  };

  const refreshTokenPayload = {
    userId: payload.userId,
    guid,
  };

  const accessExpiresSeconds = appConfig.jwtAccessExpiresMinutes * 60;
  const refreshExpiresSeconds = appConfig.jwtRefreshExpiresMinutes * 60;

  const accessToken = jwt.sign(accessTokenPayload, privateKey, {
    algorithm: 'RS256',
    expiresIn: accessExpiresSeconds,
  });

  const refreshToken = jwt.sign(refreshTokenPayload, privateKey, {
    algorithm: 'RS256',
    expiresIn: refreshExpiresSeconds,
  });

  // Redis'e yaz (eski token'ları önce sil)
  const redis = datasources.coreAppRedis.client;
  await deleteOldTokens(payload.userId);
  await redis.set(
    `${REDIS_KEYS.TOKEN_PREFIX}:${payload.userId}:${guid}`,
    refreshToken,
    'EX',
    refreshExpiresSeconds,
  );

  const isProd = appConfig.nodeEnv === 'production';
  const cookieOptions = {
    httpOnly: true,
    signed: true,
    sameSite: 'strict',
    secure: isProd,
  };

  response.cookie('accessToken', accessToken, { ...cookieOptions, maxAge: accessExpiresSeconds * 1000 });
  response.cookie('refreshToken', refreshToken, { ...cookieOptions, maxAge: refreshExpiresSeconds * 1000 });
}

export async function refreshTokenService({ req, res }) {
  const refreshToken = req.signedCookies?.refreshToken;
  if (!refreshToken) {
    return res.status(401).json({ status: 'error', message: 'No refresh token' });
  }

  try {
    const publicKey = getPublicKey();
    const decoded = jwt.verify(refreshToken, publicKey, { algorithms: ['RS256'] });

    // Redis'te hâlâ geçerli mi?
    const redis = datasources.coreAppRedis.client;
    const storedToken = await redis.get(`${REDIS_KEYS.TOKEN_PREFIX}:${decoded.userId}:${decoded.guid}`);
    if (!storedToken) {
      return res.status(401).json({ status: 'error', message: 'Token revoked' });
    }

    await createToken({
      payload: { userId: decoded.userId, role: decoded.role, userPermissionList: decoded.userPermissionList },
      response: res,
    });

    return res.json({ status: 'success' });
  } catch {
    return res.status(401).json({ status: 'error', message: 'Invalid refresh token' });
  }
}

export async function deleteTokenFromRedis(userId, guid) {
  const redis = datasources.coreAppRedis.client;
  await redis.del(`${REDIS_KEYS.TOKEN_PREFIX}:${userId}:${guid}`);
}

export function verifyAccessToken(token) {
  const publicKey = getPublicKey();
  return jwt.verify(token, publicKey, { algorithms: ['RS256'] });
}
