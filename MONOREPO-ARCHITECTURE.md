# Monorepo Mimarisi — hızla_ye

> `MONOREPO-ARCHITECTURE-TEMPLATE.md` (Tropiq projesinden) hızla_ye projesine uyarlanmış hâlidir. Gerçek servis adları, portlar ve dosya yolları kullanılmıştır.

## 1. Genel Bakış

hızla_ye, **tek git reposu, tek kök `package.json`** altında birleşik gerçek bir monorepo'dur (kurye/yemek teslimat yönetimi):

- **`core/` + `services/`** — 5 servis (`service-auth`, `service-courier`, `service-onboarding`, `service-admin`, `service-gateway`), hexagonal/clean architecture ile `core/` + `services/` ayrımına sahip (gateway framework'e tam bağımlı olduğu için core/ karşılığı yok, bkz. §6).
- **`packages/modules/`** — tüm servislerin paylaştığı npm paketleri (`@hizla/*`, npm workspaces ile bağlı).
- **`hızla-web-app/`** — React 19 + Vite SPA, aynı workspace'in bir üyesi.

## 2. Üst Seviye Klasör Haritası

```
hızla_ye/                        # TEK git reposu, TEK kök package.json
├── core/                        # Framework-bağımsız iş mantığı (domain + application + infrastructure)
│   ├── service-auth/
│   ├── service-courier/
│   ├── service-onboarding/
│   └── service-admin/
├── services/                    # Çalıştırılabilir servis kabukları (main.js, container.js, configs)
│   ├── service-auth/            # port 3001
│   ├── service-courier/         # port 3002
│   ├── service-onboarding/      # port 3003
│   ├── service-admin/           # port 3004
│   └── service-gateway/         # port 4000 — core/ karşılığı yok, bkz. §6
├── packages/modules/            # Paylaşılan npm paketleri (@hizla/*)
│   ├── config/
│   ├── datasource/
│   ├── errors/
│   ├── helper/
│   ├── service-discovery/
│   └── service-registry/
├── db-schemas/                  # PostgreSQL şema tanımları (numaralı SQL dosyaları)
├── hızla-web-app/                # React 19 SPA — aynı workspace'in üyesi
├── docs/                          # Tarihsel/ikincil dokümanlar (git'e commit'lenmiyor, .gitignore'da)
├── package.json                   # workspaces: core/*, services/*, packages/modules/*, hızla-web-app
├── Dockerfile.e2e
└── docker-compose.e2e.yml         # Postgres + Redis + 4 servis + gateway, tek komutla
```

**Not (2026-07-09):** Önceki bir iterasyonda `hızla-mono-repo/` ve `hızla-gateway/` ayrı klasörlerdi; bu klasörler kaldırılıp içerikleri köke taşındı, tek `package.json` + tek git reposu haline getirildi.

## 3. core/ vs services/ Ayrımı

Her mikroservis için örnek: `service-auth`.

### 3.1 `core/service-auth/` — Framework'ten bağımsız iş mantığı

```
core/service-auth/
├── package.json          # name: @hizla/core-service-auth, exports: "./src/*"
└── src/
    ├── domain/            # Entity'ler, domain hataları (user.entity.js, user.errors.js)
    ├── application/        # Use-case'ler (login, logout, refresh — create*UseCase factory deseni)
    ├── infrastructure/      # Repository implementasyonları, SQL sorguları, tablo şemaları
    └── shared/               # Framework-bağımsız yardımcılar (crypto, validation)
```

`core/` içindeki dosyalar hiçbir zaman `datasources` singleton'ına veya Express `req/res`'e doğrudan erişmez — bağımlılıklar dışarıdan (composition root'tan) enjekte edilir.

### 3.2 `services/service-auth/` — Çalıştırılabilir kabuk

```
services/service-auth/
├── main.js                 # Process giriş noktası — @hizla/* paketlerini bare import ile çeker
├── package.json             # "imports": { "#core/*": "@hizla/core-service-auth/src/*" }
├── configs/                  # app-config.js, datasource-config.js (env okuma, 12factor-config)
├── src/
│   ├── container.js           # Composition root — core/ use-case'lerini datasource ile "wire" eder
│   ├── boot.js
│   └── interfaces/http/         # İnce HTTP adaptörü (auth.controller.js) — sadece req/res çevirisi yapar
├── middlewares/
├── routes/
└── test/{unit,integration}/      # #core/* subpath import ile core/'daki koda erişir
```

**Composition root (`container.js`) örneği:**
```js
import datasources from '@hizla/datasource/index.js';
import { UserRepositoryImpl } from '#core/infrastructure/persistence/repositories/user.repository-impl.js';
import createLoginUseCase from '#core/application/use-cases/auth/login.use-case.js';

export const buildContainer = (appConfig) => {
  const userRepository = new UserRepositoryImpl(datasources.coreAppDb);
  return { login: createLoginUseCase({ userRepository, redisClient: datasources.coreAppRedis.client }) };
};
```

`interfaces/http/auth.controller.js` artık sadece `buildContainer()`'ı çağırıp use-case'leri HTTP request/response'a bağlar — hiçbir iş mantığı içermez.

## 4. Paket Çözümleme — npm workspaces + subpath imports

hızla projesinde import çözümleme **iki mekanizma** ile yapılır (Tropiq'in relative-path yaklaşımından farklı olarak, Node.js'in workspace desteğinden yararlanılmıştır):

1. **`packages/modules/*` erişimi → bare specifier (`@hizla/*`)**
   Kök `package.json`:
   ```json
   "workspaces": ["core/*", "services/*", "packages/modules/*", "hızla-web-app"]
   ```
   npm install, her paketi `node_modules/@hizla/*` altına symlink'ler. Servisler artık `../../packages/modules/x` yerine `@hizla/x/index.js` yazar — dosya taşınsa da kırılmaz.

2. **`core/service-X/` erişimi → Node.js subpath imports (`#core/*`)**
   Her servisin `package.json`'ında:
   ```json
   "imports": { "#core/*": "@hizla/core-service-auth/src/*" }
   ```
   Node'un ESM `imports` alanı **paket sınırları dışına (`../`) çıkamadığı için**, `core/service-X` de bir workspace paketi (`@hizla/core-service-X`) olarak tanımlanmış, `exports: { "./src/*": "./src/*" }` ile alt yollarına izin verilmiştir.


## 5. packages/modules/ — Paylaşılan Kütüphaneler

| Paket | Amaç |
|---|---|
| `@hizla/config` | Env okuma (12factor-config) |
| `@hizla/datasource` | PostgreSQL + Redis connector'ları |
| `@hizla/errors` | Hata sınıfları + handleErrors |
| `@hizla/helper` | Log + genel yardımcılar |
| `@hizla/service-discovery` | Redis tabanlı servis kayıt/keşif |
| `@hizla/service-registry` | Gateway'e servis kaydı (`registerWithGateway`) |

## 6. services/service-gateway — Sınır Katmanı

Port **4000**. Auth (RSA-256 cookie imzalama), session/refresh, CSRF, rate limiting sadece gateway'de toplanmıştır — arkadaki servisler JWT doğrulamaz, gateway'in enjekte ettiği `X-User-Id` / `X-User-Role` header'larını okur. Servisler `service-discovery` ile Redis üzerinden kendilerini gateway'e kaydeder (`registerWithGateway`).

`service-gateway`'in `core/` karşılığı **yoktur** — tüm kodu (`auth/`, `middlewares/csrf-middleware.js`, `security-middleware.js`, `route.js`) doğrudan Express'e bağımlıdır, saf/framework-bağımsız bir iş mantığı katmanı barındırmaz. Kendi içinde bağımsız bir `packages/modules/` kopyasına sahiptir (kök `packages/modules/` ile karıştırılmamalı — gateway'in `datasource`/`config` implementasyonu farklıdır, örn. `pg` paketi yoktur, lazy import kullanır).

## 7. db-schemas/ — Şema Yapısı

Her servis kendi PostgreSQL şemasında yaşar: `auth`, `courier`, `onboarding`, `admin` + ortak `shared` şeması (enum/type'lar). Her servis `search_path=<kendi-şeması>,...,shared` ile bağlanır (`datasource-config.js`). Cross-schema foreign key'ler tam qualify edilmiş isimlerle yazılır (örn. `auth.users`).

## 8. docker-compose.e2e.yml — Orkestrasyon

Postgres + Redis + 4 mikroservis + gateway'i tek komutla ayağa kaldırır:

```
docker compose -f docker-compose.e2e.yml up
```

Prod'da her servis kendi `node main.js` process'i olarak (PM2 veya benzeri ile) bağımsız çalıştırılır — `docker-compose.e2e.yml` sadece izole, tekrar-üretilebilir bir e2e/geliştirme ortamı sağlar, prod dağıtım mekanizmasını değiştirmez.

## 9. Test Stratejisi

Her servis `test/{unit,integration}/` altında testlerini barındırır. Unit testler `#core/*` subpath import ile `core/`'daki saf iş mantığını DB/Redis olmadan test eder; integration testler gerçek Postgres/Redis'e karşı çalışır (`.env.test`). Kök `package.json`'daki `test:<servis>`, `test:<servis>:int`, `test:<servis>:all`, `test:all` script'leri bu ayrımı yansıtır.

## 10. docs/ — Tarihsel Dokümanlar

`docs/` klasörü, güncelliğini yitirmiş ama referans değeri olan eski dokümanları barındırır (`MONOREPO_STRUCTURE.md`, `MONOREPO_STRUCTURE_EN.md`, `gateaway-ARCHITECTURE.md`, `HIZLA-WEB-APP-PLAN.md`, `WEB-APPARCHITECTURE.md`). Bu klasör `.gitignore`'da — **git'e commit'lenmez**, sadece lokal geliştirme ortamında durur. Güncel/aktif mimari referansı her zaman kök `MONOREPO-ARCHITECTURE.md`'dir.

## 11. Bu mimariyi başka bir projeye taşırken

1. Her servisin `core/service-X/` + `services/service-X/` ayrımını kur, her ikisini de workspace üyesi yap.
2. `core/service-X/package.json`'a `exports: { "./src/*": "./src/*" }` ekle — subpath imports için zorunlu.
3. `services/service-X/package.json`'a `imports: { "#core/*": "@scope/core-service-X/src/*" }` ekle.
4. `services/service-X/src/container.js`'de composition root'u kur — `core/`'daki use-case'leri datasource ile "wire" et, controller'ı ince adaptöre indir.
5. Framework'e tam bağımlı servisleri (gateway gibi) `core/` ayrımına zorlama — sadece `services/` altında tut.
6. Her adımda `npm install` (workspace symlink'lerini yenilemek için) + test + `node main.js` ile doğrula — asla toplu dosya taşıma + toplu import replace aynı anda yapma.
