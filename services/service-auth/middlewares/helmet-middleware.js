import helmet from 'helmet';

export default (router) => {
  router.use(helmet());
};
