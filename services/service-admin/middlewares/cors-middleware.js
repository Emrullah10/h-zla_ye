import cors from 'cors';

export default (router) => {
  const gatewayUrl = process.env.GATEWAY_URL || 'http://127.0.0.1:4000';
  router.use(cors({ origin: gatewayUrl, methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'] }));
};
