export default function logMiddleware(req, res, next) {
  const userId = req.user?.userId || '-';
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url} ip=${req.ip} userId=${userId}`);
  next();
}
