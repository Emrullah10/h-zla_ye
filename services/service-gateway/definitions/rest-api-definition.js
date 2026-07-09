const openApi = {
  openapi: '3.0.0',
  info: {
    title: 'hızla-gateway',
    version: '1.0.0',
    description: 'API Gateway for hızla-ye services',
  },
  'x-serviceDiscovery': {
    name: 'hizla-gateway',
    basePath: '/api',
    basePathPrefix: '',
  },
  paths: {
    '/api/gateway/refresh': {
      post: {
        summary: 'Refresh access token',
        operationId: 'refreshToken',
        responses: { '200': { description: 'Token refreshed' } },
      },
    },
    '/api/gateway/logout': {
      post: {
        summary: 'Logout',
        operationId: 'logout',
        responses: { '200': { description: 'Logged out' } },
      },
    },
    '/api/gateway/me': {
      get: {
        summary: 'Get current user',
        operationId: 'getMe',
        responses: { '200': { description: 'User info' } },
      },
    },
    '/app/health': {
      get: {
        summary: 'Health check',
        operationId: 'healthCheck',
        responses: { '200': { description: 'OK' } },
      },
    },
  },
};

export default openApi;
