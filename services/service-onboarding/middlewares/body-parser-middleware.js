import express from 'express';
export default (router) => {
  router.use(express.json({ limit: '10mb' }));
  router.use(express.urlencoded({ extended: true }));
};
