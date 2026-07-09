import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export const hashPassword = (password) => bcrypt.hash(password, 10);

export const comparePassword = (password, hash) => bcrypt.compare(password, hash);

export const signJwt = (payload, secret, expiresIn) =>
  jwt.sign(payload, secret, { expiresIn });

export const verifyJwt = (token, secret) => jwt.verify(token, secret);

export const verifyJwtRS256 = (token, publicKey) =>
  jwt.verify(token, publicKey, { algorithms: ['RS256'] });
