import express from 'express';
import { createDatasources } from './packages/modules/datasource/index.js';
import appConfig, { createAppConfig } from './packages/modules/config/index.js';
import helper from './packages/modules/helper/index.js';
import rawAppConfig from './configs/app-config.js';
import rawDatasourceConfig from './configs/datasource-config.js';
import middlewareFactory from './src/middlewares/index.js';
import boot from './src/boot.js';
import { setupWsProxy } from './src/middlewares/ws-proxy.js';

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

  app.use(middlewareFactory());

  await boot(app).catch((error) => {
    console.error(error);
    helper.application.exitOnError(error);
  });

  const server = app.listen(appConfig.port, () => {
    console.log(`HIZLA_GATEWAY_READY on Port: ${appConfig.port}`);
  });

  setupWsProxy(server, app);
}

initialize();
