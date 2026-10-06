# Hızla — Monorepo Mimari Geçiş Planı

> **Sürüm 1.0 · 2026-10-06** · Hedef sözleşme: [`docs/reference/MONOREPO-ARCHITECTURE-TEMPLATE.md`](reference/MONOREPO-ARCHITECTURE-TEMPLATE.md) (şablon **v2.0**, 2026-09-27)
> Kardeş dokümanlar: [Tasarım Sistemi](design/HIZLA-TASARIM-SISTEMI.md) · [Fizibilite ve Rakip Raporu](reports/HIZLA-FIZIBILITE-VE-RAKIP-RAPORU.md) · [Karar kaydı](DECISIONS.md)

Bu doküman, hızla_ye reposunun bugünkü hâlini beğendiğin Tropiq şablonunun **v2.0** sürümüyle karşılaştırır, aradaki farkları listeler ve hedef yapıya faz faz nasıl geçileceğini planlar. Kod değişikliği içermez; her faz ayrı bir iş olarak uygulanır.

---

## 0. Özet: ne değişiyor

1. **`core/` ile `services/` rolleri tersine dönüyor.** Bugünkü yapı şablonun eski (v1.0) anlatımına göre kuruldu: iş mantığı `core/` altında, `services/` ince kabuk. Şablon v2.0 bunun yanlış olduğunu söylüyor: `core/` = tablolardan **üretilen auto-CRUD tabanı** (iş mantığı yok, tek değişen dosya `table-definitions.js`), `services/` = **elle yazılan DDD servisi** (domain, use-case, repository, http). Bugünkü `core/service-*/src/{domain,application,infrastructure}` içeriği `services/hizla-service-*/src/` altına taşınacak.
2. **Domain haritası ürüne göre yeniden çiziliyor.** Bugün 4 servis var (auth, courier, onboarding, admin) ve `courier` servisi sipariş, cüzdan, görev ve destek gibi ayrı alanları tek başına taşıyor. Hedefte 8 domain servisi + gateway var (Faz 2'de gerçek zamanlı katman için 9. servis); **işletme (merchant)**, **slot/vardiya (shift)**, **teslimat/dispatch (delivery)**, **finans (finance)** ve **platform entegrasyonu (integration)** ilk kez kendi sınırlarına kavuşuyor. `admin` bir servis olmaktan çıkıp bir **rol ailesine** dönüşüyor.
3. **Veritabanı şablon kurallarına göre baştan yazılıyor.** UUID + kolon öneksiz tablolar ve Postgres `ENUM` tipleri yerine: `BIGINT IDENTITY` + `global_code_seq`, tablo adıyla öneklenmiş kolonlar, `tenant_code` / `organization_id` kapsam kolonları, `enums.*` sözlük tabloları, migration defteri. Proje henüz üretimde olmadığı için taşıma yerine **yeniden kurulum** öneriliyor (bkz. §5.1).
4. **Kimlik, izin ve oturum şablonun gateway modeline geçiyor.** RS256 JWT çerezi + Redis oturumu + çift CSRF çerezi (`hizla_csrf` / `hizla_xsrf`) + route registry'de izin kontrolü + `userAccount*` kimlik başlıkları. Servisler kimlik doğrulamaz, gateway'e güvenir.
5. **Kök altyapı tamamlanıyor:** `docker-compose.dev.yml`, `scripts/` (build-schema, apply-migrations, update.sh...), Jest test altyapısı, Playwright E2E, PM2 manifesti, GitHub Actions CI, `docs/` git'te izleniyor, `.env.test` repodan çıkıyor.
6. **İki uygulama klasörü ASCII ada geçiyor:** `hızla-web-app/` → `hizla-web-app/`, `hizla_mobile/` → `hizla-mobile-app/` (Flutter paket adı `hizla_mobile` olarak kalır). Klasör adındaki `ı`, Docker, PM2, CI ve URL'lerde gereksiz kaçış sorunları çıkarıyor.

Tahmini toplam efor (tek geliştirici + AI ajanı): **35–50 iş günü**, 11 faza bölünmüş (§12). Her faz kendi "Bitti sayılır" komutlarıyla kapanır. Bundan önce, bugünkü kodda bulunan güvenlik ve akış kusurları için **1 günlük acil düzeltme fazı (F−1)** öneriliyor (§1.1).

---

## 1. Bugünkü durum (2026-10-06, `main` @ `54d2b52a`)

```
hızla_ye/
├── core/service-{auth,courier,onboarding,admin}/      # İŞ MANTIĞI burada (v1.0 anlayışı)
│   └── src/{domain,application,infrastructure,shared}
├── services/
│   ├── service-auth/        :3001   POST /api/auth/{login,logout,refresh}
│   ├── service-courier/     :3002   /api/courier/{earnings,wallet,quests,support,order/*} + WS /ws
│   ├── service-onboarding/  :3003   /api/onboarding/{document,status,vehicle,training/complete}
│   ├── service-admin/       :3004   /api/admin/{dashboard,drivers,drivers/{id}/approve|reject}
│   └── service-gateway/     :4000   RSA cookie + CSRF + proxy + WS proxy; KENDİ packages/ kopyası var
├── packages/modules/{config,datasource,errors,helper,service-discovery,service-registry}  (@hizla/*)
├── db-schemas/00..05-*.sql + combined-schema.sql + migrations/
│     şemalar: shared (ENUM tipleri), auth, courier, onboarding, admin
├── hızla-web-app/           # React 19 + Vite + MUI, kurye + admin ekranları (Kinetic Nocturne teması)
├── hizla_mobile/            # Flutter (MVVM + Riverpod) kurye uygulaması
├── keys/public.pem          # gateway açık anahtarı (commit'li)
├── .env.example  .env.test  # .env.test git'te izleniyor
├── Dockerfile.e2e  docker-compose.e2e.yml  eslint.config.js
└── MONOREPO-ARCHITECTURE.md # v1.0 anlayışıyla yazılmış mimari özeti
```

**Veri modeli bugün:** `auth.users`, `courier.{couriers, orders, order_ratings, support_tickets, wallet, transactions, quests, courier_quests}`, `onboarding.{applications, documents, training_completions}`, `admin.admin_actions`. Roller: `courier`, `admin`. İşletme (restoran/firma), slot/vardiya, bölge, hakediş/ödeme, fatura ve platform entegrasyonu için tablo **yok**. Sipariş tablosunda restoran yalnızca `restaurant_name` metni.

**Test:** Backend `node:test` (auth 15 unit + 5 integration, courier 29, onboarding 11, admin 7); web Vitest (6 dosya, 13 test); mobil `flutter_test` (2 dosya, 8 test, yalnızca interceptor'lar). Gateway, `packages/`, sayfalar ve ekranlar testsiz. CI yok, `scripts/` yok.

### 1.1 Kod okumasıyla bulunan kritik kusurlar

Bu bulgular kod okumasıyla tespit edildi; servisler çalıştırılmadı. İlk ikisi ayrıca elle doğrulandı. Geçişi beklemeden düzeltilmeleri önerilir (§12, F−1).

| # | Kusur | Kanıt | Etki |
|---|---|---|---|
| K1 | **Rol bazlı yetkilendirme yok.** Gateway yalnızca token doğruluyor; admin servisi yalnızca `x-user-id` varlığına bakıyor | `services/service-admin/src/shared/utils/auth-middleware.js` (rol okunuyor ama kontrol edilmiyor); gateway'de izin kontrolü yok | Giriş yapmış herhangi bir kurye `/api/admin/drivers/{id}/approve` çağırabilir |
| K2 | **Kurye onayı DB hatasıyla düşüyor.** Sorguda 4 yer tutucu, 3 değer var; onay transaction'sız | `core/service-admin/.../admin.queries.js` `createCourierForApprovedUser` | Başvuru `approved` olur ama kurye ve cüzdan satırı oluşmaz; kurye uçları "Courier not found" döner |
| K3 | Hiçbir kod yolu siparişi `delivered`'a geçirmiyor; `createOrder` QR üretmiyor | `verify` → `picked_up`; `rate` `delivered` şartı arıyor | Teslimat, puan ve kazanç döngüsü uçtan uca tamamlanamıyor |
| K4 | Sipariş uçlarında sahiplik kontrolü yok (IDOR) | accept/reject/verify/rate | Bir kurye başka kuryenin siparişini değiştirebilir |
| K5 | Refresh sonrası rol kaybı; access ömrü (48 sa) refresh ömründen (24 sa) uzun | `services/service-gateway/src/utils/token.js`, `configs/app-config.js` | Yenilenen oturumda rol `undefined`; şablonun config guard'ı bunu açılışta reddederdi (§9.9) |
| K6 | CSRF token'ı `Math.random()` ile üretiliyor; kontrol `onProxyReq` içinde | gateway CSRF | Zayıf token; isteğin upstream'e yine gitme ihtimali |
| K7 | Web giriş formu admin kimlik bilgileriyle önceden dolu | `LoginForm.jsx` | Seed şifresi istemci paketine giriyor |
| K8 | İstemci ↔ API alan adı uyuşmazlıkları | web `IncomingOrderOverlay` (`order.id` ↔ `orderId`), `QuestList`, `WalletSummary`; iki istemcide destek kategorisi Türkçe etiket ↔ DB enum | Kabulde `/order/undefined/accept`; destek talebi hata alır |
| K9 | `.env.example`'da `SERVICE_AUTH_REST_URL` gateway portunu (4000) gösteriyor | `.env.example` | Port URL'den türetildiği için auth 4000'de açılmaya çalışır |
| K10 | E2E compose şeması `\i` göreli include'larla yükleniyor, diğer SQL dosyaları mount edilmiyor; gateway private key'i container'a girmiyor | `docker-compose.e2e.yml`, `combined-schema.sql` | E2E yığını büyük olasılıkla ayağa kalkmıyor (çalıştırılmadı) |

Bu tablonun kendisi, şablonun neden "varsayılan kapalı" (fail-closed) kurallar koyduğunu gösteriyor: izni tanımlanmamış route 500, registry'de olmayan route 404, kapsam kolonu olmayan tablo okunamaz. Hedef mimaride K1, K4 ve K5 sınıfı hatalar yapısal olarak önlenir.

---

## 2. Şablon v2.0 ile fark analizi

| # | Konu | Şablon v2.0 | Hızla bugün | Etki | Aksiyon (faz) |
|---|---|---|---|---|---|
| 1 | `core/` rolü | Üretilen auto-CRUD; yalnızca `table-definitions.js` düzenlenir | Elle yazılmış domain + use-case + repository | **Yüksek**: tüm servis kodunun yeri değişir | İş mantığını `services/`'e taşı, `core/`'u iskeletten üret (F5–F7) |
| 2 | Servis adları | `services/hizla-service-<domain>`, gateway `hizla-web-gateway` | `service-auth`, `service-gateway` | Orta | Yeniden adlandır (F5–F7) |
| 3 | API yolu | `/api/hizla-service-<domain>/v1/...` | `/api/auth/login`, `/api/courier/...` | Orta: web + mobil API sabitleri | `api-constant` dosyaları (F8) |
| 4 | Portlar | Gateway `<PORT_BASE>`, servisler `+1`'den | Gateway 4000, servisler 3001–3004 | Düşük | `PORT_BASE=4000` seç; gateway portu korunur (D-03) |
| 5 | Paket adları | `app-config`, `app-shared`, `app-datasource`... | `@hizla/config`... | Orta | Şablon adlarına geç; referanstan kopyalanabilirlik (D-04) |
| 6 | Eksik paketler | `entity-factory`, `example-builder`, `language`, `middlewares`, `shared`, `persistence-utils`, `query-builder` | yok | **Yüksek** | Referanstan kopyala (F2) |
| 7 | Gateway'in kendi `packages/` kopyası | yok; gateway kök paketleri kullanır | `services/service-gateway/packages/modules/*` | Orta: iki ayrı config/datasource davranışı | Sil, kök paketleri kullan (F6) |
| 8 | DB kimlikleri | `BIGINT IDENTITY` + `<t>_code` (`global_code_seq`) | `UUID` | Yüksek | Yeniden kurulum (F3) |
| 9 | Kolon adları | Tablo adıyla önekli (`delivery_status`) | Öneksiz (`status`) | Yüksek: query-builder buna dayanır | Yeniden kurulum (F3) |
| 10 | Durum değerleri | `enums.<ad>` tablosuna FK | Postgres `ENUM` tipleri (`shared.*`) | Orta | `enums` şeması (F3) |
| 11 | Çok kiracılık | `identity.tenant` + `identity.organization`; her tabloda kapsam kolonu | yok | **Yüksek**: işletme paneli için şart | (F3, F5) |
| 12 | Migration | Defterli runner (`public.schema_migrations`), `YYYY-MM-DD-N-*.sql` | `psql -f combined-schema.sql` | Orta | `scripts/apply-migrations.mjs` (F3) |
| 13 | Şema üretimi | `scripts/build-schema.js` → `_combined.sql` (gitignore) | `combined-schema.sql` commit'li | Düşük | (F3) |
| 14 | İzin modeli | `PERMISSIONS` kataloğu + `enums.role_permission` + gateway route kontrolü | Rol kontrolü servis içinde, 2 rol | Yüksek | §6 kataloğu (F2, F5, F6) |
| 15 | Kimlik başlıkları | `userAccountId`, `...OrganizationId`, `...Role`, `...PermissionList`... | `X-User-Id`, `X-User-Role` | Orta | (F6) |
| 16 | Oturum | Redis `session:<sid>`, refresh index, iptal | RSA cookie + refresh, Redis kısmi | Orta | Referans gateway (F6) |
| 17 | JWT anahtarı | Repo dışında, `JWT_*_KEY_PATH` | `keys/public.pem` commit'li (private yok) | Düşük | `secrets/` + env yolu (F1, F6) |
| 18 | Test | Jest 29, worker başına test DB, üretilen 3 test + kablolama testi + drift testi | `node:test`, 19 dosya | Orta | Jest'e geç; eski testler geçişte `test:legacy` (F4) |
| 19 | E2E | Playwright + compose + `e2e/run.js` | Compose dosyası var, Playwright yok | Orta | (F9) |
| 20 | Yerel DB | `docker-compose.dev.yml` (TimescaleDB pg18 + Redis 7) | DBngin + elle `arch_redis` | Düşük | (F1) |
| 21 | Çalıştırma | PM2 `scripts/ecosystem.config.cjs`, gateway en son | `npm run start:*` tek tek | Düşük | (F1) |
| 22 | Dağıtım | `ecosystem.config.cjs` + `scripts/update.sh` (build → migration → pm2) | yok | Orta | (F10) |
| 23 | CI | Asgari CI zorunlu | yok | Orta | GitHub Actions (F10) |
| 24 | `docs/` | Git'te izlenir | `.gitignore`'da | Düşük | Bu plan ile çözüldü: yalnızca eski 5 dosya ignore'da |
| 25 | `.env.test` | İzlenmez; `.env.test.example` izlenir | İzleniyor | Düşük | (F1) |
| 26 | Frontend dizinleri | `features/<domain>`, `shared/{auth,translation,...}`, `styles/` SCSS token'ları, MUI wrapper'ları, i18n | Kısmen var; i18n yok, inline style + CSS var'ları | Orta | (F8) |
| 28 | Mobil | Şablonda yok | Flutter uygulaması var | — | §10'da proje eki |
| 29 | Gerçek zamanlı | Şablonda yok | Gateway WS proxy + courier WS | — | §8'de proje eki |

---

## 3. Hedef domain haritası

### 3.1 Aktörler ve yüzeyler

| Aktör | Yüzey | Ne yapar |
|---|---|---|
| **Kurye** | `hizla-mobile-app` (Flutter) | Başvuru, slot alma/bırakma/takas, çevrimiçi olma, teklif kabul/ret, teslim alma (QR/PIN), teslim etme (foto/PIN), kazanç ve hakediş, destek |
| **İşletme** (restoran, market, mağaza; çok şubeli olabilir) | `hizla-web-app` → `/isletme` (tablet öncelikli) | Teslimat isteği (elle ya da Yemeksepeti/Getir/Trendyol'dan otomatik), canlı kurye takibi, hazırlık süresi, fatura, değerlendirme, şube ve kullanıcı yönetimi |
| **Operasyon** (dispatcher, bölge sorumlusu, destek, finans) | `hizla-web-app` → `/operasyon` (masaüstü) | Canlı harita, teslimat panosu, istisna yönetimi, slot kapasite planı, kurye başvuruları, fiyat kuralları, hakediş ve fatura, raporlar |
| **Son müşteri** | Public takip sayfası `/t/<token>` | Kuryenin konumu ve tahmini varış (kişisel veri göstermeden) |

### 3.2 Servis tablosu (`docs/DECISIONS.md`'ye girer)

`PORT_BASE = 4000`. Portlar oluşturulma sırasıyla atanır ve bir daha değişmez.

| Servis | Şema(lar) | Port | Sahip olduğu tablolar | Bugünkü karşılığı |
|---|---|---|---|---|
| `hizla-web-gateway` | — | 4000 | — (Redis: oturum, registry) | `service-gateway` |
| `hizla-service-identity` | `identity` | 4001 | `tenant`, `organization`, `user_account`, `user_device`, `user_consent` | `service-auth` |
| `hizla-service-app` | `enums`, `reference`, `support`, `audit` | 4002 | sözlükler, `city`, `district`, `zone`, `platform`, `vehicle_type`, `support_ticket`, `support_message`, `audit_log` | `admin.admin_actions`, `courier.support_tickets` |
| `hizla-service-courier` | `courier` | 4003 | `courier`, `courier_application`, `courier_document`, `courier_training`, `courier_vehicle`, `courier_status_event`, `courier_location_ping` (hypertable), `courier_score` | `service-courier` (profil, konum) + `service-onboarding` |
| `hizla-service-merchant` | `merchant` | 4004 | `merchant_profile`, `merchant_branch`, `merchant_platform_account`, `merchant_contract` | yok |
| `hizla-service-shift` | `shift` | 4005 | `slot_plan`, `slot`, `slot_booking`, `slot_swap_offer`, `slot_attendance`, `courier_priority` | yok |
| `hizla-service-delivery` | `delivery` | 4006 | `delivery`, `delivery_event`, `delivery_offer`, `delivery_batch`, `delivery_proof`, `delivery_rating`, `delivery_issue`, `tracking_link` | `courier.orders`, `courier.order_ratings` |
| `hizla-service-finance` | `finance` | 4007 | `price_rule`, `courier_earning`, `courier_earning_line`, `incentive`, `incentive_progress`, `payout_batch`, `payout`, `merchant_invoice`, `merchant_invoice_line`, `ledger_entry` | `courier.{wallet,transactions,quests,courier_quests}` |
| `hizla-service-integration` | `integration` | 4008 | `platform_connection`, `external_order`, `webhook_inbox`, `outbound_status_push` | `POST /courier/order` test ucu |
| *(Faz 2+)* `hizla-service-realtime` | — | 4009 | — (Redis pub/sub → WS) | courier servisindeki WS |

Şema sahipliği kuralı (şablon §4.1): her şemaya yalnızca sahibi servis yeni yazım yolu açar. Örneğin teslimat tamamlandığında `finance.courier_earning` satırını **delivery yazmaz**; delivery, commit sonrası finance'in internal ucunu çağırır ya da outbox satırı bırakır (§7.4).

### 3.3 Bağlam haritası

```
                 ┌───────────────────────┐
  Yemeksepeti ──▶│ integration           │──(internal: createDelivery)──┐
  Getir       ──▶│ webhook_inbox,        │◀─(outbox: statusPush)────────┤
  Trendyol    ──▶│ external_order        │                              │
                 └───────────────────────┘                              ▼
 ┌──────────┐ şube, hazırlık süresi  ┌──────────────────────────────────────────┐
 │ merchant │───────────────────────▶│ delivery                                  │
 └──────────┘                        │ delivery → offer → pickup → dropoff        │
 ┌──────────┐ aktif slot, kapasite   │ dispatch motoru, batch, ETA, takip linki   │
 │  shift   │───────────────────────▶│                                            │
 └──────────┘                        └───────┬──────────────────────┬────────────┘
 ┌──────────┐ çevrimiçi, konum, puan         │ teslim edildi        │ olaylar
 │ courier  │◀──────────────────────────────▶│ (outbox)             ▼
 └──────────┘                                ▼                  realtime (WS)
                                       ┌──────────┐            kurye · işletme · operasyon
                                       │ finance  │ kazanç satırı, fatura satırı, teşvik
                                       └──────────┘
  identity: kim, hangi organizasyon, hangi izin      app: sözlük, bölge, destek, audit
```

---

## 4. Hedef klasör ağacı

```
hizla-mono-repo/   (klasör adı değişmek zorunda değil; repo adı h-zla_ye kalabilir)
├── core/                                   # ÜRETİLEN auto-CRUD tabanı. İş mantığı YOK.
│   ├── service-identity/   service-app/   service-courier/   service-merchant/
│   ├── service-shift/      service-delivery/   service-finance/   service-integration/
│   │   └── (her biri) package.json · definitions/ · routes/rest-routes.js · test/helpers/
│   │       src/{domain,application/use-cases,infrastructure/persistence/{init-query-builder.js,
│   │            repositories/,schemas/table-definitions.js},interfaces/http}/index.js
├── services/                               # ELLE yazılan servisler + gateway
│   ├── hizla-web-gateway/
│   ├── hizla-service-identity/
│   ├── hizla-service-app/
│   ├── hizla-service-courier/
│   ├── hizla-service-merchant/
│   ├── hizla-service-shift/
│   ├── hizla-service-delivery/
│   │   ├── main.js · package.json · configs/{app-config.js,datasource-config.js}
│   │   ├── definitions/rest-api-definition.js · routes/rest-routes.js · middlewares/index.js
│   │   └── src/
│   │       ├── boot.js                      # port kurulumları + cron (offer timeout taraması, SLA)
│   │       ├── container.js                 # composition root (dondurulmuş harita)
│   │       ├── domain/
│   │       │   ├── errors/{domain-error.js,infrastructure-error.js}
│   │       │   ├── delivery/{index.js,delivery-status.js,eta.js,proof-policy.js}
│   │       │   └── dispatch/{scoring.js,batching.js,fairness.js}
│   │       ├── application/use-cases/
│   │       │   ├── delivery/{create-delivery,mark-ready,cancel-delivery,...}.use-case.js
│   │       │   ├── dispatch/{run-dispatch,offer-to-courier,accept-offer,expire-offers}.use-case.js
│   │       │   └── courier-flow/{confirm-pickup,confirm-dropoff,report-issue}.use-case.js
│   │       ├── infrastructure/persistence/{repositories/,sql/}
│   │       ├── interfaces/http/{index.js,delivery.js,dispatch.js,translate-domain-error.js}
│   │       └── shared/{constants/,utils/}
│   ├── hizla-service-finance/
│   └── hizla-service-integration/
│       └── src/adapters/{yemeksepeti/,getir/,trendyol/}   # port/adaptör (§9)
├── packages/
│   ├── modules/{config,datasource,entity-factory,errors,example-builder,helper,
│   │            language,middlewares,service-discovery,shared}
│   ├── persistence-utils/
│   ├── query-builder/
│   └── design-tokens/                       # tokens.json → web SCSS + Flutter Dart (Tasarım §10)
├── db-schemas/                              # §5
├── scripts/{build-schema.js,apply-migrations.mjs,build-role-permission-seed.js,
│            validate-auth-config.js,sync-role-permissions.mjs,env-to-json.mjs,
│            ecosystem.config.cjs,start-backend.sh,update.sh}
├── test/{config/,services/<servis>/{configs,unit,integration,e2e,custom}/,services/repo/}
├── e2e/{run.js,playwright.config.js,helpers/,tests/{merchant,ops,courier-api}/}
├── hizla-web-app/                           # React SPA: /isletme + /operasyon (+ public /t/:token)
├── hizla-mobile-app/                        # Flutter kurye uygulaması (paket adı hizla_mobile)
├── docs/{ARCHITECTURE.md,DECISIONS.md,ARCHITECTURE-PLAN.md,design/,reports/,research/,reference/}
├── secrets/                                 # gitignore: jwt-private.pem, jwt-public.pem, fcm.json
├── docker-compose.dev.yml  docker-compose.e2e.yml  Dockerfile.e2e  .dockerignore
├── ecosystem.config.cjs  jest.config.js  eslint.config.js  package.json  package-lock.json
├── .env.example  .env.test.example  README.md  TEST-GUIDE.md
└── .github/workflows/ci.yml
```

### 4.1 Bugünden hedefe dosya taşıma haritası

| Bugün | Hedef | Not |
|---|---|---|
| `core/service-auth/src/{domain,application,infrastructure}` | `services/hizla-service-identity/src/...` | Use-case'ler `make<Eylem>(deps)` biçimine çevrilir |
| `services/service-auth/{main.js,configs,routes,definitions}` | `services/hizla-service-identity/...` | `main.js` şablondaki ortak sürümle değişir |
| — | `core/service-identity/` | §7.2 şablonlarından + `table-definitions.js` |
| `services/service-courier` + `core/service-courier` (profil, konum, durum) | `hizla-service-courier` | |
| ″ (sipariş, kabul/ret, QR doğrulama, puan) | `hizla-service-delivery` | `courier.orders` → `delivery.delivery` |
| ″ (cüzdan, işlemler, kazanç, görevler) | `hizla-service-finance` | Cüzdan bakiyesi tutulmaz; defterden türetilir (§7.3) |
| ″ (destek talepleri) | `hizla-service-app` → `support` şeması | İşletme de talep açabilir |
| ″ (WS sunucusu) | Faz 1: `hizla-service-delivery`; Faz 2: `hizla-service-realtime` | §8 |
| `services/service-onboarding` + `core/service-onboarding` | `hizla-service-courier` (başvuru alt alanı) | Başvuru kurye yaşam döngüsünün parçası |
| `services/service-admin` + `core/service-admin` | dağıtılır: onay/ret → courier; panel istatistikleri → her servisin `/v1/ops/*` uçları; `admin_actions` → `audit.audit_log` | `admin` artık rol ailesi (§6) |
| `services/service-gateway` (+ kendi `packages/`) | `services/hizla-web-gateway` | Referans gateway + `ws-proxy.js` taşınır |
| `packages/modules/service-registry` | kaldırılır | `app-service-discovery` aynı işi yapar |
| `packages/modules/*` (`@hizla/*`) | `packages/modules/*` (`app-*`) | §6.1 envanteri |
| `db-schemas/*.sql`, `combined-schema.sql` | yeni numaralı dosyalar (§5.2) | Eskiler git geçmişinde kalır |
| `hızla-web-app/` | `hizla-web-app/` | Kurye ekranları web'den kaldırılır (D-08) |
| `hizla_mobile/` | `hizla-mobile-app/` | |
| `keys/public.pem` | `secrets/jwt-public.pem` (gitignore) | |
| `.env.test` | `.env.test.example` (izlenir), `.env.test` (izlenmez) | |
| `MONOREPO-ARCHITECTURE.md` (kök) | `docs/ARCHITECTURE.md` | Şablonun projeye uyarlanmış kopyası |
| `services/service-auth/ecosystem.config.js` | silinir | Şablon §22: servis başına manifest yok |

---

## 5. Veritabanı

### 5.1 Neden taşıma değil yeniden kurulum

- Bugünkü veri yalnızca seed ve geliştirme verisi (`05-seed-data.sql`). Üretimde kullanıcı yok.
- Kimlik tipi (UUID → BIGINT), kolon adları ve enum mekanizması aynı anda değişiyor; tablo tablo migration yazmak, yeni şemayı yazmaktan daha pahalı ve hataya açık.
- **Varsayım:** Bu karar, üretimde korunması gereken veri olmadığına dayanıyor. Varsa `D-05` kararı geri alınır ve tablo bazlı migration planı yazılır.

### 5.2 Dosya düzeni

```
db-schemas/
├── 00-enums-schema.sql          # enums şeması: tüm durum sözlükleri + rol/izin seed'i (ÜRETİLİR)
├── 01-identity-schema.sql       # global_code_seq, tenant, organization, user_account, user_device, user_consent
├── 02-reference-schema.sql      # city, district, zone (poligon), platform, vehicle_type
├── 03-courier-schema.sql
├── 04-merchant-schema.sql
├── 05-shift-schema.sql
├── 06-delivery-schema.sql
├── 07-finance-schema.sql
├── 08-integration-schema.sql
├── 09-support-audit-schema.sql
├── 10-seed-data.sql             # tek tenant + Hızla sistem organizasyonu + platform kayıtları
├── 11-performance.sql           # index'ler + courier_location_ping hypertable + retention
├── A00-bootstrap-database.sql   # hizla_svc rolü + CREATE DATABASE hizla (ICU tr-TR)
├── A97-demo-seed.sql            # İstanbul/Kadıköy demo: 2 bölge, 4 işletme, 25 kurye, 1 hafta slot
├── A98-superadmin-howto.sql
├── A99-grants.sql
└── migrations/
```

Konum verisi için PostGIS gerekmez: bölge poligonları `reference.zone.zone_polygon JSONB` (GeoJSON) olarak tutulur, nokta-poligon testi uygulamada yapılır; en yakın kurye araması Redis `GEOSEARCH` ile yapılır (§8). TimescaleDB, şablonun varsayılan imajında zaten var; konum pingleri için kullanılır.

### 5.3 Organizasyon modeli

| `organization_type` | Kim | Örnek |
|---|---|---|
| `platform` | Hızla'nın kendisi (sistem organizasyonu); operasyon ekibi ve kuryeler buna bağlı | Hızla Operasyon |
| `merchant` | Hizmet alan işletme; şubeler `merchant.merchant_branch` | Kadıköy Burger (3 şube) |
| `fleet` *(Faz 2+)* | Hızla altyapısını kullanan taşeron kurye firması (SaaS/hibrit model) | X Motokurye Ltd. |

Kuryenin kendi verisi (kazanç, slot) kullanıcıya göre süzülür: use-case'ler `caller.callerUserId` ile `courier_user_account_id` eşleşmesini guard olarak uygular. Kapsam kolonu kuryenin bağlı olduğu filo organizasyonudur (`platform` ya da ileride `fleet`).

### 5.4 Durum makineleri (domain'in kalbi)

**Teslimat (`enums.delivery_status`)**

```
created ─▶ searching ─▶ offered ─▶ assigned ─▶ at_pickup ─▶ picked_up ─▶ at_dropoff ─▶ delivered
   │           │  ▲         │          │           │             │              │
   │           │  └─timeout─┘          │           │             │              └─▶ failed_dropoff ─▶ returned
   └───────────┴───────────────────────┴───────────┴─▶ cancelled (cancel_reason + cancelled_by)
```

- `offered → searching`: teklif süresi doldu ya da kurye reddetti (ret nedeni zorunlu değil, ret sayısı **cezaya dönüşmez**; bkz. Rapor §8).
- `at_pickup` girişi `delivery_pickup_arrived_at` damgasını basar; işletmede bekleme süresi buradan hesaplanır ve kuryeye **bekleme ücreti** olarak yansır (finance `price_rule`).
- Geri alma geçişleri (ör. yanlışlıkla "teslim alındı") ileri matrise eklenmez; ayrı `revert-*` uçları ve ayrı izin (`delivery:revert`) kullanılır (şablon §8.5).

**Slot rezervasyonu (`enums.slot_booking_status`)**

```
booked ─▶ checked_in ─▶ completed
  │  ▲          └─▶ ended_early
  │  └── swap_accepted (takas ile devralındı)
  ├─▶ released        (bırakma penceresi içinde, cezasız)
  ├─▶ released_late   (pencere dışı; kural kuryeye ÖNCEDEN gösterilir)
  ├─▶ swap_offered ─▶ swap_accepted / booked (teklif geri çekildi)
  └─▶ no_show         (slot başladıktan 15 dk sonra check-in yok)
```

**Kurye (`enums.courier_status`)**: `applicant → in_review → approved → active ⇄ paused → suspended → offboarded`; çalışma anı durumu ayrı: `enums.courier_presence` = `offline | online_idle | on_delivery | on_break`.

### 5.5 Örnek tablo (şablon §4.3 kurallarıyla)

```sql
-- -----------------------------------------------------
-- Table: shift.slot
-- Purpose: Bir bölgede, belli bir zaman aralığında açılan kurye kapasitesi.
-- -----------------------------------------------------
CREATE TABLE shift.slot (
    slot_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    slot_code BIGINT UNIQUE NOT NULL DEFAULT nextval('global_code_seq'),
    slot_tenant_code BIGINT NOT NULL,
    slot_organization_id BIGINT NOT NULL,              -- filo (platform/fleet) — kapsam kolonu
    slot_zone_code BIGINT NOT NULL,                    -- reference.zone(zone_code)
    slot_starts_at TIMESTAMP WITH TIME ZONE NOT NULL,
    slot_ends_at TIMESTAMP WITH TIME ZONE NOT NULL,
    slot_capacity INT NOT NULL,                        -- hedef kurye sayısı
    slot_booked_count INT NOT NULL DEFAULT 0,          -- koşullu UPDATE ile artar (yarış güvenli)
    slot_guaranteed_hourly_amount DECIMAL(15,2),       -- saatlik asgari kazanç garantisi (varsa)
    slot_incentive_amount DECIMAL(15,2),               -- yoğun saat teşviki (varsa)
    slot_amount_currency VARCHAR(3) NOT NULL DEFAULT 'TRY',
    slot_release_deadline_minutes INT NOT NULL DEFAULT 120,   -- cezasız bırakma penceresi
    slot_status VARCHAR(50) NOT NULL DEFAULT 'draft',  -- enums.slot_status: draft|published|closed|cancelled
    slot_metadata JSONB DEFAULT '{}',
    slot_created_by BIGINT,
    slot_created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    slot_updated_by BIGINT,
    slot_updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_slot_time_range CHECK (slot_ends_at > slot_starts_at),
    CONSTRAINT chk_slot_capacity CHECK (slot_booked_count <= slot_capacity),
    CONSTRAINT fk_slot_tenant FOREIGN KEY (slot_tenant_code) REFERENCES identity.tenant(tenant_code),
    CONSTRAINT fk_slot_organization FOREIGN KEY (slot_organization_id) REFERENCES identity.organization(organization_id),
    CONSTRAINT fk_slot_zone FOREIGN KEY (slot_zone_code) REFERENCES reference.zone(zone_code),
    CONSTRAINT fk_slot_status FOREIGN KEY (slot_status) REFERENCES enums.slot_status(slot_status_value)
);
```

Slot rezervasyonunun yarış güvenliği, şablonun "durum kapısı WHERE'de" kuralıyla sağlanır:

```sql
UPDATE shift.slot
   SET slot_booked_count = slot_booked_count + 1, slot_updated_at = NOW()
 WHERE slot_code = $1 AND slot_status = 'published' AND slot_booked_count < slot_capacity
RETURNING slot_code;   -- 0 satır → SLOT_FULL (409)
```

### 5.6 Tablo listesi (alan sahipliğiyle)

| Şema | Tablo | Amaç |
|---|---|---|
| identity | `tenant`, `organization`, `user_account`, `user_device` (FCM token), `user_consent` (KVKK açık rıza sürümü + zaman) | kimlik ve kiracı |
| enums | `user_account_role`, `permission`, `role_permission`, `organization_type`, `courier_status`, `courier_presence`, `vehicle_type`, `document_type`, `document_status`, `application_status`, `slot_status`, `slot_booking_status`, `swap_offer_status`, `delivery_status`, `delivery_cancel_reason`, `delivery_issue_type`, `proof_type`, `platform_code`, `earning_line_type`, `payout_status`, `invoice_status`, `support_category`, `support_status` | sözlükler |
| reference | `city`, `district`, `zone`, `platform`, `vehicle_type_spec` | platform geneli referans |
| courier | `courier`, `courier_application`, `courier_document`, `courier_training`, `courier_vehicle`, `courier_status_event`, `courier_score` (haftalık şeffaf puan dökümü), `courier_location_ping` | kurye yaşam döngüsü |
| merchant | `merchant_profile`, `merchant_branch` (konum, bölge, ortalama hazırlık süresi, teslim alma talimatı), `merchant_platform_account` (YS/Getir/TY mağaza kimlikleri), `merchant_contract` (fiyat planı, SLA, vade) | işletme |
| shift | `slot_plan` (haftalık şablon), `slot`, `slot_booking`, `slot_swap_offer`, `slot_attendance` (check-in/out, konum), `courier_priority` (erken erişim katmanı ve gerekçesi) | slot/vardiya |
| delivery | `delivery`, `delivery_event` (her durum geçişi, kim, nerede), `delivery_offer` (kime, ne zaman, sonuç), `delivery_batch`, `delivery_proof`, `delivery_rating` (iki yönlü: işletme↔kurye), `delivery_issue`, `tracking_link` | teslimat |
| finance | `price_rule` (işletme fiyatı ve kurye ücreti ayrı kurallar), `courier_earning` + `courier_earning_line` (taban, mesafe, bekleme, teşvik, iptal telafisi, bahşiş), `incentive` + `incentive_progress`, `payout_batch`, `payout`, `merchant_invoice` + `merchant_invoice_line`, `ledger_entry` | para |
| integration | `platform_connection` (sır referansı; sırrın kendisi değil), `external_order`, `webhook_inbox` (idempotency anahtarı), `outbound_status_push` (outbox) | dış platformlar |
| support | `support_ticket`, `support_message` | destek |
| audit | `audit_log` | kim neyi ne zaman değiştirdi |

---

## 6. Roller ve izinler

### 6.1 Roller

| Rol | Organizasyon tipi | Kapsam |
|---|---|---|
| `superadmin` | platform | her şey |
| `platform_ops` | platform | dispatch, kurye ve slot yönetimi, istisnalar |
| `platform_zone_lead` | platform | `platform_ops` ile aynı, ama yalnızca atandığı bölgeler (`user_account_metadata.zones`) |
| `platform_support` | platform | destek talepleri, salt okunur teslimat |
| `platform_finance` | platform | fiyat kuralı, hakediş, fatura |
| `merchant_admin` | merchant | işletme ve tüm şubeler, fatura, kullanıcılar |
| `merchant_staff` | merchant | atandığı şubede teslimat isteği ve takip |
| `courier` | platform / fleet | kendi verisi |
| `fleet_admin` *(Faz 2+)* | fleet | kendi filosu |
| `anonymous` | — | public uçlar (takip sayfası, ping, giriş) |

### 6.2 İzin kataloğu (taslak, `packages/modules/shared/permissions.js`)

```
identity:user:read · identity:user:manage · identity:org:manage
reference:zone:manage
courier:self · courier:read · courier:application:review · courier:manage
merchant:self · merchant:branch:manage · merchant:read · merchant:manage
shift:self (slot al/bırak/takas) · shift:read · shift:plan:manage
delivery:create · delivery:read · delivery:courier-flow · delivery:dispatch · delivery:cancel · delivery:revert
finance:self · finance:read · finance:price:manage · finance:payout:manage · finance:invoice:manage
integration:connection:manage · support:self · support:manage · audit:read
```

Ekleme sırası şablon §8.13'tür; `npm run validate-auth-config` her PR'da CI'da koşar.

---

## 7. Önemli akışlar (servisler arası)

### 7.1 Platform siparişinden teslimata

1. Yemeksepeti/Getir/Trendyol webhook'u (ya da işletme panelinden elle istek) → `integration` `webhook_inbox`'a idempotent yazar, `external_order` eşler.
2. `integration` → `delivery` internal `POST /v1/internal/deliveries` (`fetchInternal`, `gate` zaman aşımı). Teslimat `created`.
3. İşletme "hazırlanıyor" bilgisini ya da tahmini hazır olma zamanını verir (platformdan geliyorsa otomatik). Dispatch, kuryenin **hazır olma anına göre** varacağı şekilde zamanlanır; erken gönderip restoranda bekletmek yerine.
4. Dispatch motoru (delivery): aday kuryeler = aktif slotta + `online_idle` + bölgede (Redis `GEOSEARCH`). Skor = varış süresi + adalet bileşeni (bugünkü kazancı bölge ortalamasının altında olana küçük öncelik) + batch uygunluğu. **Kabul oranı skora girmez.**
5. Teklif → kurye 45 sn içinde görür: işletme, mesafe, **tahmini kazanç (TL)**, tahmini süre. Kabul/ret.
6. `at_pickup` → `picked_up` (QR ya da 4 haneli PIN) → `at_dropoff` → `delivered` (PIN ya da foto).
7. Commit sonrası: `finance` internal ucu kazanç satırlarını yazar; `integration` outbox'ı platforma durumu iter; `realtime` üç tarafa olay yayar.

### 7.2 Slot döngüsü (kurye adaleti)

- Slotlar her hafta **sabit, duyurulmuş bir takvimde** açılır (ör. Perşembe 12:00, gelecek hafta için).
- Erken erişim katmanları açık kurallarla belirlenir (ör. son 4 haftada no-show yok + slot tamamlama oranı) ve kurye kendi katmanını ve gerekçesini görür (`courier_priority`).
- Bırakma: `slot_release_deadline_minutes` öncesine kadar cezasız. Sonrasında `released_late`; yaptırım yalnızca bir sonraki haftanın erken erişimini etkiler, para cezası yok.
- **Takas pazarı:** kurye slotunu `swap_offer`'a koyar; aynı bölgede uygun kurye devralırsa sorumluluk devredilir. Kimse almazsa bırakma kuralı işler.
- Operasyon, talep tahminine göre `slot_plan`'dan kapasite üretir; yoğun saat slotlarına teşvik bağlar.

### 7.3 Para

- **Bakiye tutulmaz, türetilir.** `ledger_entry` çift taraflı defterdir; kuryenin "cüzdan bakiyesi" ve işletmenin "borcu" defterden hesaplanır. Bugünkü `courier.wallet.balance` kolonu bu yüzden kaldırılır (çift kayıt tutarsızlığı riski).
- Kurye kazancı satır satır görünür: taban + mesafe + bekleme + teşvik + bahşiş − (varsa) kesinti. Kurye her teslimatın dökümünü uygulamada görür.
- İşletme fiyatı ile kurye ücreti **ayrı kurallardır**; aradaki marj finance raporunda görünür, kuryeye gösterilmez.

### 7.4 Yan etkiler

Şablon §10.3: bildirim, platforma durum itme ve kazanç satırı yazımı commit'ten **sonra** çalışır. Kaybolmaması gerekenler (kazanç, platform durumu) **outbox** ile: transaction içinde `delivery.delivery_event`'e `needs_finance=true` damgası, cron (`withCronLock`) bunları işler ve idempotency anahtarıyla finance'e iletir.

---

## 8. Gerçek zamanlı katman ve konum (proje eki)

Şablonda yok; bugünkü çalışan çözüm korunup genelleştiriliyor.

| Konu | Karar |
|---|---|
| Kurye → sunucu konum | REST `POST /api/hizla-service-courier/v1/me/location`, hareket hâlinde 5 sn, beklerken 30 sn (bugünkü 5 sn throttle korunur) |
| Son konum | Redis `GEOADD courier:geo:<zone>` + `HSET courier:presence:<id>`; dispatch buradan okur |
| Konum geçmişi | `courier.courier_location_ping` (Timescale hypertable, 30 gün retention, sıkıştırma 7 gün) |
| Sunucu → istemci | WS `/ws` (gateway `ws-proxy.js` imzalı çerez doğrulamasıyla, bugünkü gibi). Faz 1'de delivery servisinde; Faz 2'de `hizla-service-realtime`'a taşınır |
| Kanallar | `courier:<id>` (teklifler), `merchant:<orgId>` (teslimat durumları), `ops:zone:<code>` (canlı harita), `tracking:<token>` (son müşteri) |
| Ölçek | Servisler commit sonrası Redis `PUBLISH`; realtime servisi abonedir. Birden fazla instance'ta tek doğru kaynak Redis olur |
| Push | Uygulama arka plandayken teklif FCM yüksek öncelikli bildirimle gider (`ports/push.js`, tetikleyici `FCM_SERVICE_ACCOUNT_JSON_PATH`) |

KVKK: konum yalnızca kurye **çevrimiçi** iken toplanır; çevrimdışında uygulama göndermez, sunucu kabul etmez. Saklama süresi `user_consent` metninde yazar.

---

## 9. Dış entegrasyonlar (port/adaptör)

| Port | Tetikleyici env | İlk adaptör | Not |
|---|---|---|---|
| `ports/platform-orders.js` | `YEMEKSEPETI_CLIENT_ID`, `GETIR_API_KEY`, `TRENDYOL_SUPPLIER_ID` (her biri ayrı) | integration servisindeki adaptörler | Erişim koşulları Rapor §6.4'te; onay gerektirenler `BEKLİYOR` |
| `ports/push.js` | `FCM_SERVICE_ACCOUNT_JSON_PATH` | FCM | JSON repo dışında |
| `ports/sms.js` | `SMS_PROVIDER` + parola | Netgsm / İleti Merkezi (karar BEKLİYOR) | test/E2E'de `SMS_DISABLED=true` zorunlu |
| `ports/routing.js` | `ROUTING_PROVIDER` | Faz 1: kuş uçuşu × 1,35 katsayı; Faz 2: OSRM (kendi sunucumuz) | ETA ve mesafe ücreti |
| `ports/payout.js` | `PAYOUT_PROVIDER` | Faz 1: banka EFT dosyası dışa aktarımı; `fake` yalnızca test | |
| `ports/e-invoice.js` | `EINVOICE_PROVIDER` | entegratör (karar BEKLİYOR) | işletme faturası |
| `ports/storage.js` | `STORAGE_PROVIDER` | Postgres `storage.blob` (şablon §11.3); sonra S3 uyumlu | kurye belgeleri, teslim fotoğrafı |

Kural: sahte adaptör `NODE_ENV=production`'da kurulmayı reddeder; gerçek dış etkisi olan kanallar (SMS, push, ödeme, platforma durum itme) E2E'de bayrakla kapatılır.

---

## 10. Mobil uygulama (proje eki)

- Klasör `hizla-mobile-app/`, Flutter paket adı `hizla_mobile` (import'lar değişmez). Kök `package.json`'daki `start:mobile`, `test:mobile`, `analyze:mobile` script'leri yeni yola güncellenir.
- Mimari aynı kalır: MVVM + Riverpod, `lib/core/` (tema, ağ, harita), `lib/features/<alan>/`. Yeni özellik klasörleri: `shift/` (slot takvimi, takas pazarı), `earnings/` (teslimat bazlı döküm), `delivery/` (aktif iş akışı), `score/` (şeffaf puan).
- Kimlik: gateway çerez oturumu + çerez kavanozu (`dio_cookie_manager` ya da eşdeğeri) + `X-XSRF-TOKEN` başlığı. Web ile aynı oturum modeli; ayrı bir token akışı kurulmaz.
- Tasarım token'ları [Tasarım Sistemi §10](design/HIZLA-TASARIM-SISTEMI.md)'deki `HizlaTokens` ThemeExtension'ına geçer; bugünkü `AppColorScheme` bu yapıya evrilir.
- CI: `flutter analyze` + `flutter test` ayrı job.

---

## 11. Frontend (`hizla-web-app`)

Şablon §16 olduğu gibi uygulanır; projeye özel kararlar:

- **Tek SPA, iki rol alanı:** `/isletme/*` (merchant_admin, merchant_staff) ve `/operasyon/*` (platform_*). `RoleHomeRedirect` giriş sonrası doğru alana yönlendirir. Public `/t/:token` takip sayfası ayrı, hafif bir layout kullanır.
- Kurye ekranları (`pages/{dashboard,earnings,wallet,quests,order-verify,order-rate,support}`) Flutter uygulamasında eşdeğerleri tamamlandıktan sonra web'den kaldırılır (D-08).
- `features/`: `auth`, `merchant-deliveries`, `merchant-branches`, `merchant-billing`, `ops-live`, `ops-dispatch`, `ops-couriers`, `ops-shifts`, `ops-finance`, `ops-merchants`, `support`, `tracking`.
- Stil: bugünkü inline `style={{}}` + `index.css` CSS değişkenleri, şablonun SCSS modülü + `src/styles/` token düzenine taşınır. Token isimleri tasarım sistemindeki adlarla **birebir** aynıdır (`--hz-*`).
- i18n: `tr` (varsayılan), `en`. Bugün hiç yok; tüm metinler `t()`'ye taşınır.
- Grid: işletme ve operasyon tablolarında AG Grid Community (lisans gerekmez); Enterprise yalnızca ihtiyaç kanıtlanırsa.
- Harita: MVP'de bugünkü Leaflet + CARTO raster korunur ama **API anahtarıyla** (CARTO artık anahtarsız isteğe filigran basıyor; ticari kullanımda ayda 1 M karo ücretsiz). V1'de web ve mobil birlikte **MapLibre + Hızla'ya özel vektör stile** geçer (stok stillerin etiket kontrastı kurye için yetersiz; Tasarım §9). Şablonun OpenLayers önerisi İSTEĞE BAĞLI olduğu için uygulanmaz (D-09).
- Tasarım token'ları `packages/design-tokens/tokens.json`'dan üretilir (`npm run build:tokens` → `src/styles/_tokens.scss` + mobil `hz_tokens.g.dart`); CI üretilen dosyaların güncel olduğunu `git diff --exit-code` ile doğrular (Tasarım §10).

---

## 12. Geçiş fazları

Fazlar şablon §19 ile hizalıdır. Her faz ayrı bir dal ve PR'dır; "Bitti sayılır" yeşil olmadan sonraki faza geçilmez.

| Faz | İş | Efor | Bitti sayılır |
|---|---|---|---|
| **F−1** Acil düzeltmeler (bugünkü kodda) | K1: admin uçlarına rol kontrolü (`x-user-role === 'admin'`) + gateway'de `/api/admin/*` için rol kapısı; K2: sorgu değerleri + onay akışını tek transaction'a al; K4: sipariş uçlarına `courier_id` eşleşme koşulu; K7: önceden doldurulmuş kimlik bilgilerini kaldır; K9: `.env.example` portu | 1 gün | Kurye çereziyle `/api/admin/dashboard` → 403 · onay sonrası `courier.couriers` satırı var · başka kuryenin siparişine `accept` → 404/409 |
| **F0** Hazırlık | `docs/DECISIONS.md` (taslağı bu PR'da), şablonu `docs/ARCHITECTURE.md` olarak uyarla; Node 24, Docker, `pg_dump` 18, `pm2` | 0,5 gün | `node -v` → v24 · `docker info` · `pg_dump --version` ≥ 18 |
| **F2** packages | Referans paketleri kopyala; `@hizla/*` → `app-*`; `permissions.js` kataloğu (§6); `SCHEMA_DEFAULT_PERMISSIONS` (identity, enums, reference, courier, merchant, shift, delivery, finance, integration, support, audit); `grep -rniE tropiq packages` boş | 3 gün | `npm run test:packages` yeşil |
| **F3** Veritabanı | §5 dosyaları; `scripts/*`; `npm run build-role-permission-seed && npm run build-schema && npm run db:up && node scripts/apply-migrations.mjs --baseline --yes` | 5 gün | `\dn` 11 şemayı listeler · `npm run migrate:status` · `npm run validate-auth-config` 0 |
| **F4** Test altyapısı | `jest.config.js`, `test/config/`, drift testi; eski `node:test` testleri `test:legacy` altında geçici | 2 gün | `npm run test:backend` yeşil; ikinci koşu `test:fast` saniyeler |
| **F5** identity | `service-auth` iş mantığını `hizla-service-identity`'ye taşı; giriş: telefon + şifre (OTP, SMS sözleşmesine kadar BEKLİYOR); `GET /v1/public/ping`; kayıt: kurye başvurusu + işletme başvurusu | 3 gün | `/api/online` true · Redis'te `service:*` kayıtları · identity testleri yeşil |
| **F6** Gateway | Referans gateway + bugünkü `ws-proxy.js`; `public-paths.js` (giriş, ping, takip, referans GET'ler); `SESSION_REFRESH_PATHS`; kendi `packages/` kopyasını sil | 3 gün | `/health` ok · ping `success:true` · login yanıtında `hizla_xsrf` · çerezsiz korumalı uç 401 · `wss://.../ws` imzalı çerezle bağlanır |
| **F7a** app | enums/reference GET'leri (public), bölge yönetimi, destek, audit | 2 gün | çerezli auto-CRUD GET 200 |
| **F7b** courier | profil, başvuru + belge + eğitim (onboarding'den), presence, konum, skor | 4 gün | başvuru → onay akışı integration testi |
| **F7c** merchant | işletme kaydı, şube, platform hesabı, sözleşme | 3 gün | işletme admin'i yalnızca kendi şubelerini görür (kapsam testi) |
| **F7d** shift | slot planı, yayın, rezervasyon (yarış testi), bırakma, takas, no-show cron'u | 5 gün | 50 eşzamanlı rezervasyonda `booked_count ≤ capacity` |
| **F7e** delivery | teslimat yaşam döngüsü, dispatch motoru, teklif zaman aşımı cron'u, kanıt, takip linki, WS | 7 gün | durum matrisi parite testi · teklif zaman aşımı testi (`nowFn`) |
| **F7f** finance | fiyat kuralları, kazanç satırları, defter, hakediş dönemi, fatura | 5 gün | defter toplamı = 0 değişmezi · kazanç dökümü = teslimat toplamı |
| **F7g** integration | webhook inbox + idempotency, ilk platform adaptörü (erişim açılan ilk platform), outbox | 4 gün | aynı webhook iki kez → tek teslimat |
| **F8** Web | Şablon dizin yapısı, provider ağacı, i18n, MUI wrapper'ları, tasarım token'ları, `/isletme` + `/operasyon` ekranları (Tasarım §11–12) | 8 gün | `npm run test:web` · `npm run build` · `npm run lint` |
| **F8m** Mobil | API sabitleri, çerez + XSRF, tasarım token'ları, slot/takas, kazanç dökümü | 6 gün | `flutter analyze` 0 · `flutter test` yeşil |
| **F9** E2E | Akış: işletme istek açar → operasyon panoda görür → kurye (API ile) kabul eder → işletme "yolda" görür → takip sayfası ETA gösterir | 3 gün | `npm run test:e2e:full` → 0 failed |
| **F10** Dağıtım + CI | `ecosystem.config.cjs`, `scripts/update.sh`, `.github/workflows/ci.yml` (lint, auth-config, test-web, test-backend, build, flutter) | 2 gün | `node -e "require('./ecosystem.config.cjs')"` ENV_FILE yokken 1 · CI yeşil |

Sıralama notu: F7 alt fazları, ürün için en riskli varsayımı en erken doğrulayacak sırayla dizildi: önce kurye ve işletme verisi, sonra slot (kurye tarafındaki ana farkımız), sonra teslimat ve para. Platform entegrasyonu en sona kondu, çünkü erişim onayı dış bir bağımlılık; o gelene kadar işletme paneli elle istekle çalışır.

---

## 13. Riskler

| Risk | Olasılık | Etki | Önlem |
|---|---|---|---|
| Referans repo (`tropiq-mono-repo`) bu makinede erişilemez | Orta | Yüksek: F2/F6 kopyalama yerine sıfırdan yazım | Şablon her dosyanın sözleşmesini veriyor; sıfırdan yazım +5–8 gün |
| Platform API erişimi gecikir ya da verilmez | Yüksek | Orta | Elle istek + tablet ekranı ile çalış; adaptörler port arkasında |
| Mikroservis sayısı (9) tek geliştirici için ağır | Orta | Orta | Şablon §20: servis başına kabuk ucuz; gerekirse shift+courier birleştirilir (D-10'u geri al) |
| Eski `node:test` testleri Jest'e taşınırken kapsam düşer | Orta | Düşük | Geçişte iki koşucu birlikte; taşınan her dosya silinmeden önce Jest'te yeşil |
| Mobil ve web aynı anda API değişikliğine uğrar | Yüksek | Orta | Gateway'de geçici yol eşlemesi (`/api/auth/*` → yeni yol) F8/F8m bitene kadar |

---

## 14. Bu planı güncel tutma

