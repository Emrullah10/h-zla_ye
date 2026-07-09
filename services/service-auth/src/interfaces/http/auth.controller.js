import { buildContainer } from '../../container.js';

export default function authController(appConfig) {
  const { login, logout, refresh } = buildContainer(appConfig);

  return {
    async login(req, res, next) {
      try {
        const result = await login(req.body);
        res.json(result);
      } catch (err) {
        next(err);
      }
    },

    async logout(req, res, next) {
      try {
        const token = req.headers.authorization?.replace('Bearer ', '');
        await logout({ token });
        res.json({ message: 'Logged out' });
      } catch (err) {
        next(err);
      }
    },

    async refresh(req, res, next) {
      try {
        const result = await refresh(req.body);
        res.json(result);
      } catch (err) {
        next(err);
      }
    },
  };
}
