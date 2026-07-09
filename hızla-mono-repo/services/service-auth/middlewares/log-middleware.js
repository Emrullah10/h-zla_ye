import helper from '@hizla/helper/index.js';

export default (router) => {
  router.use((req, _res, next) => {
    helper.log.info(`${req.method} ${req.url}`);
    next();
  });
};
