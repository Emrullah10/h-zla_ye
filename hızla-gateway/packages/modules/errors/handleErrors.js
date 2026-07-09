const HTTP_STATUS = {
  OK: 200,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  NOT_FOUND: 404,
  SERVER_ERROR: 500,
  FORBIDDEN: 403,
  CSRF_ERROR: 418,
};

export default {
  HTTP_STATUS,
  unRoutedRouteErrorHandler(app) {
    function handleRouteError(error, req, res, next) {
      console.log(error);
      if (error.message === 'UNAUTHORIZED') {
        return res.status(HTTP_STATUS.UNAUTHORIZED).json({ error: 'Unauthorized' });
      }
      try {
        decodeURIComponent(req.path);
      } catch (decodeError) {
        return res.status(HTTP_STATUS.SERVER_ERROR).json({ error: decodeError.message });
      }
      if (req.xhr) {
        return res.status(HTTP_STATUS.SERVER_ERROR).json({ error: 'Something failed!' });
      }
      if (error.statusCode === HTTP_STATUS.UNAUTHORIZED) {
        return res.status(HTTP_STATUS.UNAUTHORIZED).json({ error: 'Unauthorized' });
      }
      if (error.statusCode === HTTP_STATUS.BAD_REQUEST) {
        return res.status(HTTP_STATUS.BAD_REQUEST).json({ error: 'Bad request' });
      }
      if (error.statusCode === HTTP_STATUS.NOT_FOUND) {
        return res.status(HTTP_STATUS.NOT_FOUND).json({ error: 'Not found' });
      }
      res.status(HTTP_STATUS.SERVER_ERROR).json({ error: 'Something failed!' });
    }
    app.all('{*path}', (req, res, next) => {
      const errorContext = { path: req.path, method: req.method };
      console.error('Service error:', errorContext);
      next({ statusCode: HTTP_STATUS.NOT_FOUND });
    });
    app.use(handleRouteError);
  },
  routeFunctionErrorHandler(errorContext, error, next) {
    console.error(errorContext);
    next(error);
  },
  forbiddenErrorHandler(error, req, res, next) {
    if (!error) return next();
    return next({ statusCode: HTTP_STATUS.FORBIDDEN });
  },
};
