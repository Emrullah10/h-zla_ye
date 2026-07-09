import compression from 'compression';

export default (router) => {
  router.use(compression());
};
