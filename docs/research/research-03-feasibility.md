# Hızla — Kurye Operasyon Sistemi: İş Geliştirme ve Fizibilite Araştırması

Tarih: 2026-10-06 · Hazırlayan: iş geliştirme / fizibilite analisti · Dil: Türkçe

---

## 0. Yöntem, güven düzeyi ve sınırlamalar (önce bunu okuyun)

- **WebFetch bu ortamda çalışmadı.** github.com hariç denediğim tüm alan adları (ntv.com.tr, onfleet.com, shipday.com, developers.trendyol.com, integration.yemeksepeti.com, developers.deliveryhero.com, adisyo.com, kolayrestoran.com, sec.gov, resmigazete.gov.tr, wikipedia vb.) `EGRESS_BLOCKED` döndürdü. Bu nedenle hiçbir kaynak sayfasını birebir açıp okuyamadım. Veriler **WebSearch sonuç özetlerinden** alındı. Bu özetler arama aracının derlemesidir, birebir alıntı değildir. Rakamlar özetle kaynak URL eşleşmesi üzerinden verilmiştir.
- **Arama kotası tükendi.** Yaklaşık 50 başarılı aramadan sonra araç "tur başına 200 arama (paylaşımlı) doldu" yanıtı verdi ve ben de kota aşımına yönelik başka yol denemedim. Sonuç: Bölüm 7 (yasal), 8 (finansman), 9 (başarısız örnekler) ve Bringg/Locus/Stuart/Orkestro/Deliverect/Otter/UrbanPiper fiyatları ile Getir/Trendyol/Migros API erişim koşulları **bu oturumda kaynakla doğrulanamadı**. Bu bölümlerdeki bilgi ya "genel bilgi" olarak açıkça etiketlendi ya da `[DOĞRULANMADI]` olarak işaretlendi. Takip araştırma listesi Bölüm 13'tedir.
- **Etiketler:** `[DOĞRULANMADI]` = bu oturumda kaynakla teyit edilemedi. `[TAHMİN]` = analist varsayımı, gerekçesi yanında. `[ÇELİŞKİ]` = kaynaklar birbirini tutmuyor.
- **Kaynak güvenilirliği:** Haber siteleri (NTV, Evrensel, TechCrunch, SEC, Concurrences vb.) ve resmî/kurumsal sayfalar "Yüksek–Orta" kabul edildi. Maaş/ücret rehberi blogları (meslekmaas, malipilot, heryerofis, eleman.net), SaaS fiyat toplayıcıları (upperinc, costbench, fareye) ve restoran yazılımı bloglarının (siparisustasi, varisdijital, qrmenum) çoğu satıcı/SEO içeriğidir; **"Düşük–Orta"** kabul edildi. Kaynak numaraları `[S#]` biçiminde olup tam URL'ler Bölüm 14'tedir.
- **Resmî rakamlar:** 2026 asgari ücret rakamlarını Resmî Gazete/Çalışma Bakanlığı sayfasından değil, birden çok ikincil kaynaktan aldım; birbiriyle tutarlıdır ve aritmetiği ben yeniden hesapladım (Bölüm 3).

---

## 1. Özet (yönetici özeti)

1. **Pazar iki oyunculu bir yapıya doğru hızla konsolide oluyor.** Uber, Trendyol Go'nun %85'ini aldı (2025 Haziran, ~700 mn $; kuruluş değeri 824 mn $), Getir'in yemek işini 335 mn $ peşin + gıda/market kolunda %15 için 100 mn $ ile aldı (Rekabet Kurulu 19 Haziran 2026'da koşullu onay verdi, 500 mn $ yatırım taahhüdü). Delivery Hero'ya 14,8 milyar $ değerleme ile nakit teklif geldi (16 Temmuz 2026); Yemeksepeti'nin ~1,6 mlr $'a SSW Partners'a devri planlanıyor, kapanış 2027 ikinci yarı bekleniyor [S32–S45].
2. **Restoran açısından teslimat maliyeti büyük bir kalem.** Yemeksepeti 2026'da kendi kuryesiyle teslim eden restorandan ~%12 (KDV hariç), kendi vale kuryesiyle teslimatta ~%32 (12 iletim + 20 dağıtım) alıyor; yani **teslimat bileşeni ~20 puan** [S19, S20]. Bir 3. taraf kurye operasyonunun satış argümanı bu farktan doğuyor; ancak basit hesapta fiyat tavanı dar (Bölüm 3).
3. **3PL (paket servis) modelinde marj ince ve emek riski yüksek.** Esnaf kurye ile çalışırsak (paket başı fiyat 95 TL, kurye ödemesi 70 TL, değişken 4 TL varsayımıyla) katkı ~21 TL/paket (%22) çıkıyor; **bordrolu** kurye ile aynı fiyatta ve 2,5 paket/saat verimde katkı **negatif** (Bölüm 3). Bu rakamlar `[TAHMİN]` girdilere dayanıyor.
4. **2026 maliyet şoku:** Asgari ücret %27 arttı (brüt 33.030 TL; asgari ücretlinin işveren maliyeti ~40.214–40.875 TL) [S1–S4]. Esnaf kurye tarifeleri %27–47 arttı ama Ocak 2026'da 3 günlük kontak kapatma eylemi yaşandı [S7–S12].
5. **SaaS ARPU çıpaları düşük:** Adisyo POS Lite 1.040 TL/ay, Pro 2.150 TL/ay (restoran başı) [S64]; Kolay Restoran 540 TL/ay [S66, tarih doğrulanmadı]; global dispatch SaaS'lar sürücü/görev başı $29–99 veya $39–3.099/ay [S52–S63]. Türkiye'de "kurye başı abonelik" için doğrulanmış bir fiyat çıpası **bulunamadı**.
6. **Yerel muadiller var ve niş dolu:** Hemen Yolda (kurye takip, Sodexo'dan 550 bin $), Loji Team (1.000+ kurye iddiası), SepetTakip, RestoKurye, RestoWay; POS tarafında Adisyo, Simpra, YemekPOS, Kolay Restoran; panel birleştirme tarafında Sipariş Ustası [S64–S76].
7. **Entegrasyon:** Yemeksepeti/Delivery Hero belgeleri herkese açık (integration.yemeksepeti.com, developer.yemeksepeti.com) ama kimlik bilgileri entegrasyon ekibi/hesap yöneticisi üzerinden veriliyor; "sipariş gönderimi (webhook)", "sipariş durumu güncelleme (kabul/ret/restoran kuryesi aldı)" mevcut [S78–S81]. Getir ve Trendyol Yemek için resmî API şartları **doğrulanamadı**; üçüncü taraf entegratörlerin (SambaPOS, iletmen, Odoo modülü) varlığı bir API'nin mevcut olduğuna işaret ediyor [S76, S77, S86].
8. **Regülasyon platform tarafını sıkılaştırıyor:** Ticaret Bakanlığı şeffaflık düzenlemesi 1 Nisan 2026'dan itibaren komisyon/hizmet bedellerinin kalem kalem gösterilmesini, restoranların kampanyaya zorlanmamasını şart koşuyor; Rekabet Kurulu Yemeksepeti'nin taahhütlerini kabul etti (zorunlu min. sepet, zorunlu joker, en çok kayrılan müşteri şartı sona erecek) [S25–S31]. Bu, "restoranın kendi/3. taraf kuryesi" modeli için olumlu bir ortam.
9. **En büyük yapısal risk:** Platformların kendi filosu (vale) ve konsolidasyon sonrası pazarlık gücü; API erişiminin değişmesi (Trendyol Go + Getir Uber Eats çatısına taşınacak) [S38, S39].
10. **Öneri (analist görüşü, `[TAHMİN]`):** Önce dar bölgede (1–2 yoğun ilçe), zincir/çoklu şube restoranlarla **hibrit** pilot: kendi operasyonuyla kanıtla (verimlilik, paket/saat, katkı marjı), SaaS'ı aynı yığın üzerinde ürünleştir. Saf SaaS'ın doğrulanmış fiyat çıpası zayıf; saf 3PL'in marjı ince. Karar kapıları Bölüm 12'de.

---

## 2. Konumlandırma seçenekleri

| | (a) 3PL kurye operasyon firması | (b) Kurye filosu/zincir restoran SaaS | (c) Hibrit (önce operasyon, sonra SaaS) |
|---|---|---|---|
| Müşteri | Kuryesi olmayan/yetersiz restoranlar, zincir şubeler | Kurye filosu işleten firmalar, kendi kuryesi olan zincirler | Önce restoranlar, sonra filo işletmecileri |
| Gelir modeli | Paket başı ücret veya aylık kurye kiralama (kurye/ay) | Kurye/ay veya paket/ay aboneliği (+ SMS/tracking link ücreti) | 3PL geliri + SaaS lisans gelirleri |
| Pazar çıpası (TR) | Platform vale: ~%20 dağıtım bedeli [S19]; Trendyol Go 2024: >200 mn sipariş, 2 mlr $ brüt hacim [S32, S33]; Getir yemek 2025 brüt hacim >1 mlr $ [S35] | POS fiyatları: Adisyo 1.040–2.150 TL/ay [S64]; Hemen Yolda sipariş sayısına göre fiyat [S71] | İki gelir akışı |
| Ölçeklenebilirlik | Düşük–orta (kurye arzı, bölge yoğunluğu) | Yüksek (yazılım) | Orta |
| Brüt marj profili | İnce, kurye maliyetine duyarlı (Bölüm 3) | Yüksek ama ARPU düşük (yerel çıpa) | Karışık |
| Ana riskler | Muvazaa/işçi riski, grev, sermaye, platform vale rekabeti | Platform API erişimi, POS firmalarının paketlemesi, düşük ARPU, parçalı müşteri | Odak kaybı; SaaS müşterisi (rakip 3PL) veri güveni sorunu |
| Benzer örnekler | Platform filoları (Yemeksepeti vale, Trendyol Go, Getir) — kendi filolarını işletiyor; B2B kurye pazaryerleri: Stuart, Uber Direct, DoorDash Drive `[DOĞRULANMADI: genel bilgi]` | Onfleet, Tookan, Shipday, Track-POD, Detrack, Spoke [S52–S63]; TR: Hemen Yolda, Loji Team, SepetTakip [S70–S73] | **Shipday**: SaaS + üçüncü taraf anlık teslimat (Uber/DoorDash) ücret başına faturalama [S55]; platform+serbest kurye ağı modeli Stuart `[DOĞRULANMADI]` |

**Analist değerlendirmesi `[TAHMİN]`:**
- Saf SaaS'ta kanıtlanmış bir TR fiyat çıpası yok ve POS firmaları (Adisyo, Simpra, YemekPOS) kurye takibi/paket servis modülünü zaten paketliyor [S64–S69]. Farklılaşma: çoklu platform siparişi + kurye uygulaması + hakediş/vardiya + canlı takip (özellikle esnaf kuryenin birden çok işletmeye çalıştığı yapı).
- Saf 3PL'de marj kurye ödemesine ve verimliliğe aşırı duyarlı; kâr "paket/saat" ve "esnaf-bordro karması" ile belirleniyor.
- Hibritin tutarlı hikâyesi: 3PL pilotu veriyi (paket/saat, mesafe, iptal, gecikme) üretir; SaaS bu veriyle ürünleşir. Risk: rakip filo işletmecilerinin veri güveni.

---

## 3. Türkiye birim ekonomi verileri (2025–2026)

### 3.1 Veri tablosu

| Metrik | Değer | Yıl | Kaynak | Güven / not |
|---|---|---|---|---|
| Brüt asgari ücret | 33.030 TL (günlük 1.101 TL) | 2026 | [S1, S2, S3] | Orta (ikincil; resmî sayfa açılamadı) |
| Net asgari ücret | 28.075,50 TL (SGK işçi %14 = 4.624,20; işsizlik işçi %1 = 330,30 kesintisi) | 2026 | [S1, S2] | Orta; kontrol: 33.030 − 4.624,20 − 330,30 = 28.075,50 ✓ |
| İşveren SGK payı | 7.184,03 TL (%21,75) | 2026 | [S2] | Orta; kontrol 33.030×0,2175 ✓ |
| İşveren işsizlik primi | 660,60 TL (%2) | 2026 | [S2] | Orta ✓ |
| Asgari ücretlinin işveren maliyeti | 40.874,63 TL (indirimsiz); 40.214,03 TL (imalat dışı sektör, 2 puan prim indirimi); 39.223,13 TL (imalat, 5 puan) | 2026 | [S1, S2] | Orta; kurye/paket servis imalat dışı → 40.214,03 TL kullanıldı. Not: iş kazası prim oranı tehlike sınıfına göre değişir, kuryelik için ayrı doğrulanmadı `[DOĞRULANMADI]` |
| Asgari ücret artışı | %27 | 2026 | [S14, S15] | Orta (Trendyol Go tarife duyurusu özeti) |
| Benzin (kurşunsuz 95), İstanbul | ~80,30–80,45 TL/L (Aytemiz, 1 Ekim 2026, bazı ilçeler); ÖTV artışı Ekim–Aralık'a yayıldı | 2026-10 | [S5] | **Düşük–Orta:** tek kaynak, özet belirsiz (KDV indirimi sona erdiği notu net değil). Hesapta 80 TL kullanıldı |
| 110–125 cc moto yakıt tüketimi | 1,8–2,5 L/100 km | 2026 | [S6] | Orta (sektör rehberi) |
| Yakıt maliyeti/km (türetilmiş) | 1,44–2,00 TL/km (80 TL × tüketim) | 2026 | Hesap | Türetilmiş |
| Yemeksepeti komisyonu (restoranın kendi kuryesi / gel-al) | %12 (KDV dahil %14,4) | 2026 | [S19, S20] | Düşük–Orta (satıcı blogları; sözleşmeye bağlı) |
| Yemeksepeti komisyonu (vale/Yemeksepeti kuryesi) | %12 iletim + %20 dağıtım = %32 (KDV dahil %38,4) | 2026 | [S19, S20] | Düşük–Orta |
| Efektif kesinti | kendi kuryeli restoranda ~%29; vale ağırlıklı restoranda >%50 (incelenen haftalarda) | 2026 | [S19] | Düşük (tek bloğun örneği) |
| Trendyol Yemek komisyon örneği | %22 komisyon; kampanya/iade dahil efektif ~%29,5 (60.000 TL aylık brüt satış örneği) | 2026 | [S22] | Düşük (örnek) |
| Platformlar arası komisyon bandı | %15–40 (teslimat modeli, kategori, şehir, sözleşme); efektif maliyet sözleşme oranının 5–15 puan üstüne çıkabilir | 2026 | [S21, S23] | Düşük–Orta |
| Trendyol Go 2024 | >200 mn sipariş, 2 mlr $ brüt hacim (%50+ artış); 90.000+ restoran/market, 19.000 kurye | 2024 | [S32, S33, S34] | Yüksek (Uber 10-Q/ortaklık duyurusu) |
| **Ortalama sipariş değeri (türetilmiş)** | 2 mlr $ / 200 mn = **~10 $/sipariş** (yemek+market karışık) | 2024 | Hesap [S33] | Türetilmiş; TL karşılığı için kur doğrulanmadı |
| Getir yemek 2025 | brüt hacim >1 mlr $ (%50 artış) | 2025 | [S35] | Orta |
| "Sipariş başı ortalama sepet 645 TL (ETİD 2026)" | 645 TL | 2026 | [S51] | **Düşük `[DOĞRULANMADI]`:** genel e-ticaret sepeti olabilir, yemek özelinde olduğu doğrulanmadı. "350 TL" örnek de aynı aramada çıktı |
| Yemek sepeti 2026 için çalışma aralığı | 400–650 TL | 2026 | `[TAHMİN]` | Gerekçe: TGo 2024 ~10 $/sipariş; 2 yıllık TL enflasyonu ve kur etkisiyle ölçeklendi; **doğrulanmış resmî yemek sepeti verisi bulunamadı** |
| Restoranın teslimat başı maliyeti | Vale: sepetin ~%20'si (dağıtım) + %12 iletim; kendi kurye: bordrolu maliyet (Bölüm 3.3) | 2026 | [S19] + hesap | Türetilmiş |
| 3PL paket servis firmasının paket başı fiyatı (İstanbul/Ankara/İzmir) | **Bulunamadı** `[DOĞRULANMADI]` | — | — | Fiyat çıpası olarak vale dağıtım bedeli kullanıldı |
| Esnaf kurye — Getir (2026) | Birleşik paketin ilki 88,00 TL, sonrakiler 60,50 TL (motor); araçlı: 93 / 79 TL | 2026 | [S13] | Düşük–Orta (rehber sitesi) |
| Esnaf kurye — Trendyol Go İstanbul km tarifesi | 0–3 km 6,5 TL; 3–5 km 6,7 TL; 5–6 km 7,1 TL; 6+ km 7,8 TL (önceki: 5,1/5,3/5,6/6,1) | 2026 | [S7, S14] | Orta |
| Esnaf kurye — çoklu sipariş | 25,5–50 TL (%24–47 artış); saatlik açılış 51–100 TL (Pzt 14–17: 51; gece 02:30+: 92; Pazar: 100) | 2026 | [S7] | Orta (NTV özeti) |
| Platform bazlı "paket başı" aralıkları | TrendyolGo 25–45; Getir 20–40; Yemeksepeti 22–38 TL | 2026 | [S15, S16] | **[ÇELİŞKİ]:** Getir 88/60,5 TL rakamıyla uyuşmuyor; farklı tarife bileşenleri (km, saat, bonus) karışmış olabilir |
| Esnaf kurye brüt aylık ciro | TGo 85–110 bin; Yemeksepeti 80–100 bin; Getir 75–95 bin TL; NTV: "100 bin TL üstü", ortalama brüt ~118 bin TL | 2026 | [S7, S15] | Düşük–Orta; uzun çalışma saatine bağlı |
| Kurye maaş ortalamaları | Ortalama 47.200 TL; esnaf kurye ort. 41.100 (30.300–66.100) | 2026 | [S15] | Düşük (maaş portalı) |
| Esnaf kurye aylık gideri | Yakıt 3.000–5.000; bakım 500–1.500; amortisman 700–2.000; toplam 5.000–9.000 TL; giderler sonrası brüt cironun ~%60–70'i kalır | 2026 | [S16] | Düşük; yakıt kalemi benim hesabımdan (Bölüm 3.3) düşük çıkıyor `[ÇELİŞKİ]` |
| Bordrolu moto kurye aylık toplam maliyeti | **~55.600 TL** (hesaplanmış, Bölüm 3.3) | 2026 | Hesap | `[TAHMİN]` girdiler içerir |
| Eski/ikincil "bordrolu 35–45 bin TL" iddiası | 35.000–45.000 TL | (tarihsiz, muhtemelen 2025) | arama özeti | **Kullanılmadı:** 2026 asgari ücret işveren maliyeti (40.214 TL) tek başına bu aralığın içinde; yakıt/motor dahil değil |
| Motosiklet kira bedeli (aylık) | **Bulunamadı** `[DOĞRULANMADI]` | — | [S6]'nın aramasında aylık kurye motoru kirası çıkmadı | Amortisman kalemi esnaf için 700–2.000 TL [S16] |
| Kurye çalışma süresi | Moto kuryelerin %64,5'i günde 10 saatten fazla; Getir Yemek Go kuryeleri günde 12–15 saat | tarih belirsiz | arama özeti, URL eşleşmesi net değil | **Düşük `[DOĞRULANMADI]`** |
| Günlük mesafe | Esnaf kurye günde ~200 km | 2025–26 | [S7] çevresi arama özeti | Düşük |
| Kurye saatte ortalama teslimat sayısı | **Doğrulanmış veri bulunamadı** | — | — | Hesapta 2,0 / 2,5 / 3,0 paket/saat duyarlılık `[TAHMİN]` |
| Ortalama teslimat mesafesi/süresi | **Doğrulanmış veri bulunamadı.** Platform km kademeleri 0–3, 3–5, 5–6, 6+ km | 2026 | [S7] | Kademeler ortalamanın 3–6 km bandında olduğunu ima eder `[TAHMİN]` |
| Esnaf kurye ücreti artış tartışması | Yemeksepeti %30 artış duyurdu; kuryeler bonus koşulu nedeniyle etkin artışın %10–14 olduğunu söylüyor; 18–20 Ocak 2026 kontak kapatma | 2026-01 | [S9, S10, S11, S12] | Orta (iddialar kurye tarafından) |
| Online yemek pazarı büyüklüğü | 2024'te ~150 mlr TL'yi aşması bekleniyor; kullanıcı 2023'te 31,1 mn → 2024'te 34,8 mn | 2023–24 öngörü | [S50, S98] | Düşük–Orta (öngörü, tarih eski) |
| Yemeksepeti kullanıcı/işletme | 30 mn+ kullanıcı, ~90.000 iş ortağı; pazar payı %34–42 (kaynağa göre) | 2026 | [S44] | Orta; "2025'te 13,2 mn aktif kullanıcı" ifadesi başka sonuçta çıktı `[ÇELİŞKİ]` |
| Üç büyük oyuncunun toplam payı | ~%90 (Yemeksepeti + Trendyol Go + Getir) | 2026 | [S44] | Orta |
| Kurye arzı | "35 bin lira maaşı var ama çalışan bulamıyorlar" başlığı | 2025–26 | [S18] | Düşük (yalnızca başlık görüldü) |

### 3.2 Hesap varsayımları (açık)

Hepsi `[TAHMİN]` aksi belirtilmedikçe:
- Yakıt 80 TL/L [S5], tüketim 2,2 L/100 km (aralığın ortası) [S6] → 1,76 TL/km.
- Çalışma günü 26/ay; günlük 150 km (bordrolu), esnaf için 200 km [S7].
- Bordrolu çalışma süresi: haftalık 45 saat × 52 / 12 = 195 saat/ay (yasal normal süre; fazla mesai hesaba katılmadı).
- Bordrolu aylık maliyet = asgari ücret işveren maliyeti 40.214 TL (2 puan indirimli) [S1, S2] + yakıt 6.864 TL + bakım 1.500 TL + amortisman 2.000 TL (üst sınır [S16]) + sigorta/muayene/vergi 1.000 TL `[TAHMİN]` + yemek/yol 4.000 TL `[TAHMİN]` = **55.578 TL**.
- Değişken maliyet 4 TL/paket (ödeme komisyonu, SMS/takip, ek sigorta, dispatch payı) `[TAHMİN]`.
- Genel gider (ofis, destek, dispatcher, tahsilat riski, kurye edinimi) bu hesapta **yok**; tipik olarak gelirin %10–15'ini yiyebilir `[TAHMİN]`.
- Fiyat çıpası: Yemeksepeti vale dağıtım bedeli sepetin %20'si (KDV hariç) [S19]; 3PL için 75/95/115 TL/paket senaryoları, kurye ödemesi 55/70/85 TL (Getir'in 60,5–88 TL aralığı çevresinde [S13]).
- Sepet 400/500/650 TL `[TAHMİN]` (bkz. tablo).

### 3.3 Örnek hesap: paket başı katkı marjı

**A) Bordrolu moto kurye — aylık toplam maliyet ve paket başı maliyet (195 saat/ay)**

| Verimlilik (paket/saat) | Paket/ay | Paket başı maliyet (TL) |
|---|---|---|
| 1,5 | 292 | 190 |
| 2,0 | 390 | 143 |
| 2,5 | 488 | 114 |
| 3,0 | 585 | 95 |

Maliyet ≈ 55.578 TL/ay sabit. Kalan her ek paket marjinal olarak ucuz; bordrolu modelin asıl riski **boş saat (düşük kullanım)**.

**B) 3PL katkı marjı (esnaf kurye modeli; yakıt/bakım kuryede, Hızla kurye başına paket ödemesi yapar)** — katkı = fiyat − kurye ödemesi − 4 TL

| Hızla fiyatı → / Kurye ödemesi ↓ | 75 TL | 95 TL | 115 TL |
|---|---|---|---|
| 55 TL | 16 TL (%21) | 36 TL (%38) | 56 TL (%49) |
| 70 TL | 1 TL (%1) | **21 TL (%22)** | 41 TL (%36) |
| 85 TL | −14 TL (−%19) | 6 TL (%6) | 26 TL (%23) |

**C) 3PL katkı marjı (bordrolu kurye modeli)** — katkı = fiyat − (55.578 / paket sayısı) − 4 TL

| Fiyat ↓ / Verimlilik → | 2,0 p/s | 2,5 p/s | 3,0 p/s |
|---|---|---|---|
| 95 TL | −52 TL (−%54) | −23 TL (−%24) | −4 TL (−%4) |
| 115 TL | −32 TL (−%27) | −3 TL (−%3) | 16 TL (%14) |
| 135 TL | −12 TL (−%9) | 17 TL (%13) | 36 TL (%27) |

**D) Restoran perspektifi: Yemeksepeti vale (%32) ile kendi kurye/3PL (%12 komisyon + 3PL ücreti) karşılaştırması** (KDV hariç, her iki taraf KDV indirebilir varsayımı; komisyon tabanı = sepet)

| Sepet | Vale (%32) | %12 + 3PL 75 TL | %12 + 3PL 95 TL | %12 + 3PL 115 TL |
|---|---|---|---|---|
| 400 TL | 128 TL | 123 (−%4 tasarruf) | 143 (+%12 pahalı) | 163 (+%27 pahalı) |
| 500 TL | 160 TL | 135 (%16 tasarruf) | 155 (%3 tasarruf) | 175 (+%9 pahalı) |
| 650 TL | 208 TL | 153 (%26 tasarruf) | 173 (%17 tasarruf) | 193 (%7 tasarruf) |

**Yorumlar:**
1. Esnaf modelinde katkı marjı **kurye ödemesi − fiyat spreadine** bağlı; 95 TL fiyat/70 TL ödeme senaryosunda ~%22 katkı, genel giderler düşülünce net marj tek haneye iner `[TAHMİN]`.
2. Bordrolu model, rekabetçi fiyatlarda (≤115 TL) ancak ≥3 paket/saat ve yüksek doluluk ile pozitif. Bordrolu çekirdek = yalnızca doluluğu garantili (zincir/yoğun) hatlarda.
3. Restoranın vale yerine kendi kuryesi/3PL'i seçme teşviki **sepet 500 TL altında zayıf** (fiyat tavanı ~75–95 TL), 650 TL'de güçlü. Satış argümanı yalnızca maliyet olmamalı: kontrol, müşteri verisi, marka deneyimi, kampanya bağımsızlığı.
4. Bu hesap **platform kurye ücretinin zaten kullanıcıya yansıdığı** (müşteriden alınan teslimat bedeli) durumları hesaba katmıyor. Restoran kendi kuryesiyle teslim ederken müşteriden alınan teslimat ücreti farkı da değiştirebilir `[DOĞRULANMADI]`.
5. **Kaynak tutarsızlığı** (esnaf kuryenin ~100–118 bin TL brüt kazandığı iddiası ile 60–88 TL/paket tarife): bu gelire ulaşmak için ~30–40 paket/gün ve/veya yoğun saatlik bonus gerekiyor (hesap: 30 paket/gün × 26 gün × 75 TL ≈ 58.500 TL; 40 paket/gün × 26 gün × 88 TL ≈ 91.500 TL; saatlik bonuslar hariç). Yani üst gelir rakamları **12–15 saat/gün** çalışmayı varsayıyor [S15, S7].

---

## 4. Global last-mile / dispatch SaaS rakipleri

### 4.1 Fiyatlandırma (halka açık/üçüncü taraf kaynaklı, 2025–2026)

| Ürün | Model | Yayınlanan fiyatlar | Kaynak | Güven |
|---|---|---|---|---|
| **Onfleet** | Aylık plan + tamamlanan görev (pickup veya delivery = 1 görev) | Launch ~619 $/ay (2.500 görev); Scale ~1.349 $/ay (5.000 görev); Enterprise ~3.099 $/ay (10.000+); aşım ~0,26 $/görev (hacimle düşer); Courier Suite eklentisi 299 $/ay; sınırsız kullanıcı | [S52, S53, S54] | Orta (toplayıcı siteler; resmî sayfa açılamadı) |
| **Tookan (JungleWorks)** | Aylık plan + görev | Startup 99 $ (1.000 görev, +0,16 $); Growth 199 $ (3.000, +0,13 $); Standard 299 $ (6.000, +0,09 $); Enterprise özel; sınırsız ajan/sürücü; yıllık %20–30 indirim | [S58, S59] | Orta |
| **Shipday** | Aylık plan + aşan sipariş (SMS dahil) | Listelenen: Professional ~39 $/ay (750 sipariş, +0,04 $); Branded Elite ~119 $/ay (500 sipariş, +0,10 $); Business Advanced ~299 $/ay (1.000, +0,25 $); bölgeye göre farklı; 3. taraf anlık teslimat (Uber/DoorDash) sağlayıcının teklif ettiği ücretle teslimat başına faturalanır | [S55, S56, S57] | **Düşük–Orta `[ÇELİŞKİ]`:** özet içinde "29 $/ay 300 sipariş" ifadesi de geçiyor; plan adları/fiyatları tutarsız, resmî sayfa teyit edilmeli |
| **Track-POD** | Sürücü başı | 49–59 $/sürücü/ay (Advanced) – 89–99 $ (Ultimate); yıllık/aylık fark; min. 3 sürücü | [S60] | Orta |
| **Detrack** | Sürücü uygulaması başı | Pro 29 $, Advanced 39 $ /sürücü uygulaması/ay | [S61, S63] | Orta |
| **Spoke (eski Circuit) Dispatch** | Aylık plan + durak sayısı | Starter 125 $/ay (1.000 durak); Premium 200 $ (2.000 durak); Expert 1.000 $ (12.000 durak) | [S62] | Orta |
| Routific | — | Bu oturumda fiyat bulunamadı | — | `[DOĞRULANMADI]` |
| Bringg, Locus, Stuart, Orkestro, Deliverect, Otter, UrbanPiper | — | **Fiyat/özellik doğrulanamadı** (arama kotası bitti). Genel bilgi: Bringg ve Locus kurumsal/teklif bazlı; Stuart kurye pazaryeri (teslimat başı); Deliverect/Otter/UrbanPiper sipariş toplayıcı (aggregator) entegrasyon katmanı | — | `[DOĞRULANMADI]` |

**Birim fiyat kıyası (türetilmiş):** Tookan Standard ≈ 299 $ / 6.000 görev ≈ 0,05 $/görev; Onfleet Launch ≈ 619 $ / 2.500 ≈ 0,25 $/görev. Restoran teslimatı = pickup + dropoff olabilir (Onfleet'te 2 görev). Yani global dispatch yazılım maliyeti teslimat başı ~0,1–0,5 $ düzeyinde; bu rakam TR'de Hızla fiyatlaması için üst bant referansıdır (kur doğrulanmadı).

### 4.2 Özellik matrisi

Gösterim: ● = bir arama sonucunda açıkça belirtildi; ○ = genel ürün bilgisi, **bu oturumda doğrulanmadı**; – = bilinmiyor.

| Özellik | Onfleet | Tookan | Shipday | Track-POD | Detrack | Spoke/Circuit | Bringg | Locus | Stuart |
|---|---|---|---|---|---|---|---|---|---|
| Dispatch paneli | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| Otomatik atama | ● (Scale planı: auto-dispatch) | ○ | ○ | ○ | – | – | ○ | ○ | ○ |
| Rota optimizasyonu | ● (Launch: temel; Scale: gelişmiş) | ○ | ○ | ○ | ○ | ○ | ○ | ○ | – |
| Canlı takip linki / dinamik ETA | ● (Scale: dinamik ETA) | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| Teslim kanıtı (POD) | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| Kurye uygulaması | ○ | ○ (white-label) | ○ | ○ | ● (sürücü uygulaması başı fiyat) | ○ | ○ | ○ | ○ |
| Vardiya/slot yönetimi | – | – | – | – | – | – | ○ | ○ | – |
| Hakediş/ödeme | ○ (Courier Suite eklentisi ne içeriyor: doğrulanmadı) | – | ○ | – | – | – | – | – | ○ |
| Barkod, kimlik/yaş doğrulama | ● (Scale) | – | – | – | – | – | – | – | – |
| Entegrasyonlar (POS/aggregator) | ○ (API/webhook) | ○ | ○ | ○ | ○ | – | ○ | ○ | ○ (API) |
| 3. taraf kurye pazaryeri | – | – | ● (Uber/DoorDash teslimat başı) | – | – | – | ○ | – | ● (model kendisi) |
| Analitik/raporlar | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | – |
| Çok marka/bölge, SSO, SLA | ● (Enterprise) | ● (Enterprise özel) | – | – | – | – | ○ | ○ | – |

**Boşluk analizi (Hızla için):** Yukarıdaki global ürünler Türkiye'ye özgü şunları sunmuyor/sunmadığı doğrulanmadı: Yemeksepeti/Getir/Trendyol/Migros sipariş toplama, esnaf kurye hakedişi (paket+km+saat+bonus tarifeli), TL ve yerel fatura/mutabakat, TR'ye uygun KVKK. Bu bir **fırsat hipotezi**; kaynakla doğrulanmış kanıt değil `[TAHMİN]`.

---

## 5. Türkiye'deki muadiller

| Ürün | Ne yapıyor | Fiyat | Entegrasyon / kurye takibi | Eksik/belirsizlik | Kaynak |
|---|---|---|---|---|---|
| **Adisyo** (Kobitime/Adisyo) | Bulut POS/adisyon; kurye takip sistemi sunuyor | Lite 1.040 TL/ay (1–3 personel); Pro 2.150 TL/ay; Lite yıllık 12.500 TL (peşin; 18.500 TL seçeneği ve 3.700 TL tasarruf ifadesi görüldü); başlangıç paketi (1 yıl Lite + Windows POS + yazıcı + çekmece) 54.900 TL | Kurye takip sistemi var [S65]; aggregator entegrasyonu detayı doğrulanmadı | Eski haber özetinde "59–79 TL/ay" çıktı (2020 öncesi veri; **güncel değil**) | [S64, S65] |
| **Simpra / Simpra Suite** | Bulut restoran otomasyonu | **Fiyat bulunamadı** | Yemeksepeti, GetirYemek, Trendyol Yemek entegrasyonu; teslimat servisleri programı (QR/telefon/online sipariş) [S68] | Fiyat ve kurye uygulaması derinliği doğrulanmadı | [S68] |
| **YemekPOS** | 2009'dan beri restoran otomasyonu; merkezi yönetim, franchise, kurye entegrasyonları | Bulunamadı | "Gelişmiş kurye entegrasyonları" iddiası [S69] | Detay yok | [S69] |
| **Kolay Restoran** | POS + paket servis özelliği; Yemeksepeti entegrasyonu | 540 TL/ay (15 gün deneme) — **tarih doğrulanmadı** | Paket servis takibi, Yemeksepeti entegrasyonu sayfası var [S66, S67] | Güncel olduğu doğrulanmadı | [S66, S67] |
| **SambaPOS** | POS; Getir entegrasyon sayfası | Bulunamadı | Getir entegrasyonu [S77] | — | [S77] |
| **Restoranmatik, Restofy** | Kullanıcının listesindeki POS'lar | **Arama sonucu çıkmadı** | — | Var olduğu bu oturumda doğrulanmadı `[DOĞRULANMADI]` | — |
| **SepetTakip** | Zeytinburnu merkezli; kurye ve paket servis süreci dijitalleştirme | Bulunamadı | Yemeksepeti, Getir, Trendyol, Migros Yemek entegrasyonu; canlı konum, kurye performans raporu [S70] | Fiyat/ölçek yok | [S70] |
| **Hemen Yolda** | Akıllı kurye takip / saha yönetimi (2017 kuruluş); restoran yöneticisi tek sayfadan kurye ve paket izler; müşteriye harita takibi | Aylık sipariş sayısına göre ücret (2018); mobil uygulama ücretsiz | — | Sodexo 2019'da 550 bin $ yatırım yaptı; güncel ölçek bilinmiyor | [S71, S72] |
| **Loji Team** | Akıllı kurye yönetimi; tam otomatik atama, paket birleştirme, harita izleme | Bulunamadı | Online kanallardan/telefondan gelen paketler | "Yüzlerce ekip, 1.000+ kurye" iddiası (uygulama mağazası metni) | [S73] |
| **RestoKurye, RestoWay** | Kurye/sipariş takip mobil uygulamaları | RestoKurye "0,02 $ başlangıç, ücretsiz sürüm" (toplayıcı verisi, güvenilmez) | Durum güncelleme | Düşük güvenilirlik | [S74, S75] |
| **iletmen** | Entegrasyon/ödeme; kurye kapıda yemek kartı tahsilat | Bulunamadı | Entegrasyon sayfası mevcut | — | [S76] |
| **Sipariş Ustası** | Yemeksepeti, Trendyol (Uber Eats), Getir ve Migros panel yönetimi, hakediş/mutabakat | Bulunamadı | Çoklu panel yönetimi | Aynı zamanda içerik pazarlama yapıyor (S19–S24 kaynakları kısmen onun) | [S20–S23] |

**Eksikler (Hızla için fırsat hipotezi, `[TAHMİN]`):** Esnaf kurye merkezli çoklu işletme dispatch'i; hakediş/vardiya/slot yönetimi; kurye mobil uygulamasında yerel çevrimdışı/konum sağlamlığı; 3PL için işletme paneli + admin/dispatch panelinin tek yığın olması. Ancak yerel rakiplerin gerçek özellik matrisi doğrulanamadı; ürün keşfi (demo/deneme hesapları) gerekli.

---

## 6. Entegrasyon olanakları

| Platform | Herkese açık mı? | Sipariş/durum/webhook | "Restoranın kendi kuryesi" | Erişim koşulu | Kaynak | Güven |
|---|---|---|---|---|---|---|
| **Yemeksepeti (Delivery Hero)** | Belge **herkese açık** (integration.yemeksepeti.com; developer.yemeksepeti.com; developers.deliveryhero.com) | **Order Dispatch (WebHook)** ile yeni sipariş bildirimi; **Update Order Status (POST)**: kabul/ret ve restoran kuryesiyle teslim edilecek/müşteri alacak siparişlerde "restorandan alındı" güncellemesi; **Mark Order as Prepared** (Yemeksepeti kuryesi için hazır) | Evet: "restoran kuryesi ile taşınacak veya müşteri alacak" akışı belgede ayrı tanımlı; **kurye kimlik/konum bilgisinin platforma iletilip iletilemediği doğrulanmadı** `[DOĞRULANMADI]`. Delivery Hero q-commerce API'sinde "vendor delivery" için READY_FOR_PICKUP, DISPATCHED, CANCELED durumları var; restoran POS API'sinden farklı olabilir | Entegrasyon adı/kodu, base URL, zincir kodu, test restoranı için **Yemeksepeti entegrasyon ekibiyle iletişim**; Client ID/Secret hesap yöneticisinden; token 2 saat geçerli (Delivery Hero genel model) | [S78, S79, S80, S81] | Orta (belge özetleri) |
| **Getir Yemek** | **Doğrulanamadı** `[DOĞRULANMADI]` | Üçüncü taraf entegratörler "50+ webhook olayı"/çok şubeli Getir entegrasyonu (Odoo modülü), SambaPOS Getir entegrasyonu, iletmen entegrasyonları sunuyor → bir API/webhook mekanizması var görünüyor | Doğrulanamadı | Onay/ortaklık şartı doğrulanamadı | [S76, S77, S86] | Düşük |
| **Trendyol Yemek / Trendyol Go** | developers.trendyol.com herkese açık (genel pazaryeri API'si); **yemek (Trendyol Go/Yemek) API'sinin ayrı/açık olup olmadığı doğrulanamadı** `[DOĞRULANMADI]` | Pazaryeri API'sinde **webhook** mekanizması (getshipmentpackage yerine tetiklenen) var [S82]; Trendyol Yemek için üçüncü taraf entegrasyonlar (BirFatura) siparişleri çekip fatura kesiyor; kimlik doğrulama Basic Auth, bilgiler satıcı panelinde "Entegrasyon Bilgileri" | Doğrulanamadı | Satıcı panelinden API bilgisi (Trendyol Yemek için BirFatura sayfası) | [S82, S83, S84, S85] | Düşük–Orta |
| **Migros Yemek** | **Doğrulanamadı** `[DOĞRULANMADI]` | SepetTakip Migros Yemek entegrasyonunu listeliyor [S70], Sipariş Ustası panel yönetimi sunuyor [S20] | Doğrulanamadı | — | [S70] | Düşük |

**Önemli notlar:**
- Entegrasyon için "POS firması / entegratör" olarak başvurmak gerekebilir; bireysel restoran paneli API'si (BirFatura örneği) alternatif yol olabilir. Hukuki/ticari uygunluk (platform şartları: veri kullanımı, kurye atama) **doğrulanmadı**.

---

## 7. Yasal ve uyum kontrol listesi

> **Uyarı:** Bu bölümde bu oturumda kaynakla doğrulanabilen madde sayısı çok sınırlı. Kaynaklı olanlar `[S#]` ile gösterildi; geri kalanı **genel hukuk bilgisi** olup `[DOĞRULANMADI]`'dır. Hukuk müşaviri/mali müşavir teyidi şart.

| # | Konu | Durum / bulgu | Eylem | Kaynak/güven |
|---|---|---|---|---|
| 1 | **6475 sayılı Posta Hizmetleri Kanunu ve BTK yetkilendirmesi** | Kurye işletmecilerinin "gönderi" taşıma süresi taahhüdü düzenlemesi (2023 sonu) kurye işletmecilerinin posta mevzuatı kapsamında düzenlendiğine işaret ediyor [S87, S88]. Yemek/paket servis teslimatının "gönderi" sayılıp sayılmayacağı, 3. taraf 3PL için BTK yetkisi gerekip gerekmediği **doğrulanamadı** | BTK'ya yazılı görüş / hukuk görüşü; yetki gerekiyorsa başvuru süreci ve sermaye/teminat koşulları | `[DOĞRULANMADI]` |
| 2 | **Ulaştırma Bakanlığı belgeleri, motosiklet ticari kullanım** | Motosiklet sigortasında ticari kullanım (kurye, teslimat) bireysele göre belirgin farklı risk katsayısıyla fiyatlanıyor [S90]. Ticari plaka/taşıma yetki belgesi gereklilikleri **doğrulanamadı** | Karayolları Taşıma Yönetmeliği ve UKOME kararları taraması | `[DOĞRULANMADI]` |
| 3 | **KVKK (6698)** | Konum verisi, müşteri ad/adres/telefonu, kurye verisi kişisel veridir. Genel bilgi: restoran = veri sorumlusu, Hızla = veri işleyen (veri işleme sözleşmesi); kurye konum takibi için aydınlatma + dayanak (sözleşme/meşru menfaat; çalışan ilişkisinde açık rızanın serbest iradeyle verilmediği yaklaşımı); saklama süresi amaçla sınırlı, saklama-imha politikası ve periyodik imha; VERBİS yükümlülüğü eşikleri; yurt dışı aktarım (bulut) kuralları 2024 değişikliği ile güncellendi | Saklama-imha politikası, aydınlatma metni, DPA şablonu, konum verisi saklama süresi (ör. 30–90 gün `[TAHMİN]`), erişim logları | `[DOĞRULANMADI]` (genel bilgi) |
| 4 | **e-Fatura / e-Arşiv / e-Adisyon** | 3PL, restorana hizmet faturası keser; eşik kontrolü ve e-fatura/e-arşiv mükellefiyeti mali müşavirle netleştirilmeli. Esnaf kuryelerin Hızla'ya belge kesme biçimi (fatura/SMM/gider pusulası) **doğrulanamadı**. Esnaf kuryelerin şirket kurma/genç girişimci teşviki rehberi mevcut [S91]. E-adisyon düzenlemesi POS/SaaS tarafında bir uyumluluk konusu olabilir | Mali müşavir; esnaf kurye için belge akışı tasarımı | `[DOĞRULANMADI]` |
| 5 | **Esnaf kurye ve muvazaa/işçi sınıflaması riski** | Genel bilgi: kurye bağımsız çalışsa bile tek merkezden talimat, atama, vardiya, tarife dayatması, münhasır çalışma "bağımlılık" göstergesi sayılabilir; asıl işveren–alt işveren (4857 s. İş Kanunu m.2) ve geçici iş ilişkisi kuralları; esnaf kurye davalarında Yargıtay kararları var `[DOĞRULANMADI: karar numaraları bu oturumda bulunamadı]`. Esnaf kurye ücret/bonus eylemleri ve "işleyiş gereği paket atamıyoruz" sözü gibi iddialar platformlar için de bağımlılık tartışması açıyor [S10] | İş hukuku danışmanı; sözleşme tasarımı (kurye slotu seçimi, reddetme hakkı, çoklu platform serbestisi); bordrolu çekirdek + esnaf havuzu karması | `[DOĞRULANMADI]` |
| 6 | **Zorunlu sigortalar** | Trafik (ZMSS) sigortası zorunlu; ticari kullanım primi daha yüksek [S90]. İşyeri/iş kazası bildirimi ve İSG yükümlülükleri (6331) bordrolu kurye için geçerli (genel bilgi). İhtiyari: taşıma/yük sorumluluk, işveren sorumluluk, kişisel kaza | Sigorta teklifleri; hasar/kaza sürecinin ürün akışına eklenmesi | `[DOĞRULANMADI]` (kısmen [S90]) |
| 7 | **Motokurye düzenlemeleri 2024–2026** | Bahşiş ve motokuryeye yeni vergi gündeme dair haber başlığı: "yeni vergi yok" [S89]; BTK kurye taşıma süresi taahhüdü düzenlemesi [S87, S88]. 2024–2026 motokurye mevzuat değişikliklerinin tam listesi **doğrulanamadı** | Resmî Gazete/BTK/Ulaştırma/Ticaret Bakanlığı tarama | `[DOĞRULANMADI]` |
| 8 | **Platform-restoran düzenlemeleri (Ticaret Bakanlığı, Rekabet)** | 1 Nisan 2026'dan itibaren komisyon, kurye ücreti, reklam bedelleri kalem kalem gösterilir; restoranlar kampanyaya zorlanamaz; temel hizmetler (sipariş oluşturma/iletim/ödeme altyapısı) ayrıca ücretlendirilemez; komisyon fiili ödenen tutardan hesaplanır [S28–S31]. Rekabet Kurulu taahhütleri (zorunlu min. sepet/joker/en çok kayrılan müşteri şartı sona erecek) [S25–S27] | Ürünün hakediş/mutabakat ekranlarında platform kalemlerini şeffaf göstermek bir özellik fırsatı | Orta |
| 9 | **Rekabet (Uber–Getir izni koşulları)** | 500 mn $ yatırım taahhüdü: nitelikli istihdam, yerel mühendislik, dijital altyapı [S38, S39, S40] | Hızla için pazar/ortaklık fırsatı olabilir `[TAHMİN]` | Orta |

---

## 8. Finansman ortamı

**Bu oturumda doğrulanan işlemler:**

| Tarih | İşlem | Detay | Kaynak |
|---|---|---|---|
| 2015 | Delivery Hero–Yemeksepeti | 589 mn $ satın alma (başlık) | [S49] |
| 2019-11 | Sodexo → Hemen Yolda | 550 bin $ yatırım | [S72] |
| 2022 | Getir | Mubadala liderliğinde turda 11,8 mlr $ değerleme; sonra ~2,5 mlr $ değerlemeye düştü | [S46] |
| 2024-06 | Mubadala Getir kontrolü | 250 mn $ yatırım, kurucu Nazım Salur CEO'luktan çekildi; Getir'in İngiltere/Almanya/Hollanda/ABD'den çekilmesi; kurucular kalan işte azınlık payı | [S46, S47] |
| 2025-05/06 | Uber → Trendyol Go | %85 pay, ~700 mn $ nakit; kuruluş değeri 824 mn $; kapanış 17 Haziran 2025; satın alma tarihi gerçeğe uygun değer 697 mn $ | [S32, S33, S34] |
| 2026-02 | Uber → Getir (yemek) | 335 mn $ peşin (yemek) + 100 mn $ ile gıda/market/su kolunda %15 pay (kalan kısım sonraki yıllarda tamamlanacak); Getir yemek 2025 brüt hacim >1 mlr $ | [S35–S37] |
| 2026-06-19 | Rekabet Kurulu onayı | Koşullu onay; 500 mn $ yatırım taahhüdü | [S38–S40] |
| 2026-07-16 | Uber → Delivery Hero teklifi | 14,8 mlr $, hisse başına 41,50 €; Yemeksepeti ve 13 pazarın bir kısmı ~1,6 mlr $'a SSW Partners'a; kapanış 2027 H2 | [S41–S45] |

**Türetilmiş çarpanlar `[TAHMİN]`:** Trendyol Go kuruluş değeri/brüt hacim ≈ 824/2.000 ≈ 0,41×; Getir yemek ilk ödeme/brüt hacim ≈ 335/1.000 ≈ 0,33× (peşin bedelin kapsamı net değil). Bu seviyeler **yatırımcıların lojistik/teslimat kolunu düşük çarpanla değerlediğini** gösterir; "kurye operasyonu" tek başına yüksek değerleme beklentisi gerçekçi değil.

**Doğrulanamayan:** 2023–2026 Türkiye lojistik/q-commerce/last-mile girişim turları (küçük/orta turlar, yatırımcı listeleri, değerlemeler) — arama kotası bitti `[DOĞRULANMADI]`. Takip araştırmada Webrazzi/Egirişim/Startups.watch taraması önerilir.

**Çıkarımlar (analist, `[TAHMİN]`):**
- Stratejik alıcı (Uber) tek alıcı gibi davranıyor; yeni bir kurye-teknoloji girişiminin çıkış yolu **platformlara satış** veya POS/ödeme oyuncularıyla birleşme olabilir.
- Uber'in 500 mn $ yatırım taahhüdü Türkiye'de yazılım/mühendislik yatırımını artıracak; teknoloji yetenek rekabeti ve potansiyel iş birliği/ortaklık fırsatı doğurur.

---

## 9. Başarılı ve başarısız örnekler ve dersler

| Örnek | Ne oldu (doğrulanan) | Ders |
|---|---|---|
| **Getir** | 2022'de 11,8 mlr $ → ~2,5 mlr $ değerleme; 2024'te İngiltere, Almanya, Hollanda, ABD'den çekildi, binlerce çalışan işten çıkarıldı; Türkiye'ye odaklandı; Mubadala 250 mn $ ile kontrolü aldı; 2026'da yemek işini Uber'e sattı [S46, S47, S35, S36] | Hızlı yurt dışı genişleme ve q-commerce birim ekonomisi sürdürülebilir olmadı; yerel yoğunluk önemli |
| **Trendyol Go** | 2024'te 200 mn+ sipariş, 2 mlr $ brüt hacim; 19.000 kurye, 90.000+ restoran/market; Uber'e 700 mn $'a %85 satış [S32–S34] | Büyük ana platformun (Trendyol) trafik/ödeme avantajıyla filo + pazaryeri büyütme mümkün; çıkış stratejik alıcıyla |
| **Yemeksepeti** | 2015'te 589 mn $ ile alındı; 2026'da ~1,6 mlr $'lık paketle SSW'ye devir planı; Rekabet Kurulu soruşturması taahhütle kapandı [S49, S41–S45, S25–S27] | Pazar lideri bile kurye/komisyon tasarımı nedeniyle rekabet incelemesine girebiliyor → restoran tarafında "teslimat zorunluluğu" kısıtlaması azalıyor |
| **Hemen Yolda** | Akıllı kurye takip SaaS; Sodexo 550 bin $; güncel ölçek bilinmiyor [S71, S72] | Yerel kurye-SaaS'lar var ama büyük hacimli çıkış hikâyesi görülmedi (bu oturumda); düşük ARPU ve parçalı müşteri zor olabilir `[TAHMİN]` |
| **Banabi** | Arama özetinde Yemeksepeti markalı market teslimat ürünü olarak geçiyor (düşük güvenilirlik); kapanış/başarısızlık iddiası **doğrulanamadı** `[DOĞRULANMADI]` | — |
| **Gorillas, Flink, İstegelsin, Scotty, Türkiye'de büyümüş paket servis firmaları** | **Bu oturumda doğrulanamadı** `[DOĞRULANMADI]`. Genel bilgi (teyit gerekir): Gorillas Getir tarafından satın alındı, hızlı ticarette birim ekonomisi ve yoğunluk sorunları sektörün temel ders konusu | Takip araştırma gerekli |

**Hızla için çıkarılabilen dersler (`[TAHMİN]`, doğrulanmış verilere dayanarak):**
1. Yoğunluk önce: Getir/Trendyol Go örnekleri yoğun şehir içi hacim ve kurye doluluk oranının her şey olduğunu gösteriyor; Hızla için 1–2 ilçe ile başlayıp paket/saat'i ölçmek.
2. Marj düşük, sermaye ağır: büyük oyuncular bile nakit yaktı; Hızla'nın finansmanı kurye maliyetinin (tahsilat gecikmesi dahil) işletme sermayesini hesaba katmalı.
3. Platform karşısında bağımsız konum: platformlar komisyon/kampanya zorlaması nedeniyle düzenleyici baskı altında (S25–S31) → restoranların alternatif teslimat çözümüne ilgisi artabilir; ama platformlar B2B kurye hizmetini (vale) zaten sunuyor.

---

## 10. Makro riskler (olasılık / etki)

Not: olasılık/etki değerlendirmeleri **analist tahminidir `[TAHMİN]`**; dayanak kaynaklar yanında.

| Risk | Olasılık | Etki | Gerekçe/kaynak | Azaltma |
|---|---|---|---|---|
| Platform konsolidasyonu (Uber + Yemeksepeti/SSW) → kendi filo/vale ve fiyat gücü | Yüksek | Yüksek | Üç oyuncu ~%90 pay; Uber iki platformu birleştiriyor [S38, S39, S44] | Çok platformlu adapter; platform bağımsız restoran-doğrudan sipariş kanalı |
| API erişiminin değişmesi/kısıtlanması (marka birleşmesi, onay şartları) | Orta–Yüksek | Yüksek | Getir/TGo Uber Eats çatısına geçecek [S38]; Getir/Trendyol/Migros API şartları doğrulanamadı | Adapter katmanı; yalnızca resmî/izinli API yolları (ekran kazıma gibi izinsiz yollara başvurmamak) |
| Platformların B2B kurye hizmeti | Yüksek (mevcut) | Yüksek | Yemeksepeti vale zaten bu işi yapıyor [S19]; Rekabet Kurulu taahhüdü vale fiyatını maliyete bağlıyor [S25] | Hizmet/kalite farkı (veri, kontrol) |
| Asgari ücret/işçilik maliyeti artışı | Yüksek | Orta–Yüksek | 2026: +%27 [S14] | Fiyat endeksleme maddesi, verimlilik |
| Akaryakıt/ÖTV artışı | Orta–Yüksek | Orta | ÖTV artışı Ekim–Aralık'a yayıldı [S5] (özet belirsiz) | Yakıt endeksli fiyat/kurye tarifesi |
| Enflasyon ve kur (USD tabanlı bulut/SaaS maliyeti, TL gelir) | Yüksek | Orta | Genel bilgi; bu oturumda TÜİK/kur verisi aranmadı `[DOĞRULANMADI]` | Dolar endeksli SaaS fiyatı, uzun dönem sözleşme kaçınma |
| Kurye grevi/kontak kapatma | Orta | Orta | 18–20 Ocak 2026 üç günlük eylem [S9, S12] | Çoklu havuz, adil tarife şeffaflığı |
| Muvazaa/işçilik davası | Orta | Yüksek | Esnaf kurye bağımlılık tartışması [S10]; Yargıtay kararları doğrulanmadı | Hukuki yapılandırma, bordrolu çekirdek |
| BTK/Ulaştırma yetkilendirmesinin sonradan zorunlu olması | Düşük–Orta | Yüksek | Doğrulanmadı | Erken yazılı görüş |
| Rekabet: yerel kurye-SaaS ve POS paketleri | Yüksek | Orta | [S64–S76] | Çoklu platform + hakediş odağı |
| KVKK ihlali/idari para cezası | Düşük–Orta | Yüksek | Genel bilgi | Veri minimizasyonu, saklama süresi, DPA |
| Tahsilat/alacak riski (3PL, restoranlar) | Orta | Orta | Genel; doğrulanmadı | Ön ödeme/depozito, haftalık kesim |
| Düşük birim ekonomi (marj ince; bordrolu zarar) | Yüksek | Yüksek | Bölüm 3 hesapları | Pilot ölçüm, fiyat tabanı, esnaf-bordro karması |
| Düzenleyici gelişmeler (platform çalışması, komisyon sınırı) | Orta | Orta–Yüksek | Şeffaflık düzenlemesi 2026 [S28–S31]; platform çalışması mevzuatı doğrulanmadı | İzleme, esnek sözleşme |

---

## 11. Analist değerlendirmesi: seçeneklerin kıyası `[TAHMİN]`

| Kriter | (a) 3PL | (b) SaaS | (c) Hibrit |
|---|---|---|---|
| Doğrulanmış talep sinyali | Orta (vale %20 maliyet farkı [S19]) | Zayıf–Orta (yerel rakipler var, ARPU düşük [S64, S66]) | Orta |
| Sermaye ihtiyacı | Yüksek (işletme sermayesi) | Düşük | Orta |
| Marj | İnce | Yüksek (ARPU düşükse küçük) | Karışık |
| Yasal risk | Yüksek (muvazaa, BTK belirsizliği) | Düşük | Orta |
| Platform bağımlılığı | Orta | Yüksek (API) | Yüksek |
| Önerilen sıra | İkincil | Paralel ürün | **Önerilen** (dar pilot + ürünleşme) |

---

## 12. Önerilen karar kapıları (pilot için) `[TAHMİN]`

1. **Verimlilik:** Pilot bölgede ≥2,5 paket/saat (bordrolu için ≥3,0) ölçülmeli; <2,0 ise bordrolu model zarar eder (Bölüm 3 C tablosu).
2. **Katkı marjı:** Esnaf havuzunda ≥15 TL/paket katkı (≥%15) hedefi; genel gider sonrası ≥%5 net.
3. **Fiyat kabulü:** Hedef zincir restoranlarda 75–115 TL/paket aralığında sözleşme (sepet ≥500 TL ise 95+ TL mümkün).
4. **Entegrasyon:** En az bir platformdan (Yemeksepeti) resmî API erişimi onayı ve restoran kuryesi akışının çalıştığının teyidi; Getir/Trendyol/Migros şartlarının yazılı teyidi.
5. **Hukuk:** BTK ve iş hukuku yazılı görüşleri (özellikle muvazaa/esnaf sözleşmesi) pilot başlamadan.
6. **SaaS doğrulaması:** 5–10 restoran/filo işletmecisiyle kurye başı/ay fiyat testi (TR'de çıpa yok).

---

## 13. Açık kalan boşluklar (takip araştırma önerisi)

Arama kotası tükendiği için şunlar yapılmadı; yeni bir oturumda yapılmalı:
1. Getir Yemek, Trendyol Go/Yemek ve Migros Yemek resmî API belgeleri ve erişim koşulları; Yemeksepeti API'sinde restoran kuryesi bilgisi (kurye adı/telefon/konum) gönderimi.
2. BTK posta yetkilendirmesi: yemek teslimatı için gereklilik; Ulaştırma Bakanlığı motokurye belgeleri 2024–2026; Yargıtay esnaf kurye kararları.
3. Türkiye 3PL paket servis fiyat listeleri (İstanbul/Ankara/İzmir), motosiklet kira bedelleri, kurye saatlik teslimat sayısı, ortalama teslimat mesafesi/süresi.
4. 2026 yemek sepeti ortalamaları (Yemeksepeti/Trendyol/Getir resmî veya araştırma şirketi verisi), TÜİK enflasyon, USD/TRY.
5. Bringg, Locus, Stuart, Orkestro, Deliverect, Otter, UrbanPiper fiyat ve özellikleri; Routific fiyatı; Shipday resmî plan sayfası.
6. 2023–2026 Türkiye lojistik/q-commerce/last-mile girişim yatırım turları.
7. Banabi, Gorillas/Flink, İstegelsin, Scotty vakalarının doğrulanması; Türkiye'de büyümüş paket servis firmaları.
8. Rakip yerel ürünlerin (Adisyo, Simpra, SepetTakip, Loji Team, Hemen Yolda) demo/deneme hesabı ile özellik matrisi.

---

## 14. Kaynakça

Notlar: URL'lerin hepsi WebSearch sonuç listelerinde göründü; sayfaların kendisi egress engeli nedeniyle açılamadı. "Başlık" = yalnızca sonuç başlığı/özeti görüldü.

**Asgari ücret, yakıt, kurye ücretleri**
- S1 https://ikas.com/tr/blog/asgari-ucretin-is-verene-maliyeti
- S2 https://www.harbiyehukuk.com/asgari-ucret-ve-isverene-maliyeti/
- S3 https://www.muhasebetr.com/appp/asgari-ucret/
- S4 https://www.hesapkurdu.com/ticari/rehber/asgari-ucret-isveren-maliyeti
- S5 https://www.nefes.com.tr/akaryakitta-zamli-tarife-pompaya-yansidi-kdv-indirimi-donemi-resmen-sona-erdi-154821
- S6 https://www.araclo.com/blog/moto-kurye-icin-en-dayanikli-ve-ekonomik-motosikletler-2026
- S7 https://www.ntv.com.tr/ntvpara/galeri-motokuryeler-ayda-100-bin-liranin-ustunde-kazaniyorlardi-ucretleri-yine-artti-1705489
- S8 https://www.ntv.com.tr/ntvpara/galeri-kuryeler-zammi-begenmedi-kontak-kapattilar-teslimatlar-durabilir-1707531
- S9 https://www.politikam.com/son-dakika-kuryeler-kontak-kapatti-18-20-ocak-2026-kurye-boykotu-hangi-firmalari-kapsiyor
- S10 https://www.evrensel.net/haber/594864/kuryeler-kontak-kapatti-isleyis-geregi-paket-atamiyoruz
- S11 https://haber.sol.org.tr/haber/kontak-kapatan-yemeksepeti-kuryeleri-bu-zam-degil-sefalet-ucretine-makyaj-405769
- S12 https://medyascope.tv/2026/01/17/kuryeler-uc-gunluk-kontak-kapama-eylemine-hazirlaniyor/
- S13 https://www.eleman.net/is-rehberi/maaslar-ve-ucretler/getir-kuryesi-ne-kadar-kazaniyor-2025-yeni-ucretler-h2086
- S14 https://www.eleman.net/is-rehberi/guncel/trendyol-go-kuryesi-ne-kadar-kazaniyor-2024-yeni-ucretler-h2092
- S15 https://meslekmaas.com/kurye-maaslari/
- S16 https://malipilot.com/blog/esnaf-kurye-paket-basi-ucret-2026.html
- S17 https://heryerofis.com/blog/kurye-maaslari-2026-moto-aracli-ve-trendyol-kurye-ne-kadar-kazanir-detayli-rehber
- S18 https://www.posta.com.tr/ekonomi/35-bin-lira-maasi-var-ama-calisan-bulamiyorlar-aylik-bazen-80-bin-liraya-cikiyorum-2681029 (başlık)

**Komisyon ve düzenleme**
- S19 https://varisdijital.com/blog/yemeksepeti-komisyon-oranlari-2026
- S20 https://www.siparisustasi.com/blog/yemeksepeti-komisyon-orani
- S21 https://www.siparisustasi.com/blog/komisyon-oranlari-2026
- S22 https://www.siparisustasi.com/blog/trendyol-yemek-komisyon-orani
- S23 https://www.siparisustasi.com/blog/paket-servis-pazar-raporu-2026
- S24 https://qrmenum.app/blog/yemek-sepeti-komisyon-gercek-hesap
- S25 https://www.cnbce.com/is-dunyasi/rekabet-kurumu-yemek-sepeti-icin-kurye-sorusturmasinda-gerekceli-kararini-acikladi-h25376
- S26 https://www.finansopia.com/ekonomi/rekabet-kurulu-yemek-sepetinin-taahhutlerini-kabul-ederek-sorusturmasini-sonlandirdi/
- S27 https://www.concurrences.com/en/bulletin/news-issues/may-2025/the-turkish-competition-authority-clears-an-online-delivery-platform-of-abuse
- S28 https://www.cnbce.com/haberler/ticaret-bakanligindan-yemek-siparis-platformlarina-seffaflik-duzenlemesi-h26494
- S29 https://www.bloomberght.com/yemek-siparis-platformlarina-seffaflik-duzenlemesi-3771484
- S30 https://medyascope.tv/2026/03/10/yemek-siparisinde-gizli-ucret-donemi-bitiyor/
- S31 https://www.24saatgazetesi.com/kurye-siparislerine-komisyon-duzenlemesi-tek-ekranda-gorulecek

**Pazar yapısı ve işlemler**
- S32 https://www.cliffordchance.com/news/news/2025/05/clifford-chance-advises-trendyol-on-us-700-million-sale-of-trendyol-go-to-uber.html
- S33 https://www.sec.gov/Archives/edgar/data/1543151/000154315125000023/uber-20250630.htm
- S34 https://www.intellinews.com/uber-to-pay-700mn-for-85-stake-in-turkey-delivery-unit-of-alibaba-s-trendyol-379707
- S35 https://techcrunch.com/2026/02/09/uber-to-buy-delivery-arm-of-turkeys-getir/
- S36 https://www.al-monitor.com/originals/2026/02/uber-snaps-getir-turkey-mubadala-exits-battered-delivery-bet
- S37 https://www.agbi.com/transport/2026/02/uber-to-acquire-delivery-business-of-turkeys-getir/
- S38 https://webrazzi.com/2026/06/19/rekabet-kurulu-uberin-getirin-yemek-ve-market-teslimati-islerini-devralmasina-onay-verdi/
- S39 https://www.concurrences.com/en/bulletin/news-issues/july-2026-iii/the-turkish-competition-authority-conditionally-clears-a-ride-hailing-platform
- S40 https://www.turkiyegazetesi.com.tr/ekonomi/uberin-getiri-satin-almasina-onay-turkiyeye-500-milyon-dolar-yatirim-yapacak-1797985
- S41 https://investor.uber.com/news-events/news/press-release-details/2026/Uber-Announces-Acquisition-Offer-for-Delivery-Hero/default.aspx
- S42 https://dealroom.co/news/139366-yemeksepeti-to-be-sold-to-ssw-partners-for-1-6b-as-uber-buys-delivery-he/
- S43 https://turkishminute.com/2026/07/16/turkeys-largest-food-delivery-platform-to-be-sold-in-uber-delivery-hero-deal/
- S44 https://www.ekonomim.com/kose-yazisi/uber-yemeksepetini-neden-almadi/906524
- S45 https://www.turkiyetoday.com/business/turkiyes-yemeksepeti-sold-to-ssw-partners-as-uber-acquires-delivery-hero-3224009
- S46 https://gulfnews.com/business/markets/abu-dhabis-mubadala-set-to-take-full-control-of-turkish-delivery-app-getir-1.104029811
- S47 https://www.foodbusinessmea.com/mubadala-takes-control-of-getir-with-us250m-investment/
- S48 https://www.esmmagazine.com/technology/mubadala-explores-selling-all-getir-stakes-in-turkiye-sources-say-296537
- S49 https://www.milliyet.com.tr/yemeksepeti-589-milyon-dolara-pembenar-detay-yemek-2054297/ (başlık)
- S50 https://www.ekonomigazetesi.com/ekonomi/internetten-yemekte-150-milyar-liralik-siparis-31200
- S51 https://avangardreklam.com/blog/turkiye-dijital-pazarlama-istatistikleri-2026/

**Global SaaS**
- S52 https://fareye.com/resources/blogs/onfleet-pricing
- S53 https://www.upperinc.com/blog/onfleet-pricing/
- S54 https://costbench.com/software/last-mile-delivery/onfleet/
- S55 https://shipday.com/pricing
- S56 https://www.capterra.com/p/211323/Shipday/pricing/
- S57 https://apis.io/plans/shipday/shipday-plans-pricing/
- S58 https://jungleworks.com/tookan/pricing-tookan
- S59 https://help.jungleworks.com/knowledge-base/how-does-your-pricing-work/
- S60 https://www.upperinc.com/blog/track-pod-pricing.txt
- S61 https://costbench.com/software/last-mile-delivery/detrack/
- S62 https://www.upperinc.com/blog/circuit-pricing.txt
- S63 https://www.detrack.com/blog/detrack-vs-trackpod-powerful-features-at-a-fraction-of-the-cost/

**Türkiye muadilleri**
- S64 https://adisyo.com/adisyon-programi-pos-sistemi-fiyatlari
- S65 https://kobitime.com/adisyo/
- S66 https://www.kolayrestoran.com/fiyatlar/
- S67 https://www.kolayrestoran.com/paket-servis-ozelligi/
- S68 https://simprasuite.com/restaurant-software/delivery-services-order-program/
- S69 https://kobitime.com/yemekpos/
- S70 https://kobitime.com/sepettakip/
- S71 https://webrazzi.com/2018/12/27/siparislerinizi-takip-etmenize-olanak-taniyan-girisim-hemenyolda/
- S72 https://webrazzi.com/2019/11/29/sodexosodexo-akilli-kurye-takip-yazilimi-hemen-yolda-ya-550-bin-dolar-yatirim-yapti
- S73 https://apps.apple.com/us/app/-/id1499809794
- S74 https://www.capterra.co.za/software/1107346/RestoKurye
- S75 https://apps.apple.com/ci/app/restoway/id6738424720
- S76 https://www.iletmen.com.tr/en/entegrasyonlar
- S77 https://sambapos.com/getir-integration/

**Entegrasyon**
- S78 https://developers.deliveryhero.com/documentation/pos.html
- S79 https://developers.deliveryhero.com/documentation/qc-API-integration.html
- S80 https://integration.yemeksepeti.com/
- S81 https://developer.yemeksepeti.com/en/documentation/pos-pelican-picking-how-to-integrate
- S82 https://developers.trendyol.com/v3.0/docs/8-webhook
- S83 https://developers.trendyol.com/en/
- S84 https://birfatura.com/trendyol-yemek-entegrasyonu/
- S85 https://birfatura.com/trendyol-yemek-basvuru-nasil-yapilir/
- S86 https://ecosire.com/tr/apps/odoo/getir-store-management

**Yasal / diğer**
- S87 https://webrazzi.com/2023/12/08/kuryelerle-ilgili-duzenleme-geliyor-teslimat-suresi-sinirlamasi-ortadan-kalkacak (başlık)
- S88 https://www.ekonomigazetesi.com/ekonomi/kuryeler-gonderi-icin-tasima-suresi-taahhudunde-bulunmayacak-27920
- S89 https://www.cnnturk.com/turkiye/bahsise-ve-motokuryeye-yeni-vergi-yok-2125406 (başlık)
- S90 https://assets.quicksigorta.com/qguncel/motosiklet-trafik-sigortasi-nedir-2026-kapsam-ve-zorunluluk-8801e19b
- S91 https://malipilot.com/blog/esnaf-kurye-sirket-kurulusu.html
- S92 https://www.ekonomist.com.tr/makale/paket-servise-cozum-getirdiler-5478 (başlık)
- S93 https://www.dha.com.tr/gundem/yemeksepeti-2025-siparis-ozetini-acikladi-2787626
- S98 https://www.ekonomist.com.tr/makale/online-yemek-pazarinda-rekabet-hizlandi-48619
