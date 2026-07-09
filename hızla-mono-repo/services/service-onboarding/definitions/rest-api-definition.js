const openApi = {
  openapi: '3.0.0',
  info: {
    title: 'service-onboarding',
    version: '1.0.0',
    description: 'Hızla Ye Onboarding Service',
    'x-serviceDiscovery': [
      { name: 'service-onboarding' },
      { basePath: '/api/onboarding' },
      { basePathPrefix: '' },
      { url: 'http://127.0.0.1:3003' },
      { rootUrl: 'http://127.0.0.1:3003' },
    ],
  },
  paths: {
    '/api/onboarding/status': { get: { summary: 'Get onboarding status', tags: ['onboarding'], 'x-functionName': 'getStatus', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Status' } } } },
    '/api/onboarding/vehicle': { post: { summary: 'Select vehicle', tags: ['onboarding'], 'x-functionName': 'selectVehicle', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Vehicle selected' } } } },
    '/api/onboarding/document': { post: { summary: 'Upload document', tags: ['onboarding'], 'x-functionName': 'uploadDocument', security: [{ bearerAuth: [] }], responses: { 201: { description: 'Document uploaded' } } } },
    '/api/onboarding/training/complete': { post: { summary: 'Complete training', tags: ['onboarding'], 'x-functionName': 'completeTraining', security: [{ bearerAuth: [] }], responses: { 200: { description: 'Training completed' } } } },
  },
  components: { securitySchemes: { bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' } } },
};

export default openApi;
