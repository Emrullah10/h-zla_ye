const openApi = {
  openapi: '3.0.0',
  info: {
    title: 'service-admin',
    version: '1.0.0',
    description: 'Hızla Ye Admin Service',
    'x-serviceDiscovery': [
      { name: 'service-admin' },
      { basePath: '/api/admin' },
      { basePathPrefix: '' },
      { url: 'http://127.0.0.1:3004' },
      { rootUrl: 'http://127.0.0.1:3004' },
    ],
  },
  paths: {
    '/api/admin/dashboard': { get: { summary: 'Admin dashboard stats', tags: ['admin'], 'x-functionName': 'getDashboard', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Dashboard data' } } } },
    '/api/admin/drivers': { get: { summary: 'List drivers', tags: ['admin'], 'x-functionName': 'getDrivers', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Driver list' } } } },
    '/api/admin/drivers/{id}/approve': { post: { summary: 'Approve driver', tags: ['admin'], 'x-functionName': 'approveDriver', security: [{ bearerAuth: [] }], parameters: [{ in: 'path', name: 'id', required: true, schema: { type: 'string' } }], responses: { 200: { description: 'Driver approved' } } } },
    '/api/admin/drivers/{id}/reject': { post: { summary: 'Reject driver', tags: ['admin'], 'x-functionName': 'rejectDriver', security: [{ bearerAuth: [] }], parameters: [{ in: 'path', name: 'id', required: true, schema: { type: 'string' } }], responses: { 200: { description: 'Driver rejected' } } } },
  },
  components: { securitySchemes: { bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' } } },
};

export default openApi;
