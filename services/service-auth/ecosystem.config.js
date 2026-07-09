export default {
  apps: [
    {
      name: 'service-auth',
      script: './main.js',
      watch: false,
      env: { NODE_ENV: 'development' },
      env_production: { NODE_ENV: 'production' },
    },
  ],
};
