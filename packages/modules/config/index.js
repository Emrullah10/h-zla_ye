import fs from 'fs';
import dotenv from 'dotenv';
import factorConfig from '12factor-config';
import log from '../helper/log/index.js';
const appConfig = {};
const overrideConfiguration = () => {
  try {
    if (
      (process.env.NODE_ENV || process.env.Node_Env || 'development') ===
      'development'
    ) {
      const envConfig = dotenv.parse(fs.readFileSync('../../.env'));
      for (const key in envConfig) {
        process.env[key] = envConfig[key];
      }
    }
  } catch (error) {
    log.error(error);
  }
};
const getAppPort = (url) => {
  const splittedUrl = url.split(':');
  return splittedUrl.pop();
};

export const createAppConfig = (factorConfigObj, factorDatasourceObj) => {
  overrideConfiguration();
  const config = factorConfig(factorConfigObj);
  config.port = getAppPort(config.url);
  let datasourceConfig = [];
  factorDatasourceObj.forEach((item) => {
    datasourceConfig.push(factorConfig(item));
  });
  let conf = { ...config, datasourceConfig };
  Object.keys(conf).forEach((key) => {
    appConfig[key] = conf[key];
  });
  return Object.freeze(appConfig);
};
export default appConfig;
