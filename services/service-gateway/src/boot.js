import { addGatewayRoutes, setupProxyRoutes, setupDynamicProxyRoutes } from './route.js';
import { discoverAllServices, subscribeServiceRestart } from './modules/service-registry.js';

export default async function boot(app) {
  // Gateway kendi endpoint'leri (refresh, logout, me, health)
  addGatewayRoutes(app);

  // Servis discovery: Redis'te kayıtlı servisler varsa dinamik proxy kur
  const services = await discoverAllServices().catch(() => []);

  if (services.length > 0) {
    console.log(`Gateway: ${services.length} servis Redis'te bulundu — dinamik proxy kuruluyor`);
    setupDynamicProxyRoutes(app, services);
  } else {
    // Fallback: env-tabanlı statik proxy (Redis henüz dolu değil)
    console.log('Gateway: Redis boş — statik env proxy kullanılıyor');
    setupProxyRoutes(app);
  }

  // Pub/Sub: herhangi bir servis yeniden başlayınca route'ları yenile
  subscribeServiceRestart(async (data) => {
    console.log(`Gateway: servis yeniden başladı — ${data.name}, route'lar yenileniyor`);
    const fresh = await discoverAllServices().catch(() => []);
    if (fresh.length > 0) {
      // Express'in route stack'ini temizle ve yeniden ekle
      refreshRoutes(app, fresh);
    }
  });
}

function refreshRoutes(app, services) {
  // Dinamik olarak eklenmiş proxy route'ları temizle (gateway route'larına dokunma)
  const stack = app._router?.stack;
  if (!stack) return;
  // Proxy layer'ları — 'bound dispatch' olan ve içinde target olan middleware'ler
  for (let i = stack.length - 1; i >= 0; i--) {
    const layer = stack[i];
    if (layer?.handle?.target || layer?.handle?.name === 'bound dispatch') {
      stack.splice(i, 1);
    }
  }
  setupDynamicProxyRoutes(app, services);
  console.log('Gateway: proxy route\'ları güncellendi');
}
