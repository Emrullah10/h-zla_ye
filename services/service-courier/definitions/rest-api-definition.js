const openApi = {
  openapi: '3.0.0',
  info: {
    title: 'service-courier',
    version: '1.0.0',
    description: 'Hızla Ye Courier Service',
    'x-serviceDiscovery': [
      { name: 'service-courier' },
      { basePath: '/api/courier' },
      { basePathPrefix: '' },
      { url: 'http://127.0.0.1:3002' },
      { rootUrl: 'http://127.0.0.1:3002' },
    ],
  },
  paths: {
    '/api/courier/order/active': { get: { summary: 'Get active order', tags: ['order'], 'x-functionName': 'getActiveOrder', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Active order' } } } },
    '/api/courier/order/{id}/accept': { post: { summary: 'Accept order', tags: ['order'], 'x-functionName': 'acceptOrder', security: [{ bearerAuth: [] }], parameters: [{ in: 'path', name: 'id', required: true, schema: { type: 'string' } }], responses: { 200: { description: 'Order accepted' } } } },
    '/api/courier/order/{id}/reject': { post: { summary: 'Reject order', tags: ['order'], 'x-functionName': 'rejectOrder', security: [{ bearerAuth: [] }], parameters: [{ in: 'path', name: 'id', required: true, schema: { type: 'string' } }], responses: { 200: { description: 'Order rejected' } } } },
    '/api/courier/order/{id}/verify': { post: { summary: 'Verify package QR', tags: ['order'], 'x-functionName': 'verifyPackage', security: [{ bearerAuth: [] }], parameters: [{ in: 'path', name: 'id', required: true, schema: { type: 'string' } }], responses: { 200: { description: 'Package verified' } } } },
    '/api/courier/order/{id}/rate': { post: { summary: 'Rate restaurant', tags: ['order'], 'x-functionName': 'rateRestaurant', security: [{ bearerAuth: [] }], parameters: [{ in: 'path', name: 'id', required: true, schema: { type: 'string' } }], responses: { 200: { description: 'Rated' } } } },
    '/api/courier/wallet': { get: { summary: 'Get wallet', tags: ['wallet'], 'x-functionName': 'getWallet', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Wallet data' } } } },
    '/api/courier/earnings': { get: { summary: 'Get earnings', tags: ['earnings'], 'x-functionName': 'getEarnings', security: [{ bearerAuth: [] }], parameters: [{ in: 'query', name: 'period', schema: { type: 'string', enum: ['weekly', 'monthly'] } }], responses: { 200: { description: 'Earnings data' } } } },
    '/api/courier/quests': { get: { summary: 'Get quests', tags: ['quests'], 'x-functionName': 'getQuests', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Quest list' } } } },
    '/api/courier/support': { post: { summary: 'Create support ticket', tags: ['support'], 'x-functionName': 'createSupportTicket', security: [{ bearerAuth: [] }], responses: { 201: { description: 'Ticket created' } } } },
  },
  components: { securitySchemes: { bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' } } },
};

export default openApi;
