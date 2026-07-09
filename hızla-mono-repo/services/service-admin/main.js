import express from 'express';
import datasources, { createDatasources } from '@hizla/datasource/index.js';
import appConfig, { createAppConfig } from '@hizla/config/index.js';
import serviceDiscovery from '@hizla/service-discovery/index.js';
import { registerWithGateway } from '@hizla/service-registry/index.js';
import helper from '@hizla/helper/index.js';
import rawAppConfig from './configs/app-config.js';
import rawDatasourceConfig from './configs/datasource-config.js';
import middlewareFactory from './middlewares/index.js';
import boot from './src/boot.js';
import openApi from './definitions/rest-api-definition.js';

async function initialize() {
  const app = express();

  createAppConfig(rawAppConfig, rawDatasourceConfig);

  if (appConfig?.nodeEnv !== 'production') {
    global.logMode = 'trace';
  }

  await createDatasources(appConfig).catch((error) => {
    console.error(error);
    helper.application.exitOnError(error);
    process.exit(1);
  });

  const serviceDiscoveryInstance = await serviceDiscovery(
    app,
    openApi,
    datasources.serviceDiscoveryRedis,
    datasources.coreAppRedis,
  ).catch((error) => {
    console.error(error);
    helper.application.exitOnError(error);
    process.exit(1);
  });

  app.use(middlewareFactory(appConfig, serviceDiscoveryInstance, openApi));

  app.listen(appConfig.port);
  helper.application.appStarted(appConfig);

  registerWithGateway({
    name: appConfig.name,
    url: appConfig.url,
    basePath: appConfig.basePath,
    redisClient: datasources.serviceDiscoveryRedis.client,
  }).catch(console.error);

  await boot().catch((error) => {
    console.error(error);
    helper.application.exitOnError(error);
  });
}

initialize();
