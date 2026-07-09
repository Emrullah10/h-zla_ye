import Postgre from './connectors/postgre.js';
import Redis from './connectors/redis.js';
import Rest from './connectors/rest.js';

const datasourceTypes = Object.freeze({
  rest: 'rest',
  postgre: 'postgre',
  redis: 'redis',
});

const datasourcesStore = {};

const createConnector = async (setting, applicationName) => {
  if (!setting.type) {
    throw new Error(
      `${setting.name} Datasource Config Error. Config is ${JSON.stringify(setting)}`,
    );
  }
  switch (setting.type) {
    case datasourceTypes.postgre:
      return Postgre(setting, applicationName);
    case datasourceTypes.rest:
      return new Rest(setting);
    case datasourceTypes.redis: {
      const connector = Redis(setting);
      connector.client = connector.letsPool();
      return connector;
    }
    default:
      return null;
  }
};

export const createDatasources = async ({ datasourceConfig, name }) => {
  for (const setting of datasourceConfig) {
    let connector = await createConnector(setting, name);
    if (connector[setting.name]) connector = connector[setting.name];
    datasourcesStore[setting.name] = connector;
  }
  return datasourcesStore;
};

if (typeof process !== 'undefined') {
  process.on('uncaughtException', console.error);
  process.on('unhandledRejection', console.error);
}

export default datasourcesStore;
