const openApi = {
  openapi: '3.0.0',
  info: {
    title: 'service-auth',
    version: '1.0.0',
    description: 'Hızla Ye Auth Service',
    'x-serviceDiscovery': [
      { name: 'service-auth' },
      { basePath: '/api/auth' },
      { basePathPrefix: '' },
      { url: 'http://127.0.0.1:4000' },
      { rootUrl: 'http://127.0.0.1:4000' },
    ],
  },
  paths: {
    '/api/auth/login': {
      post: {
        summary: 'Login',
        tags: ['auth'],
        'x-functionName': 'login',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['phone', 'password'],
                properties: {
                  phone: { type: 'string' },
                  password: { type: 'string' },
                },
              },
            },
          },
        },
        responses: {
          200: { description: 'Login success' },
          401: { description: 'Invalid credentials' },
        },
      },
    },
    '/api/auth/logout': {
      post: {
        summary: 'Logout',
        tags: ['auth'],
        'x-functionName': 'logout',
        security: [{ bearerAuth: [] }],
        responses: { 200: { description: 'Logged out' } },
      },
    },
    '/api/auth/refresh': {
      post: {
        summary: 'Refresh token',
        tags: ['auth'],
        'x-functionName': 'refresh',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['refreshToken'],
                properties: { refreshToken: { type: 'string' } },
              },
            },
          },
        },
        responses: {
          200: { description: 'New token' },
          401: { description: 'Invalid refresh token' },
        },
      },
    },
  },
  components: {
    securitySchemes: {
      bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
    },
  },
};

export default openApi;
