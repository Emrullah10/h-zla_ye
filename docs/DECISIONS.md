# Karar Kaydı — Hızla

> Şablon §0.5 gereği. Biçim: `[YYYY-MM-DD] Karar — gerekçe — nasıl geri alınır`. `BEKLİYOR` = dış bağımlılık ya da kullanıcı onayı bekleyen adım.
> Bu dosya [Mimari Geçiş Planı](ARCHITECTURE-PLAN.md) ile birlikte açıldı; plan uygulandıkça güncellenir.

## 1. Yer tutucu değerleri

| Yer tutucu | Değer | Not |
|---|---|---|
| `<proje>` | `hizla` | ASCII; görünen ad "Hızla" |
| `<Proje>` | `Hızla` | |
| `<PROJE>` | `HIZLA` | env öneki |
| `<proje_db>` | `hizla` | bugün `hizla_dev`; yeniden kurulumla `hizla` |
| `<PORT_BASE>` | `4000` | şablon varsayılanı 1000; gateway portu korunsun diye 4000 (D-03) |
| `<TZ>` | `Europe/Istanbul` | |
| `<diller>` | `tr,en` | varsayılan `tr` |
| `<icu>` | `tr-TR` | |
| `<app-host>` / `<landing-host>` | `app.hizla.com.tr` / `hizla.com.tr` | **BEKLİYOR**: alan adı alınmadı |
| `<staging-app-host>` | `http://127.0.0.1:4000` | **BEKLİYOR**: staging sunucusu yok |

## 2. Servis tablosu

| Domain | Servis | Şema(lar) | Port | Sahip olduğu tablolar |
|---|---|---|---|---|
| — | `hizla-web-gateway` | — | 4000 | — |
| identity | `hizla-service-identity` | `identity` | 4001 | tenant, organization, user_account, user_device, user_consent |
| app | `hizla-service-app` | `enums`, `reference`, `support`, `audit` | 4002 | sözlükler, city, district, zone, platform, vehicle_type_spec, support_ticket, support_message, audit_log |
| courier | `hizla-service-courier` | `courier` | 4003 | courier, courier_application, courier_document, courier_training, courier_vehicle, courier_status_event, courier_score, courier_location_ping |
| merchant | `hizla-service-merchant` | `merchant` | 4004 | merchant_profile, merchant_branch, merchant_platform_account, merchant_contract |
| shift | `hizla-service-shift` | `shift` | 4005 | slot_plan, slot, slot_booking, slot_swap_offer, slot_attendance, courier_priority |
| delivery | `hizla-service-delivery` | `delivery` | 4006 | delivery, delivery_event, delivery_offer, delivery_batch, delivery_proof, delivery_rating, delivery_issue, tracking_link |
| finance | `hizla-service-finance` | `finance` | 4007 | price_rule, courier_earning, courier_earning_line, incentive, incentive_progress, payout_batch, payout, merchant_invoice, merchant_invoice_line, ledger_entry |
| integration | `hizla-service-integration` | `integration` | 4008 | platform_connection, external_order, webhook_inbox, outbound_status_push |
| realtime (Faz 2) | `hizla-service-realtime` | — | 4009 | — |

## 3. İSTEĞE BAĞLI bileşenler

| Bileşen | Durum | Not |
|---|---|---|
| Landing (Astro) | kurulmadı | pilot sonrası |
| `legal-content` paketi | kurulmadı | landing ile birlikte |
| Push (FCM) | **kurulacak** (F7e) | kurye teklifleri için şart; **BEKLİYOR**: Firebase projesi |
| SMS | kurulmadı | OTP girişi ve takip linki için; **BEKLİYOR**: sağlayıcı sözleşmesi (Netgsm / İleti Merkezi) |
| E-posta (SMTP) | kurulmadı | işletme faturası bildirimi için V1'de |
| Ödeme (kart tahsilatı) | kurulmadı | işletme havale/EFT ile öder; kurye ödemesi EFT dosyası |
| E-fatura entegratörü | kurulmadı | **BEKLİYOR**: entegratör seçimi |
| Depolama | Postgres `storage.blob` | kurye belgeleri ve teslim fotoğrafı; ölçekte S3 uyumlu |
| AG Grid | Community | Enterprise lisansı yok |
| ECharts | kurulacak | operasyon ve işletme raporları |
| Harita | MVP: Leaflet + CARTO (anahtarlı); V1: MapLibre | D-09 |
| Kafka | kurulmadı | Redis pub/sub yeterli |

## 4. Kararlar

- [2026-10-06] **D-01** Şablon v2.0 hedef alındı; `core/` = üretilen auto-CRUD, iş mantığı `services/`'te — şablonun 2.0 sürümü 1.0'daki anlatımı düzeltti, mevcut kod 1.0'a göre kuruldu — geri alma: yok (şablonun temel kararı).
- [2026-10-06] **D-02** 8 domain servisi + gateway, Faz 2'de realtime (§2) — işletme, slot, teslimat, finans ve entegrasyonun ayrı yaşam döngüleri var; `courier` servisi bugün beş alanı birden taşıyor — geri alma: shift + courier ya da delivery + finance birleştirilebilir (şablon §20).
- [2026-10-06] **D-03** `PORT_BASE=4000` — web ve mobil istemciler gateway'i 4000'de arıyor; servisler 4001'den başlar — geri alma: `.env` URL'lerini değiştir.
- [2026-10-06] **D-04** Paket adları `@hizla/*` yerine şablon adları (`app-config`, `app-shared`...) — referans repodan kopyalanan dosyalar değiştirilmeden çalışsın — geri alma: workspace adlarını yeniden kapsamla.
- [2026-10-06] **D-05** Veritabanı taşınmayacak, yeniden kurulacak — üretimde korunacak veri yok; kimlik tipi, kolon adları ve enum mekanizması aynı anda değişiyor — geri alma: üretim verisi varsa tablo bazlı migration planı yaz. **Varsayım kullanıcı tarafından doğrulanmalı.**
- [2026-10-06] **D-06** Giriş: telefon + şifre (bcrypt) — SMS sözleşmesi yok; OTP **BEKLİYOR** — geri alma: OTP portu kurulunca giriş yöntemi değişir.
- [2026-10-06] **D-07** `service-admin` dağıtılır, "admin" bir rol ailesi olur (`platform_ops`, `platform_zone_lead`, `platform_support`, `platform_finance`, `superadmin`) — yönetim işlemleri sahibi oldukları domainde yaşamalı — geri alma: yok.
- [2026-10-06] **D-08** Kurye ekranları web'den kaldırılır, kurye deneyimi yalnızca Flutter'da — iki istemcinin bakımı ve tasarım tutarsızlığı; web işletme + operasyon odaklı — geri alma: kurye route'larını geri ekle.
- [2026-10-06] **D-09** Harita: MVP'de Leaflet/flutter_map + CARTO raster (API anahtarıyla), V1'de MapLibre + Hızla'ya özel vektör stil; OpenLayers kurulmaz — stok CARTO stillerinin etiket kontrastı kurye için yetersiz (Dark Matter yol etiketi 1,65:1) ve CARTO ticari kullanımda anahtar/kota istiyor — geri alma: MVP raster kurulumunda kal.
- [2026-10-06] **D-10** Slot sistemi ayrı servis (`hizla-service-shift`) — Hızla'nın kurye tarafındaki ana farkı; kendi cron'ları (dağıtım, no-show, takas süresi) ve adalet metrikleri var — geri alma: courier servisine katla.
- [2026-10-06] **D-11** Kurye ve işletme bakiyesi tutulmaz, `finance.ledger_entry` defterinden türetilir — bugünkü `wallet.balance` kolonu yazılmıyor ve çift kayıt tutarsızlığına açık — geri alma: önbellek tablosu eklenebilir, kaynak defter kalır.
- [2026-10-06] **D-12** Gerçek zamanlı: Faz 1'de WS delivery servisinde, Faz 2'de `hizla-service-realtime` + Redis pub/sub — tek instance için yeterli; ölçekte ayrılır — geri alma: yok.
- [2026-10-06] **D-13** Test koşucusu Jest 29 (backend + web) — şablonun üretilen testleri Jest; mevcut `node:test` ve Vitest testleri geçişte `test:legacy` altında — geri alma: yok.
- [2026-10-06] **D-14** `hızla-web-app/` → `hizla-web-app/`, `hizla_mobile/` → `hizla-mobile-app/` (Flutter paket adı `hizla_mobile` kalır) — ASCII klasör adları Docker, PM2, CI ve URL'lerde kaçış sorununu bitirir — geri alma: `git mv`.
- [2026-10-06] **D-15** `docs/` git'te izlenir; yalnızca eski beş yerel doküman ignore'da — şablon §22 — geri alma: `.gitignore`.
- [2026-10-06] **D-16** Tasarım sistemi: Turkuaz ana renk, Asfalt nötrler, Archivo + Atkinson Hyperlegible Next + Atkinson Hyperlegible Mono, Phosphor ikonları, token'lar `packages/design-tokens/tokens.json`'dan üretilir — [Tasarım Sistemi](design/HIZLA-TASARIM-SISTEMI.md) §0–§1 — geri alma: token dosyasındaki değerleri değiştir.
- [2026-10-06] **D-17** Ticari model: hibrit (önce kendi kurye operasyonu, sonra filo işletmecilerine yazılım) ve çok kiracılı veri modeli baştan (`organization_type`: platform, merchant, fleet) — [Fizibilite Raporu](reports/HIZLA-FIZIBILITE-VE-RAKIP-RAPORU.md) §6 — geri alma: `fleet` tipi kullanılmaz.

## 5. BEKLİYOR (dış bağımlılıklar)

| Konu | Neden bekliyor | Etkilediği faz |
|---|---|---|
| Referans repo (`tropiq-mono-repo`) erişimi | Bu makinede yoksa F2 ve F6'da dosyalar sözleşmeden sıfırdan yazılır (+5–8 gün) | F2, F6 |
| Alan adı ve staging sunucusu | satın alma / kurulum | F10 |
| Firebase projesi (FCM) | hesap | F7e, F8m |
| SMS sağlayıcısı | sözleşme | OTP, takip linki |
| E-fatura entegratörü | sözleşme | F7f |
| Yemeksepeti entegrasyon kimlik bilgileri | entegrasyon ekibi onayı | F7g |
| Getir, Trendyol Go, Migros Yemek API erişimi | koşullar doğrulanmadı | F7g |
| BTK ve iş hukuku yazılı görüşü | hukuk bürosu | pilot öncesi |
| CARTO API anahtarı | hesap (ticari kullanımda 1 M karo/ay ücretsiz) | MVP harita |
| Üretimde korunacak veri var mı (D-05) | kullanıcı teyidi | F3 |

## 6. Araç sürümleri (tüm makinelerde aynı)

| Araç | Sürüm |
|---|---|
| Node | 24 (bugün `Dockerfile.e2e` node:24-slim) |
| PostgreSQL | 18 (TimescaleDB imajı) — bugün yerelde DBngin, e2e'de 16 |
| codegraph | **BEKLİYOR** |
| Flutter | **BEKLİYOR**: `flutter --version` ile yazılacak |
