import path from 'path';
import fs from 'fs/promises';
import init from './core-end-points.js';
import dsUtil from '../../datasource/connectors/util.js';

const { appRoutes, setServiceInfo } = init();
const obj = {
  arrayObjecter(array) {
    const base = {};
    if (Array.isArray(array) && array.length > 0) {
      for (const objt of array) {
        const key = Object.keys(objt);
        if (Array.isArray(key) && key.length === 1) {
          const k = key[0];
          base[k] = objt[k];
        }
      }
    }
    return base;
  },
  safeJsonParse: dsUtil.safeJsonParse,
  defineStandartProperties({ name, url, rootUrl, basePath, basePathPrefix }) {
    return { serviceName: name, url, rootUrl, basePath, basePathPrefix };
  },
};

async function readRouterFunctions(appFunctions) {
  const routerFunctions = { ...appFunctions };
  const rootDir = path.resolve();
  const apiFunctionsPath = path.join(rootDir, '/routes');
  const fileInDirectory = await fs.readdir(apiFunctionsPath);
  for (const element of fileInDirectory) {
    const filePath = path.join(apiFunctionsPath, element);
    const apiFunctions = await import(filePath);
    for (const [name, func] of Object.entries(apiFunctions)) {
      routerFunctions[name] = func;
    }
  }
  return routerFunctions;
}

async function prepareServiceInfo(openApi, serviceDiscovery) {
  try {
    let prefix;
    if (!openApi) return;
    const appFunctions = {};
    const info = {};
    info.routeList = [];
    const routes = {};

    const openApiJson = serviceDiscovery.createOpenApiDoc(openApi);
    if (!info.url) {
      info.url = openApiJson.servers[0].url;
      Object.assign(info, obj.arrayObjecter(openApiJson.info['x-serviceDiscovery']));
      prefix = `service:${info.basePath}`;
    }

    for (const [routePath, methods] of Object.entries(openApiJson.paths)) {
      const normalizedPath = routePath.replace(/{/g, ':').replace(/}/g, '');
      for (const [method, properties] of Object.entries(methods)) {
        const routeKey = `${normalizedPath}-${method}`;
        if (!routes[routeKey]) {
          routes[routeKey] = { ...obj.defineStandartProperties(info) };
          routes[routeKey].path = normalizedPath;
          routes[routeKey].method = method;
          routes[routeKey].functionName = properties['x-functionName'];
          Object.assign(routes[routeKey], obj.arrayObjecter(properties['x-serviceDiscovery'] || []));
        }
      }
    }

    info.routeList = Object.values(routes);
    for (const invRoute of Object.values(appRoutes)) {
      Object.assign(appFunctions, invRoute.routerFunctions);
      invRoute.key = prefix + invRoute.key;
      Object.assign(invRoute.element, obj.defineStandartProperties(info));
      info.routeList.push(invRoute.element);
    }

    const routerFunctionsRaw = await readRouterFunctions(appFunctions);
    let routerFunctions = { ...routerFunctionsRaw, ...routerFunctionsRaw.default };
    delete routerFunctions.default;
    setServiceInfo(info);
    return { info, routerFunctions, prefix };
  } catch (error) {
    console.error(error);
    throw error;
  }
}

export default { ...obj, prepareServiceInfo };
