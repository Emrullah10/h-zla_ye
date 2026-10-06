# Hızla Tasarım Sistemi — Kaynaklı Araştırma (research-04-design)

Tarih: 2026-10-06 · Kapsam: kurye mobil uygulaması (Flutter) + işletme paneli (web/tablet) + admin/dispatch paneli (web/masaüstü)

---

## 0. Yöntem, güven düzeyleri ve sınırlar (önce bunu okuyun)

**Güven etiketleri (her bulgunun yanında):**

| Etiket | Anlamı |
|---|---|
| **[B]** | Birincil kaynak doğrudan okundu veya ölçüldü: W3C WCAG kaynak deposu, Flutter/Dart kaynak kodu, `google/fonts` içindeki gerçek font dosyaları (fontTools ile ölçüldü), CARTO/OpenFreeMap/MapLibre depoları, Uber Base Web kaynağı, Simple Icons veri dosyası (her kayıtta markanın kendi sayfası "source" olarak verilmiş). |
| **[İ]** | İkincil: arama özeti veya üçüncü taraf sayfa. Sayfanın kendisi WebFetch ile açılamadı (ağ çıkış proxy'si çoğu alan adını engelledi). Yön göstericidir; kesin değer olarak kullanmayın. |
| **[HESAP]** | Bu çalışmada hesaplandı (kontrast oranı, CIEDE2000 renk farkı, renk körlüğü simülasyonu, dp→mm). Yöntem Ek-A'da. |
| **[ÖNERİ]** | Kaynaktan çıkan sonuç değil, tasarımcı çıkarımı. Saha testiyle doğrulanmalı. |
| **[DOĞRULANMADI]** | Güvenilir kaynakla teyit edilemedi. Uydurma değer yazılmadı; aday değer varsa "aday" diye işaretlendi. |

**Sınırlar (dürüst durum):**
- Yaklaşık 50 başarılı WebSearch yapıldı; ardından oturumun paylaşılan WebSearch bütçesi (turn başına 200, tüm ajanlarla ortak) doldu. Bu yüzden bazı sorular açık kaldı (aşağıda "Açık/Doğrulanamayan" listesi, Bölüm 11).
- WebFetch yalnızca GitHub'da çalıştı (w3.org, fonts.google.com, uber.com, nngroup.com, tech.deliveryhero.com, brandpalettes.com vb. engelli). Engeli aşmaya çalışılmadı. Bunun yerine birincil veriyi GitHub'dan çektim (font ikilileri, WCAG kaynak HTML'i, Flutter kaynağı, CARTO stil değişkenleri) ve sayısal analizi kendim yaptım.
- Rakiplerin resmi marka kılavuzlarının çoğu (Yemeksepeti, Getir, Trendyol Go, Migros, Wolt) herkese açık PDF olarak bulunamadı; bu markaların HEX değerleri **[DOĞRULANMADI]** işaretlidir. Swiggy 2026 Master Brand Guidelines PDF'inin varlığı arama sonucunda görüldü fakat içerik okunamadı.

---

## 1. Yönetici özeti — en kritik 10 bulgu

1. **#FF4B2B, DoorDash kırmızısıyla fiilen aynı renk.** DoorDash `#FF3008` (Simple Icons, kaynak: doordash.com/about) ile CIEDE2000 farkı **ΔE00 = 3.8**, ton farkı 0.6° **[B+HESAP]**. Türkiye'de asıl yakın komşular Trendyol/Migros turuncusu (ΔE00 ≈ 10–11, HEX'ler doğrulanmadı) ve Yemeksepeti'nin kırmızı-pembe bandı.
2. **Cyan `#00DAF3` sektörde neredeyse boş bölge:** incelenen kırmızı/turuncu/pembe kümesine en yakın marka renginden bile ΔE00 ≈ 53 uzak; en yakın cyan/teal komşusu Deliveroo `#00CCBC` (ΔE00 = 14.3) **[HESAP]**. Kimliği "true black + cyan" üzerine kurmak, kırmızı-turuncuyu tek başına taşımaktan çok daha ayırt edici.
3. **Beyaz yazı `#FF4B2B` üzerinde 3.34:1 → WCAG AA'yı geçemiyor** (normal metin için 4.5:1 gerekir). Siyah yazı 6.29:1 **[HESAP]**.
4. **Fontlarda gizli tuzak: ₺ (U+20BA) glifi** Google Fonts sürümlerinde şu ailelerde YOK: Figtree, Geist, Outfit, Rubik, Sora, Instrument Sans, Urbanist, JetBrains Mono, Geist Mono. DM Sans ve Urbanist'te ayrıca `tnum` (tabular rakam) özelliği yok **[B: font dosyaları fontTools ile ölçüldü]**. Para ağırlıklı arayüz için Inter, Plus Jakarta Sans, Manrope, Onest, Space Grotesk, Bricolage Grotesque güvenli.
5. **Dart `toUpperCase()` dile bağımsızdır** → `'i'.toUpperCase()` = `I` (olması gereken `İ`) **[B: dart-lang/sdk string.dart]**. Türkçe büyük harf dönüşümü için özel yardımcı gerekli.
6. **CARTO Dark Matter varsayılan etiketleri dış mekân için fazla soluk:** yol etiketi `#383838` / zemin `#0e0e0e` = **1.65:1**, yer adı 3.36:1 **[B+HESAP]**. CARTO ayrıca artık **API anahtarı** istiyor (ücretsiz katman: ticari kullanımda 1M tile/ay) **[B]**.
7. **Slide-to-confirm tek başına erişilebilirlik hatası** (WCAG 2.5.7 AA: sürükleme gerektiren işlevin tek-işaretçi/tek dokunuş alternatifi olmalı) **[B]**.
8. **Dokunma hedefi:** Material 48dp, Apple 44pt **[B: Flutter sabitleri]**; saha araştırması (Parhi vd.) tekil görevlerde ~9.2–9.6 mm öneriyor **[İ]** → ≈ 58–61 dp **[HESAP]**. Eldivenli kullanım için doğrudan kaynak bulunamadı; 56–64 dp ana eylem önerisi **[ÖNERİ]**.
9. **Durum renkleri tek başına yetmez:** önerilen 6 renk ailesi renk körlüğü simülasyonunda en az 2–3 çiftte ΔE00 < 8'e düşüyor (mor/mavi: 2–3; yeşil/gül: 6; cyan/yeşil: 7) **[HESAP]** → ikon + metin zorunlu (WCAG 1.4.1 **[B]**).
10. **Endüstri deseni:** durum renkleri "gri = atanmamış, mor = atandı, mavi = yolda, yeşil = başarılı, kırmızı = başarısız, altın nokta = gecikmiş" (Onfleet) ve benzeri (Tookan) **[İ]**; gecikme bir **durum değil, bindirme (overlay)** olarak modelleniyor. Mutfak ekranlarında zaman baskısı nötr → turuncu → kırmızı ile gösteriliyor (Toast KDS) **[İ]**.

---

## 2. Rakip marka dili

### 2.1 Marka tablosu

Not: "ana renk" sütunundaki değerlerin kaynağı Simple Icons veri dosyasıdır (`data/simple-icons.json`); her kayıtta markanın kendi sayfası kaynak gösterilmiştir. Bu bir "resmi marka kılavuzu PDF'i" değildir ama kayıtlar markaya ait resmi sayfalara dayandırılmıştır **[B, orta-yüksek güven]**.

| Marka | Ana renk HEX | İkincil | Yazı tipi | Genel ton | Kaynak / güven |
|---|---|---|---|---|---|
| **Yemeksepeti** | 2021 sonrası: kırmızıdan pembeye kayan açık ton, **HEX [DOĞRULANMADI]**. Eski logo kırmızısı `#D72631` (zayıf kaynak) | Beyaz | **[DOĞRULANMADI]** (2021'de "daha yumuşak çizgili" yeni yazı) | Pazar lideri, daha yumuşak/renkli yenilenme | S38 [İ]; Delivery Hero kardeşi foodpanda `#D70F64` (S1 [B]) yakın bir referans |
| **Getir** | Mor + sarı kombinasyonu; HEX **[DOĞRULANMADI]** (bir kaynak sarı için `#FFD300` diyor, zayıf) | Sarı / mor | **[DOĞRULANMADI]** | Kurye eşofmanıyla özdeşleşmiş mor-sarı, cesur | S41 [İ düşük] |
| **Trendyol Go / Trendyol Yemek** | Turuncu; aday `#FF6A00` (logo siteleri) **[DOĞRULANMADI]** | Siyah ("trendyol" kelime işareti), "go" turuncu | **[DOĞRULANMADI]** | Küçük harfli, yuvarlak sans, enerjik | S39 [İ düşük]. Uber, Trendyol GO'nun %85'ini satın aldı (haber özetleri, ~700 M$) S45 [İ] → ileride marka değişimi olabilir (spekülasyon) |
| **Migros / Migros Yemek** | Turuncu; aday `#FF6600` (Swiss Migros'a ait olabilir) **[DOĞRULANMADI]** | — | **[DOĞRULANMADI]** | "Turuncu dev" | S40 [İ düşük] |
| **Uber Eats** | `#06C167` yeşil | Siyah `#000000` (Uber) | **Uber Move** (Display/Text/Mono ailesi; `UberMove`, `UberMoveText`, `UberMoveMono`); lisanslı değil | Sade, siyah-beyaz, fonksiyonel; "hareket halinde okunabilirlik" | S1 [B]; S2 [B: Base Web kaynağı]; S22 [İ] |
| **DoorDash** | `#FF3008` (S1); kurumsal pazarlama sayfasında `#EB1700` olarak da anılıyor [İ düşük] | — | **TT Norms Pro** (TypeType), 2018 rebrand [İ] | Cesur, kırmızı, geometrik grotesk | S1 [B]; S43 [İ] |
| **Deliveroo** | `#00CCBC` (teal) | — | **[DOĞRULANMADI]** (yeni kimlikte yazı 6° eğik/italik) | Oyuncu, kinetik; "Rooute" grafik öğesi; 2016'dan beri ilk yenilenme | S1 [B]; S35 [İ] |
| **Glovo** | Sarı `#F2CC38` (S1) — başka bir kaynak `#FFC244` diyor; çelişki | Yeşil `#00A082` [İ düşük] | **[DOĞRULANMADI]** | Sıcak, sarı-yeşil | S1 [B]; brandcolorcode (arama özeti) [İ] |
| **Wolt** | Mavi; HEX **[DOĞRULANMADI]** (yaygın anılan `#009DE0` doğrulanamadı) | Siyah, gri, beyaz | **Omnes** (yuvarlak sans) [İ] | Samimi, yuvarlak, sıcak | S42 [İ] |
| **Just Eat** | `#FF8000` | — | **[DOĞRULANMADI]** (2016'da Venturethree; italik "hareket eden marka") | Renkli, oyuncu | S1 [B]; S36 [İ] |
| **Swiggy** | `#FC8019` | — | **[DOĞRULANMADI]** (2026 Master Brand Guidelines PDF'i mevcut ama okunamadı: S48) | Turuncu, enerjik | S1 [B] |
| **Zomato** | `#E23744` | `#CB202D` (basılı hal), `#F9E5E7` (açık zemin) [İ düşük] | **Okra** (özel) [İ düşük, 3. taraf analiz] | Yüksek enerjili kırmızı, kişilik odaklı | S1 [B]; S44 [İ düşük] |
| **Grab** | `#00B14F` | — | **Grab Community Font** (özel, iç çizgili/inline; Latin, Tay, Vietnam, Burma, Khmer) | Topluluk odaklı | S1 [B]; S37 [İ] |

Ek referans renkler (çakışma analizi için): iFood `#EA1D2C`, foodpanda `#D70F64`, Postmates `#FFDF18`, Lyft `#FF00BF` **[B: S1]**.

### 2.2 Ton (hue) haritası — pazarda hangi bölge dolu?

| Ton aralığı (HSL hue) | Markalar | Doluluk |
|---|---|---|
| 335–357° (kırmızı-pembe) | Yemeksepeti (eski/yeni), foodpanda, Zomato, iFood | Yoğun |
| **~9–10° (kırmızı-turuncu)** | **DoorDash `#FF3008` (9.7°) — Hızla `#FF4B2B` (9.1°)** | **Çakışma** |
| 24–30° (turuncu) | Trendyol (aday), Migros (aday), Swiggy, Just Eat | Yoğun (TR'de kritik) |
| 40–52° (sarı) | Getir (aksan), Glovo, Postmates | Orta |
| 147–169° (yeşil/teal) | Uber Eats, Grab, Glovo (2. renk), Deliveroo (175°) | Orta |
| **186° (cyan) — Hızla aksanı** | Yok (en yakın: Deliveroo 175°, Türkiye'de yok) | **Boş** |
| ~198° (mavi) | Wolt (aday) | — |
| ~255° (mor) | Getir (aday) | TR'de dolu |

### 2.3 Hızla `#FF4B2B` için çakışma riski — hesaplanmış **[B+HESAP]**

CIEDE2000 (sRGB, D65). Yaygın mühendislik yorumu: ΔE00 < 5 pratikte "aynı renk", 5–10 yan yana bakınca fark edilir, > 10 net ayrışma **[kaynaksız genel kabul]**.

| Rakip renk | HEX | ΔE00 | Ton farkı | Risk |
|---|---|---|---|---|
| DoorDash | `#FF3008` | **3.8** | 0.6° | **Çok yüksek** (global tanınırlık; TR'de marka yok) |
| DoorDash (kurumsal alt.) | `#EB1700` [İ düşük] | 8.5 | 3.2° | Yüksek |
| iFood | `#EA1D2C` | 9.9 | 6.5° | Orta-yüksek (TR dışı) |
| Migros (aday) | `#FF6600` [DOĞRULANMADI] | 10.3 | 14.9° | Orta-yüksek (TR'de ilgili) |
| Trendyol (aday) | `#FF6A00` [DOĞRULANMADI] | 11.3 | 15.8° | Orta-yüksek (TR'de ilgili) |
| Zomato | `#E23744` | 12.1 | 13.7° | Orta |
| Yemeksepeti eski kırmızı | `#D72631` [zayıf kaynak] | 13.3 | 12.8° | Orta (TR'de en ilgili) |
| Swiggy | `#FC8019` | 16.3 | 18.1° | Düşük-orta |
| Just Eat | `#FF8000` | 17.5 | 21° | Düşük-orta |
| foodpanda / Delivery Hero | `#D70F64` | 25.4 | 25° | Düşük |
| **Cyan karşılaştırması** | | | | |
| Hızla cyan `#00DAF3` ↔ Deliveroo `#00CCBC` | | 14.3 | 11° | Orta (TR'de yok) |
| Hızla cyan ↔ Wolt (aday `#009DE0`) | | 21.0 | 12° | Düşük |
| Hızla cyan ↔ kırmızı/turuncu/pembe kümesi | | min ≈ 53 (Swiggy) | — | Çok düşük |

**Yorum ve seçenekler [ÖNERİ]:**
- Kırmızı-turuncu bandının içinde canlılığı bırakmadan "kaçacak yer" yok: 10 rakip rengin (DoorDash ×2, Zomato, iFood, Swiggy, Just Eat, Trendyol-aday, Migros-aday, Yemeksepeti-eski, foodpanda) tümüne olan minimum ΔE00, canlı adaylarda ≈ 9–11'de kalıyor (mercan `#FF5A5F` ≈ 9.4; sıcak pembe `#FF3D81` ≈ 11.4). Hue 0–30° ve siyah üstünde ≥ 6:1 kısıtıyla yapılan taramada en iyi sonuç bile soluk/somon bir ton (`#F08675`, ΔE00 ≈ 16) — yani enerjiyi feda etmeden ΔE00 > 12 elde etmek zor **[HESAP]**. Ayrışma tonla değil **sistemle** sağlanmalı: baskın yüzey = true black, baskın aksan = cyan, kırmızı-turuncu yalnızca birincil eylem/logo vurgusu, ayrıca özgün şekil/hareket dili.
- **Anlamsal çakışma:** Marka kırmızı-turuncusu (hue 9°) ile "hata/iptal" kırmızısı aynı bölgede. Birincil buton ile "İptal" butonu karışabilir. Çözüm: iptal/hata = gül/rose (`#FF5C7A`, markaya ΔE00 17.7) + X ikonu; gecikme = amber (`#FFA11A`, ΔE00 27.3) + saat ikonu (Bölüm 9).
- **Kontrast:** `#FF4B2B` siyah üstünde 6.29:1, `#0B0B0B` üstünde 5.90:1, beyaz üstünde 3.34:1 **[HESAP]**. Butonlarda **siyah metin** kullanın (6.29:1) ya da beyaz metin için koyu varyant: `#D93A1E` (beyazla 4.59:1) **[HESAP]**.
- Cyan `#00DAF3`: siyahta 12.32:1, beyazda 1.70:1 **[HESAP]** → açık temada metin/ikon olarak kullanılmamalı; açık zeminde `#0087A0` (4.50:1) veya `#00616C` (7.18:1).

---

## 3. Kurye uygulaması UX ilkeleri

### 3.1 Güneş altında okunabilirlik / kontrast
- WCAG hedefleri: AA 4.5:1 (büyük metin 3:1), AAA 7:1 (büyük metin 4.5:1) **[B: W3C understanding 1.4.3/1.4.6]**. Büyük metin = 18 pt veya 14 pt kalın **[B]**.
- WCAG'ın parlak ışığı hesaba katmadığına dair tek kaynak: NTNU yüksek lisans tezi "Effects of ambient illumination on text recognition for UI development" — W3C 7:1 eşiğinin yüksek aydınlatmada yetersiz olabileceğini, **~18:1** önerildiğini aktaran arama özeti **[İ düşük; tek tez, genelleme riskli]**.
- Hızla true black zemini beyaz metinle 21:1; ikincil metin renkleri siyah üstünde **[HESAP]**: `#FFFFFF` 21.0 · `#A1A1AA` 8.2 · `#8A8F98` 6.5 · `#6B7280` **4.3 (AA altı, kullanmayın)**. `#121212` üstünde `#6B7280` 3.9:1.
- Material koyu tema rehberi: yüzey `#121212`, %100 beyaz metinle ≥ 15.8:1; saf siyah yerine koyu gri çünkü gölge/yükselti ifade edilebilir ve parlak metin daha az göz yorar **[İ: m2.material.io/design/color/dark-theme]**. Hızla true black'i bilinçli seçiyorsa (OLED, 21:1), yüzey katmanlarını `#0B0B0B → #151515 → #1E1E1E` gibi açılan dolgular + 1 px kenarlıkla ayırmak gerekir **[ÖNERİ]**.
- **Güneşte koyu mu açık mı daha iyi?** Doğrudan kaynak bulunamadı **[DOĞRULANMADI]**. Öneri: ortam ışığına bağlı "Güneş modu" (yüksek kontrast, min. ağırlık 500, ikincil metin ≥ 7:1) ve öğle saatlerinde İstanbul/İzmir'de gerçek kurye saha testi **[ÖNERİ]**.
- Küçük/ince yazıdan kaçının: gövde ≥ 16sp, kritik sayılar (kazanç, mesafe) ≥ 24–32sp, ağırlık ≥ 500–600 **[ÖNERİ]**.

### 3.2 Dokunma hedefi, eldiven
| Kaynak | Değer |
|---|---|
| Flutter Material `kMinInteractiveDimension` | **48.0** dp **[B: flutter/lib/src/material/constants.dart]** |
| Flutter Cupertino `kMinInteractiveDimensionCupertino` | **44.0** pt (HIG'e referanslı) **[B]** |
| WCAG 2.5.8 (AA) | **24×24 CSS px** + aralık/eşdeğer/satır içi vb. 5 istisna **[B]** |
| WCAG 2.5.5 (AAA) | **44×44 CSS px** **[B]** |
| Parhi, Karlson, Bederson | Tekil görevde ~9.2 mm, ardışık görevde ~9.6 mm hata oranı düşüyor; ≥ 9.6 mm / ≥ 7.7 mm'den sonra anlamlı fark yok **[İ]** (Microsoft Research / Redalyc özetleri) |
| NN/g'nin aktardığı MIT Touch Lab | Parmak ucu genişliği 1.6–2 cm **[İ]** |
| Platform karşılaştırması (aktarılan) | Windows Phone 9 mm; Android 7 mm (48); iOS 6.5 mm (44) **[İ]** |

- dp→mm (160 dpi referansı) **[HESAP]**: 44 dp = 7.0 mm · 48 dp = 7.6 mm · 56 dp = 8.9 mm · **60 dp = 9.5 mm** · **64 dp = 10.2 mm** · 72 dp = 11.4 mm.
- **Eldivenli kullanım:** doğrudan sayısal çalışma bulunamadı (arama sonucu da bunu belirtti) **[DOĞRULANMADI]**. Parhi eşiğinin (≈ 9.5 mm ≈ 60 dp) üstüne çıkarak **ana eylemler 64 dp, ikincil 56 dp, mutlak alt sınır 48 dp; bitişik hedefler arası ≥ 8–12 dp** **[ÖNERİ]**. Cihazın "yüksek dokunma hassasiyeti/eldiven modu" ayarı cihaz-bağımlı; kuryeye onboarding'de hatırlatılabilir **[DOĞRULANMADI]**.
- Glovo kurye uygulaması yeniden tasarım vakası (portföy kaynaklı): 14 ülke, teslimat başına ortalama görev tamamlama süresi −3 sn, ~2 K€/ay verimlilik **[İ düşük; kurum onaylı kaynak değil]**. Mikro-etkileşim süresinin ölçülüp raporlanması iyi bir pratik; rakam güvenilir kaynakla desteklenmedi.

### 3.3 Tek el / başparmak bölgesi
- Hoober (UXmatters, 2013; 1.333 gözlem): tek el **%49**, kucakta/destekli **%36**, iki el **%15**; dokunmaların **%75'i başparmakla** **[İ]**. Not: 2013 verisi, telefonlar küçüktü; bugün büyük ekranlarda alt-orta bölge daha da kritik.
- **[ÖNERİ]:** birincil eylem alt kenarda tam genişlik; üst köşe için "ulaşılabilirlik" gerektiren eylem yok; sol/sağ el tercihi ayarı; alt sayfa (bottom sheet) kalıbı; harita etkileşimi için sağ-alt büyük "konumuma dön".
- Delivery Hero Rider App yeniden tasarımı (2022, Berlin): **haritayı tasarımın merkezine** koydu, "**Lasagna Architecture**" ile katmanlı arayüz (aşamalı bilgi gösterimi, bağlam değiştirmeyi azaltma); ekip sokağa çıkıp rider'larla gözlem yaptı **[İ: S20]**.
- DoorDash Dasher yeni ana ekran: **daha büyük harita**, sadeleştirilmiş yerleşim, ana ekranda **anlık kazanç** düğmesi, bölgeler arası **bekleme süresi** karşılaştırması, sık kullanılan özellikler için yan menü **[İ: S18]**.

### 3.4 Sürüş sırasında minimum etkileşim
- NHTSA yönergesi (araç içi cihazlar için gönüllü): tek bakış **≤ 2 sn**, görev için toplam gözün yoldan ayrılma süresi **≤ 12 sn** **[İ: nhtsa.gov/node/7116; 811781.pdf]**. Motosiklet/bisiklet kuryeleri için doğrudan standart yok; makul üst sınır olarak alınır **[ÖNERİ]**.
- Uber Driver tasarım ilkeleri: öğretici (instructive), müdahale etmeyen (non-intrusive), odaklı ve zamanında (focused/timely: bilgiyi en alakalı olduğunda, küçük parçalarla) **[İ: S21]**.
- **[ÖNERİ]:** hareket halinde (GPS hızı eşiğinin üstünde) metin girişi ve çok adımlı akış kilitli; sesli yönlendirme Türkçe TTS; "tek bakışta ≤ 4 bilgi öbeği"; kilit ekranı/bildirim eylemleri (kabul/red); sürüş sırasında kaydırarak onay yok, yalnızca dururken.
- Mevzuat (Türkiye'de sürüş sırasında elde telefon kullanımı kuralları) bu çalışmada doğrulanamadı **[DOĞRULANMADI]**; hukuki danışmanlık gerekir.

### 3.5 "Slide to confirm" (kaydırarak onay)
- Neden var: cepte/eldivenle yanlışlıkla dokunmayı önler; geri döndürülemez adımlar için kasıtlılık sağlar. Rakip uygulamalarda yaygın kullanım sahada gözlemlenen bir kalıp ama bu çalışmada tek tek **[DOĞRULANMADI]**.
- **Erişilebilirlik gereği:** WCAG 2.5.7 (AA, WCAG 2.2): sürükleme gerektiren işlevin sürüklemesiz tek-işaretçi alternatifi olmalı; slide-to-confirm bu kriterde bilinen yaygın hata örneği **[B: understanding/22/dragging-movements.html; İ: Sparkbox, Disability World]**. WCAG 2.5.1 (A): yol-bağımlı hareketlerin (kaydırma/fırlatma) tek-işaretçi alternatifi **[B]**.
- **[ÖNERİ] kalıp:** (a) kaydırıcı: parmak izi sağ ucun ≥ %80'ine ulaşınca onay + haptic; (b) alternatif: 1 sn **basılı tut** veya erişilebilirlik servisi açıkken düz buton; (c) Flutter'da `Semantics(onTap/customSemanticsActions)` ile ekran okuyucuya tek dokunuş eylemi; (d) yalnızca "Teslim edildi", "Siparişi iptal et" gibi geri dönüşü zor adımlarda; "Kabul et" gibi sık adımlarda tek dokunuş.

### 3.6 Sesli ve titreşimli bildirim
- Android 8.0+ kanalları: **ses ve titreşim kanal ilk oluşturulurken ayarlanır, sonradan aynı kanal id'siyle değişmez** **[B: flutter_local_notifications README]** → kanal id'lerini sürümleyin (`new_order_v1`, `order_cancelled_v1`).
- DnD'yi aşmak için özel bildirim politikası izni (`ACCESS_NOTIFICATION_POLICY`) ve `bypassDnd: true` gerekir; **cihazın sessiz modunu aşmaz** **[B]**. Tam ekran niyet (`USE_FULL_SCREEN_INTENT`) Google kısıtlarına tabidir **[B]** (kurye için sipariş teklifi uyarısında düşünülebilir; Play politikası okunmalı).
- iOS tarafında "Critical Alert" yetkisi Apple'dan özel entitlement gerektirir **[DOĞRULANMADI: Apple belgesi okunamadı]**.
- **[ÖNERİ]:** en az iki ayrı ses profili (yeni teklif / iptal-kritik); teklif geri sayımı boyunca tekrarlayan ses+titreşim; kullanıcıya onboarding'de "Rahatsız Etme" ve pil optimizasyonu istisnası yönlendirmesi; titreşim desenleri aksesibilite açısından sesin yerine geçmemeli (gürültülü ortamda ikisi birden).

### 3.7 Gece / koyu tema
- DoorDash (Mart 2021): Dasher'ların parlak ekranla düşük ışıkta alma/bırakma talimatlarını ve yön tarifini okumakta zorlandığı, bu yüzden hackathon'da Dark Mode geliştirildi **[İ: S17]**.
- Material: `#121212` yüzey, elevation overlay'leri **[İ]**; Hızla true black: OLED enerji tasarrufu + 21:1 kontrast.
- **[ÖNERİ]:** gece için gövde metni tam beyaz yerine `#F2F2F2–#E5E5E5` (parlama/halation azalır); doygun renkleri koyu zeminde %10–15 açıp doygunluğu azaltın (Bölüm 9 paleti bu mantıkla kuruldu); ışık sensörü/saat ile otomatik geçiş; elle override.

### 3.8 Çevrimdışı durum gösterimi
- Yaygın kalıp: yerel-öncelikli okuma/yazma, iyimser UI, bekleyen işlemleri kuyruğa alma, bağlanınca eşitleme; küçük, suçlamayan banner ("Çevrimdışısın. Bağlanınca eşitlenecek."), son bilinen veriyi göster, üstel geri çekilmeyle yeniden dene **[İ: Atomic Object "offline view pattern" ve benzer özetler]**.
- **[ÖNERİ] kurye için:** (1) üstte kalıcı ince şerit (turuncu değil — marka rengiyle karışmasın — amber + `cloud-off` ikonu + "Son güncelleme 14 sn önce"); (2) aktif siparişin adres/telefon/koduna çevrimdışı erişim; (3) "Teslim edildi" gibi kritik olayları cihazda kuyruğa alıp sıra numarasıyla eşitle, kullanıcıya "gönderilmedi (2)" rozeti göster; (4) konumu çevrimdışıyken kaydet ve toplu gönder; (5) çevrimdışı ≠ "Çevrimdışı (müsait değil)" durumu: iki kavramı farklı etiketle (ağ yok / müsait değil).

### 3.9 Teklif (offer) ekranı
- DoorDash: teklif ekranında tahmini kazanç, restoran adı ve alış mesafesi, yaklaşık teslim mesafesi ve **zamanlayıcı**; kabul için **~45 sn** (bazı kaynaklar 50 sn) **[İ: help.doordash.com "How to Accept an Offer"; ridesharingdriver]**.
- Kabul düğmesinde "bahşiş öncesi kazanç + restorandan teslim noktasına mesafe" göstermek sürücüye saat/₺ tahmini yaptırıyor **[İ düşük: therideshareguy]**.
- **[ÖNERİ]:** kart sırası: ₺ kazanç (en büyük) → toplam mesafe/süre → restoran adı + alış mesafesi → geri sayım halkası (renk sabit, yalnız son 10 sn amber) → [Kabul] 64 dp tam genişlik, [Reddet] ikincil metin düğmesi; reddedince ceza/etki bilgisini açık yaz (güven).

### 3.10 Kazanç ekranları
- Uber (2018 yeni Driver app): ekranın üstünde gerçek zamanlı **Earnings Tracker** (son yolculuk kazancı, hedefe ilerleme), piyasa durumu için **Status Bar**, bildirimler, profil; geliştirmede 100.000+ yolculuk ve binlerce görüşme **[İ: S21; arama özeti 2024 demişti, kaynak sayfa 2018'i gösteriyor]**.
- DoorDash: ana ekranda gerçek zamanlı kazanç düğmesi **[İ: S18]**.
- Şeffaflık yaklaşımı: günlük toplam, sipariş başına kırılım (taban, mesafe, süre, bahşiş, platform payı), haftalık örüntü, teşvik ilerlemesi, ödeme durumu aynı ekranda **[İ düşük: vp0.com özeti; Postmates Fleet vaka çalışması]**.
- **[ÖNERİ]:** sayılar `tnum` + ₺ glifi olan font (Bölüm 6); "Bugün ₺1.240,50 · 11 sipariş · ₺182/saat" üçlüsü en üstte; kırılım açılır satır; ödeme "beklemede / kullanılabilir" durumu renk + ikonla.

### 3.11 Vardiya / slot seçimi
- Skip The Dishes: kurye haftalık tercih bölgelerini haritada dokunarak seçer; **seçili bölgeler mavi, diğerleri gri** **[İ: S25]**.
- Wolt: kurye kendi çalışma saatini seçer (esnek program) **[İ düşük]**.
- **[ÖNERİ]:** haftalık 7 sütun × saat satırı ızgarası yerine "bugün/yarın" odaklı **kartlar** (dar ekran); doluluk renkle değil **dolgu miktarı + metin** ("3/8 yer kaldı"); eldivenle seçim için 64 dp slot hücreleri; bırakma/takas için geri alınabilir eylem + onay.

### 3.12 Vaka çalışması özeti (kurye uygulamaları)
| Uygulama | Gözlem | Kaynak |
|---|---|---|
| Uber Driver | Gerçek zamanlı kazanç, durum çubuğu, "sürücülerle birlikte tasarlandı", 100K+ yolculuk testi | S21 [İ] |
| DoorDash Dasher | Büyük harita ana ekran, anlık kazanç, bekleme süresi içgörüsü; karanlık mod ihtiyacı sahadan çıktı | S17, S18 [İ] |
| Delivery Hero Rider (Roadrunner) | Harita merkezli, "Lasagna" katmanlı IA, saha gözlemi | S20 [İ] |
| Deliveroo Rider | Müşteri doğrulama kodları, istif (stacked) sipariş güncellemeleri (destek sayfaları); tasarım blogu bulunamadı | rider.deliveroo.com [İ] |
| Glovo Couriers | Çok teslimatlı iş akışı sadeleştirme (portföy vaka) | S23 [İ düşük] |
| Wolt Partner | Helsinki'de kullanılabilirlik değerlendirmesi: uygulama "kolay, tutarlı, kullanıcı dostu" bulundu (Theseus tezi) | S24 [İ] |

---

## 4. İşletme / restoran paneli UX (tablet ağırlıklı)

**Rakip uygulamaların yaptıkları**

| Sistem | Davranış | Kaynak |
|---|---|---|
| Uber Eats Orders | Yeni siparişte tablet **yeşil yanıp söner + ses çalar**; ekranda herhangi bir yere dokununca detay; kabul → sipariş fiş ikonundan **tava (hazırlık) ikonuna**, "hazır" → **poşet ikonuna** geçer; "sesi açın" uyarısı | S26 [İ] |
| DoorDash Tablet | Yeni sipariş uyarı sesi **Yüksek/Sessiz**; sipariş **hazırlık süresi (dk)** ayarlanıp "Confirm" ile kabul; kabul edilmezse **"Needs Action"** sekmesinde bekler; **otomatik onay** seçeneği; kurye atanmadan hazırlık süresi değiştirilebilir; planlı siparişler pickup − hazırlık süresinde "Active"e düşer | S27 [İ] |
| Deliverect | Durum sözlüğü: Accepted → Preparing → Prepared → Pickup ready → In delivery → Finalized; KDS durum kodları 50/60/70/80 | S28 [İ] |
| Toast KDS (mutfak ekranı) | Bilet zamanlayıcısı: **dikkat süresinde turuncu, gecikmede kırmızı**; sipariş tipine göre renkli kenarlık; uzaktaki ekranlar için Büyük/Çok Büyük yazı boyutu; renkli arka planda metin siyah | S29 [İ] |
| GetirYemek | "Getir getirsin" / "Restoran getirsin" teslimat seçenekleri | S47 [İ] |
| Yemeksepeti panel (şikâyetler) | Restoran panelinin kendiliğinden kapanması, sipariş ve müşteri kaybı şikâyeti | S46 [İ] |

**Hızla için tasarım çıkarımları [ÖNERİ]**
1. **Üç sütunlu Kanban (yatay tablet):** Yeni | Hazırlanıyor | Hazır/Kurye bekleniyor. Sipariş no mono fontla büyük (`K-4821`), kurye ETA'sı kartın en sağında büyük ("Kurye 3 dk").
2. **Yeni sipariş = çok kanallı uyarı:** tam ekran/üst bant görsel + yüksek ses + (Android'de) kanal önemi yüksek; **onaylanana dek tekrarlar**. Kalıcı "Ses kapalı" şeridi (Uber Eats'in "sesi açın" uyarısından esinli) ve "sesi test et" düğmesi.
3. **Tek dokunuşla kabul** (kaydırma yok; eller yağlı/ıslak olabilir; kabulde slide-to-confirm gereksiz). **Ret** iki adımlı (neden seç + onay).
4. **Hazırlık süresi stepper'ı** (−/+ 5 dk, varsayılan restoran ortalaması); kurye atandıktan sonra süre değiştirme kuralı DoorDash gibi net gösterilmeli.
5. **Renk kodu:** yaşam döngüsü renkleri Bölüm 9; **zamanlayıcı** nötr → amber → gül/kırmızı; bilet kenarlığı **teslimat tipi** (platform kuryesi / restoran kuryesi / gel-al) için ayrı kanal (Toast'un on-premise/off-premise kenarlığı gibi).
6. **Okunabilirlik:** tablet masada 50–80 cm; gövde ≥ 18sp, sipariş no/ürün satırı ≥ 24–28sp, ürün miktarı ("2×") çok büyük; hedefler ≥ 64 dp; parlak mutfak ışığı için yüksek kontrast açık tema + isteğe bağlı koyu tema.
7. **Güven:** "Açık/Kapalı" durumu sürekli görünür, kendiliğinden değişirse sebep + zaman damgası ("15:42'de 'meşgul' nedeniyle otomatik kapandı"); çevrimdışı şeridi.
8. **Mutfak gürültüsü / ses düzeyi** için sayısal kaynak bulunamadı **[DOĞRULANMADI]**; sesi cihaz ses seviyesinden bağımsız tutamazsınız, bu yüzden "ses kontrolü" kurulum sihirbazının parçası olmalı.

---

## 5. Admin / dispatch paneli UX (masaüstü)

**Rakip dashboard kalıpları**

| Ürün | Gözlem | Kaynak |
|---|---|---|
| Onfleet | İki ana bileşen: **harita + kenar çubuğu**; atanmamış görevler listenin üstünde, atananlar sürücünün altında; harita pinleri durum renginde; **pin kümeleme**, tablo görünümü, komuta merkezi | S30 [İ] |
| Tookan | Görev durumları solda görev çubuğunda ve haritada pin; ajan durumları nokta olarak (yeşil boşta, açık mavi yolda, gri çevrimdışı) | S31 [İ] |
| Bringg | **Birleşik harita + liste**; **uyarılar önem kademeli** (ör. teslimata 30 dk gecikmede düşük, daha da geciktikçe yüksek); "exception ile yönet"; rota izleyici (KPI + zaman çizelgesi) | S32 [İ] |
| Shipday | Sürücü, sipariş durumu ve konumlar tek ekranda; iki tıkla manuel atama veya otomatik atama | S33 [İ] |
| Kontrol odası HMI (ISA-101/18.2) | Yüksek performanslı HMI: doygun parlak renkler yalnızca anormal durum için; tek bakışta büyük resim → ayrıntı hiyerarşisi; alarm sel azaltma (satıcı iddiası: %85'e kadar) | S34 [İ; satıcı iddiası] |

**Hızla için çıkarımlar [ÖNERİ]**
1. **Üç bölmeli yerleşim:** sol liste (sekme: Atanmamış / Aktif / Sorunlu / Kuryeler), orta harita, sağ ayrıntı çekmecesi; harita ↔ liste çift yönlü vurgulama (satıra gel → pin parlar).
2. **Veri yoğunluğu:** Uber Base Web ölçeği referans: gövde 12/14/16 px, satır yüksekliği 20/20/24 px, orta ağırlık 500, başlıklar 700 **[B: S2]**. Tablo satırı 32–40 px; sayısal sütunlar sağa hizalı + `tnum`.
3. **"Exception ile yönetim":** varsayılan görünüm yalnız **sorunlu** siparişleri öne çıkarır; normal akış nötr gri. Doygun renk = alarm. (ISA-101 mantığı.)
4. **Alarm kademeleri (P1/P2/P3)** — örnek varsayılanlar saha verisiyle kalibre edilmeli **[ÖNERİ]**: P3 bilgi (rozet), P2 uyarı (amber çerçeve + liste başı), P1 kritik (gül/kırmızı + sesli + modal olmayan üst şerit). Her alarm: sahip, kabul (ack), erteleme, otomatik kapanma.
5. **Gerçek zamanlı güncelleme:** pin hareketini 3–5 sn'lik konum güncellemeleri arasında enterpole et (konum yayını aralığına dair veri düşük güvenli bir mühendislik özetinden: 3–5 sn **[İ düşük]**); "Son güncelleme N sn önce" tazelik rozeti; bağlantı kesilince şerit; kullanıcı kaydırırken liste otomatik yenilemesini duraklat; değişen satırı 1.5 sn hafifçe vurgula (azaltılmış hareket tercihine saygı).
6. **Erişilebilirlik (web):** WCAG 2.4.11 Focus Not Obscured (sabit başlık/çekmece odaklanan öğeyi tamamen örtmemeli) **[B]**; klavye kısayolları (atama, ack, harita odak); 320 CSS px reflow gereği masaüstü paneli için zorunlu değil ama tablet kullanımında önemli **[B: 1.4.10]**.

---

## 6. Tipografi

### 6.1 Ölçülen teknik karşılaştırma **[B: google/fonts ana dal font dosyaları, fontTools 4.66.1 ile ölçüldü]**

Türkçe testi: ğ Ğ ş Ş ı İ ç Ç ö Ö ü Ü — **17 fontun tamamı eksiksiz** (cmap kontrolü). `tnum` testi: GSUB özelliği var mı + `tnum` uygulanınca 0–9 ilerleme genişlikleri eşit mi. x-yüksekliği/büyük harf yüksekliği: `x` ve `H` glif sınırlarından ölçüldü (em oranı).

| Font | Ağırlık aralığı (GF) | Variable / ek eksenler | ₺ (U+20BA) | `tnum` | Diğer özellikler | x-yük. / cap (em) | tnum rakam genişliği (em) | Variable TTF boyutu | `google_fonts` paketinde statik ağırlıklar |
|---|---|---|---|---|---|---|---|---|---|
| **Inter** | 100–900 | Evet: `opsz` 14–32 | ✔ | ✔ | `zero` (kesikli sıfır), `case`, ss01–08, cv01–14 | 0.546 / 0.728 | 0.648 | 857 KB | 100–900 + italik |
| **Plus Jakarta Sans** | 200–800 | Evet: `wght` | ✔ | ✔ | TRK `locl`, ss01–03, `case` | 0.536 / 0.745 | 0.600 | 172 KB | 200–800 + italik |
| **Manrope** | 200–800 | Evet: `wght` | ✔ | ✔ | TRK `locl`, `case` | 0.540 / 0.720 | 0.620 | 161 KB | 200–800 (italik yok) |
| **Figtree** | 300–900 | Evet: `wght` | ✘ | ✔ | TRK `locl`, ss01–02 | 0.500 / 0.700 | 0.620 | 61 KB | 300–900 + italik |
| **Geist** | 100–900 | Evet: `wght` | ✘ | ✔ | TRK `locl`, ss01–11 | 0.530 / 0.710 | 0.600 | 165 KB | 100–900 + italik |
| **DM Sans** | 100–1000 | Evet: `opsz` 9–40 | ✔ | **✘ (yok)** | ss01–08 | 0.526 / 0.700 | — (tnum yok) | 235 KB | 100–900 + italik |
| **Outfit** | 100–900 | Evet: `wght` | ✘ | ✔ | ss01 | **0.460** / 0.676 | 0.590 | 108 KB | 100–900 (italik yok) |
| **Rubik** | 300–900 | Evet: `wght` | ✘ | ✔ | `zero` | 0.520 / 0.700 | 0.600 | 351 KB | 300–900 + italik |
| **Sora** | 100–800 | Evet: `wght` | ✘ | ✔ (pnum yok) | TRK `locl`, ss01 | 0.534 / 0.730 | **0.676 (geniş)** | 109 KB | 100–800 |
| **Space Grotesk** | 300–700 | Evet: `wght` | ✔ | ✔ | `lnum`, `zero`, ss01–05, TRK `locl` | 0.486 / 0.700 | 0.620 | 133 KB | 300–700 |
| **Onest** | 100–900 | Evet: `wght` | ✔ | ✔ | TRK `locl`, ss01–02 | 0.527 / 0.707 | **0.672 (geniş)** | 189 KB | 100–900 |
| **Instrument Sans** | 400–700 | Evet: `wdth` 75–100, `wght` | ✘ | ✔ | ss01–12, TRK `locl` | 0.510 / 0.720 | 0.600 | 190 KB | 400–700 |
| **Bricolage Grotesque** | 200–800 | Evet: `opsz` 12–96, `wdth` 75–100, `wght` (varsayılan opsz = 96) | ✔ | ✔ | `lnum`, TRK `locl` | 0.528 / **0.660** | 0.580 | 399 KB | 200–800 |
| **Urbanist** | 100–900 | Evet: `wght` | ✘ | **✘ (yok)** | — | 0.501 / 0.700 | — | 83 KB | 100–900 + italik |
| *Mono* **JetBrains Mono** | 100–800 | Evet: `wght` | ✘ | (mono: zaten sabit) | `zero`, TRK `locl` | 0.550 / 0.730 | 0.600 | 183 KB | 100–800 + italik |
| *Mono* **Geist Mono** | 100–900 | Evet: `wght` | ✘ | (mono) | ss01–11 (ss05 hariç) | 0.530 / 0.710 | 0.600 | 168 KB | 100–900 + italik |
| *Mono* **IBM Plex Mono** | 100–700 (statik dosyalar) | Hayır (statik) | ✔ | (mono) | `zero`, ss01–05 | 0.516 / 0.698 | 0.600 | 132 KB (Regular) | 100–700 + italik |

Notlar:
- Hepsi **SIL OFL** lisanslı (METADATA `license: "OFL"`) **[B]**. Geist ve Geist Mono GF'ye 2024-10 eklendi.
- Varsayılan rakamlar hiçbir sans fontta tabular **değil**: `tnum` açıkça açılmalı. Flutter: `FontFeature.tabularFigures()` = `tnum` **[B: dart:ui text.dart]**.
- Örnek: Inter varsayılan "1" ilerlemesi 0.407 em civarı, `tnum` ile tüm rakamlar 0.648 em (ölçümden: ilerleme setleri 833–1267 birim → `tnum` sonrası tek değer).
- `google_fonts` paketi `fontFeatures` parametresi sunar (tnum çalışır), ancak `fontVariations` parametresi **yok**; yani `opsz/wdth` eksenlerini kullanmak için font dosyasını **assets'e kendiniz bundle edip** `TextStyle.fontVariations` ile eksen vermelisiniz **[B: google_fonts part_i.dart imzası; text_style.dart]**. Bricolage Grotesque'in `opsz` varsayılanı 96 (display) olduğundan küçük metinde statik varsayılan örnek uygun olmayabilir **[ÖNERİ: bundle + `FontVariation('opsz', 14)`]**.
- `google_fonts` çalışma zamanında HTTP ile çeker; varlıklarda eşleşen dosya varsa onu önceliklendirir ("çevrimdışı öncelikli uygulamalar için") **[B]** → kurye uygulamasında **fontları bundle edin** (çevrimdışı, ilk açılış titremesi yok).
- Statik örneklerin ₺ kapsamı dosyadan dosyaya aynı kaynaktan türer; üretimde bundle ettiğiniz dosyada tekrar doğrulayın **[ÖNERİ]**.

### 6.2 Karakter ve küçük boyutta okunabilirlik (tasarımcı yorumu **[ÖNERİ]**, ölçülen x-yüksekliği ile desteklenir)

| Font | Kişilik | Küçük boyut | Para/rakam UI | Hızla için |
|---|---|---|---|---|
| Inter | Nötr, fonksiyonel, "varsayılan UI" | Çok iyi (yüksek x-yük., opsz 14) | Çok iyi: tnum + kesikli sıfır + ₺ | **Birincil UI/metin/rakam** |
| Plus Jakarta Sans | Sıcak geometrik, modern, hafif dar ritim | İyi | İyi (tnum, ₺) | **Başlık/ekran sayıları (display)** |
| Manrope | Yarı-geometrik, teknik, net rakamlar | İyi | İyi (tnum, ₺) | Alternatif UI |
| Onest | Nötr grotesk (Inter benzeri) | İyi | Rakamlar geniş (0.672 em) → tablo yoğunluğu düşer | Alternatif |
| Space Grotesk | Teknik/fintech, kişilikli | Zayıf-orta (x-yük. 0.486) | Büyük sayı (KPI) için güçlü: `lnum`, `zero`, ₺ | Yalnız büyük rakam vurgusu |
| Bricolage Grotesque | İfadeli, karakterli (display) | Küçükte `opsz` ayarı gerekir | tnum ✔ ₺ ✔ | Marka başlıkları (opsiyonel) |
| Geist | İsviçre/teknik, minimal | İyi | ₺ yok → **elenir** | — |
| Figtree | Arkadaşça, yuvarlak | Orta (x-yük. 0.50) | ₺ yok → **elenir** | — |
| Rubik / Sora / Outfit / Instrument Sans | Karakterli ama ₺ yok | — | **elenir** (fallback glif uyumsuz kalır) | — |
| DM Sans | Geometrik, düşük kontrast | İyi | **tnum yok** → para tablosunda kullanılmaz | — |
| Urbanist | İnce geometrik display | Küçükte zayıf | tnum+₺ yok → **elenir** | — |

**Para/rakam ağırlıklı UI önerisi [ÖNERİ]:**
- **Birincil:** Inter (400/500/600/700) — `tnum` her zaman açık (kazanç, ETA, geri sayım, tablo), sipariş kodu dışındaki sayılarda `zero` kapalı.
- **Display / hero rakamlar:** Plus Jakarta Sans 700–800 (₺ + tnum ✔).
- **Mono (sipariş/teslimat kodu, ID):** **IBM Plex Mono** (₺ ✔, Türkçe ✔, kesikli sıfır `zero` ✔, OFL). JetBrains Mono ve Geist Mono yalnızca ₺ glifine gerek yoksa uygundur (kodlarda genelde gerekmez).
- Bütçe: bundle ederken ailede en çok 3–4 ağırlık (örn. 400/500/600/700) tutun; Inter variable tek dosya 857 KB, statik alt kümeler çok daha küçük.

### 6.3 Türkçe'ye özgü uyarılar
- **Büyük/küçük harf:** Dart `toUpperCase()/toLowerCase()` "dilden bağımsız Unicode eşlemesi" kullanır **[B]** → `i→I`, `I→i` olur (olması gereken `i→İ`, `I→ı`). Yardımcı fonksiyon yazın: büyütmeden önce `i→İ`, `ı→I`; küçültmeden önce `I→ı`, `İ→i`. Web panellerinde `lang="tr"` + CSS `text-transform` kullanın **[bilgi; kaynak eklenmedi]**.
- **Para biçimi:** `₺1.234,50` (nokta binlik, virgül ondalık) — Flutter `intl` `NumberFormat.currency(locale: 'tr_TR', symbol: '₺')` **[bilgi, bu çalışmada test edilmedi]**; sembol önde/sonda tercihi marka kararı.
- **Büyük harf etiketleri:** "TESLİM EDİLDİ", "İPTAL", "ÇEVRİMİÇİ" gibi uzun büyük harf etiketlerde İ noktası ve Ğ/Ş/Ç aksan yüksekliği satır yüksekliğini taşırabilir; cap-height'ı düşük fontlarda (Bricolage 0.660) büyük harf etiketler küçük görünür → satır yüksekliği ≥ 1.25.

---

## 7. Erişilebilirlik eşikleri

### 7.1 WCAG 2.2 **[B: w3c/wcag `understanding/` ve `guidelines/sc/` kaynak dosyaları]**

| Kriter | Seviye | Eşik / gereklilik | Hızla'ya yansıması |
|---|---|---|---|
| 1.4.3 Contrast (Minimum) | AA | Normal metin **4.5:1**, büyük metin (≥18 pt veya ≥14 pt kalın) **3:1**; yuvarlama yok (4.499 geçmez) | İkincil metin altı sınırı |
| 1.4.6 Contrast (Enhanced) | AAA | **7:1**, büyük **4.5:1** | Kurye uygulaması varsayılan hedef |
| 1.4.11 Non-text Contrast | AA | UI bileşenleri ve anlamlı grafikler **3:1** (etkin olmayan hariç) | İkon, kenarlık, harita pini |
| 1.4.1 Use of Color | A | Bilgi yalnızca renkle iletilmez; şekil/metin eşlik eder | Tüm durum rozetleri |
| 1.4.4 Resize Text | AA | **%200**'e kadar metin büyütme, işlev kaybı yok | Flutter textScaler testi |
| 1.4.10 Reflow | AA | **320 CSS px** genişlikte yatay kaydırmasız | Web paneli tablet dikey |
| 1.4.12 Text Spacing | AA | Satır yüksekliği ≥ 1.5×, paragraf sonrası ≥ 2×, harf aralığı ≥ 0.12×, kelime aralığı ≥ 0.16× yazı boyutu uygulanınca içerik kaybı yok | Web panel, sabit yükseklikli bileşenlerden kaçın |
| 2.5.8 Target Size (Minimum) | AA | **24×24 CSS px**; istisnalar: aralık (24 px'lik daireler kesişmemeli), eşdeğer, satır içi, kullanıcı aracısı, zorunlu | Web paneli alt sınır |
| 2.5.5 Target Size (Enhanced) | AAA | **44×44 CSS px** | Web panelde birincil eylemler |
| 2.5.7 Dragging Movements | AA | Sürükleme ile yapılan işlevin tek-işaretçi alternatifi | Slide-to-confirm, kanban sürükle-bırak |
| 2.5.1 Pointer Gestures | A | Yol-bağımlı hareketlere tek-işaretçi alternatifi | Harita jestleri, kaydırarak silme |
| 2.3.3 Animation from Interactions | AAA | Etkileşimle tetiklenen gereksiz animasyon kapatılabilir | Pulse/çan animasyonları |
| 2.4.11 Focus Not Obscured (Minimum) | AA | Odaklanan öğe sabit öğeler tarafından tamamen gizlenmez | Dispatch sabit başlık/çekmece |

### 7.2 Mobil (Flutter) **[B: flutter/flutter kaynak]**
- Hedef boyut: Material 48.0, Cupertino 44.0 (yukarıda). Hızla kurye uygulamasında iç hedef 56–64 dp **[ÖNERİ]**.
- **Metin ölçekleme:** `MediaQueryData.textScaler`; `MediaQuery.withClampedTextScaling(minScaleFactor, maxScaleFactor, child)` ölçek aralığını sınırlar ("aşırı ölçekleme arayüzü bozmasın diye") **[B]**. WCAG 1.4.4'ün %200 beklentisi nedeniyle genel uygulamayı kırpmayın; yalnızca harita bindirmeleri/çip gibi yoğun bileşenlerde sınırlayın (örn. max 1.3–1.5) ve onları kaydıran/sarılan yerleşimle tasarlayın **[ÖNERİ]**. İkonların ölçeklenmemesi için `withNoTextScaling` **[B]**. iOS Dynamic Type erişilebilirlik boyutlarında ölçek ~3×'e çıkabilir **[DOĞRULANMADI]**.
- **Hareket azaltma — iki ayrı bayrak:** `disableAnimations` Android "Animasyonları kaldır" ayarına karşılık gelir ve `AnimationController`'ı etkiler; **iOS "Reduce Motion" farklıdır**: `reduceMotion` bayrağı çerçeve animasyonlarını **otomatik değiştirmez**, widget'ların kaydırma/kayma yerine çapraz solma (cross-fade) kullanması beklenir **[B: media_query.dart master dalı; sürüm bağımlı, kullandığınız stable sürümde mevcudiyetini doğrulayın]**.
- Diğer: `highContrast` (iOS 13+ / Android API 34+ güncellenir) ve `boldText` bayrakları → yüksek kontrast tema ve kalın yazı varyantı **[B]**.
- Ekran okuyucu: kurye uygulamasında kritik eylemler için `Semantics` etiketi + kaydırma yerine tek dokunuş eşdeğeri.

### 7.3 Hızla iç hedefleri (WCAG üstü, dış mekân/mutfak için) **[ÖNERİ]**
| Öğe | Hedef |
|---|---|
| Kurye uygulaması gövde ve kritik metin | ≥ **7:1** (AAA); gün ışığı modunda ≥ 10:1 hedef |
| İkincil metin | ≥ 4.5:1 mutlak alt sınır (siyah üstünde `#A1A1AA` 8.2, `#8A8F98` 6.5; `#6B7280` kullanma) |
| İkon/kenarlık/harita pini | ≥ 4.5:1 (WCAG'ın 3:1'i dış mekân için riskli) |
| Ana eylem dokunma hedefi | 64 dp (mutlak alt sınır 48) |
| Durum bildirimi | Renk + ikon + metin üçü birlikte |
| Metin ölçeği | 200%'de ana akışlar kullanılabilir (test matrisi: 1.0 / 1.3 / 2.0) |

---

## 8. Harita stilleri

### 8.1 CARTO taban haritaları **[B: CartoDB/basemap-styles README ve `mapboxgl/*_vars.json`]**
- **Voyager:** renkli harita, CARTO Builder'ın varsayılanı. **Positron:** açık gri, nokta verisi için iyi. **Dark Matter:** koyu gri, çokgen/çizgi verisi için iyi. Hepsi "**yumuşak**" tasarlanmış; "arka plan olarak kullanılmak üzere, tek başına Google/HERE gibi bir harita olması amaçlanmamış" **[B]**.
- Veri: OpenMapTiles şeması **[B]**. Vektör stiller yeni uygulamalar için raster'a tercih ediliyor (daha keskin, çalışma zamanında yeniden stillenebilir) **[B]**.
- **Lisans/erişim değişikliği:** CARTO taban haritaları artık **API anahtarı gerektiriyor** (anahtarsız istekler "API key required" filigranıyla geliyor); anahtarlar ticari olmayan kullanımda 5M tile/ay'a, **ticari kullanımda 1M tile/ay'a kadar ücretsiz**, üstü ücretli plan **[B: README (master)]**. Kaba bir senaryo: 1.000 kurye × 20 oturum/gün × 30 gün × 15 tile ≈ **9M tile/ay** (varsayımlar kurgusal) → ticari ölçekte ücretsiz kota hızla aşılır **[HESAP, varsayımsal]**.

### 8.2 Stok stillerin okunabilirliği — hesaplanmış kontrastlar **[B+HESAP]** (stil değişkenleri CARTO deposundan)
| Stil | Zemin (landmass) | Su | Yol etiketi | Yer adı | Su etiketi | Su ↔ kara (non-text) |
|---|---|---|---|---|---|---|
| Dark Matter | `#0e0e0e` | `#212121` | `#383838` → **1.65:1** | `#666` → 3.36:1 | `#444` → 1.65:1 | 1.20:1 |
| Positron | `#fafaf8` | `#d4dadc` | `#757575` → 4.41:1 | `#697b89` → 4.19:1 | `#7a96a0` → 2.22:1 | 1.35:1 |
| Voyager | `#fbf8f3` | `#b0d0d6` | `#6a7584` → 4.41:1 | `#405c78` → 6.56:1 | `#51909c` → 2.21:1 | 1.54:1 |

Çıkarım: **stok Dark Matter dış mekân/kurye kullanımı için çok soluk** (yol etiketi 1.65:1); Positron/Voyager yol etiketleri AA'nın hemen altında (4.41). Bu stiller "veri katmanının altında soluk zemin" olarak tasarlanmış; kurye için harita **birincil bilgi** olduğundan özel stil şart.

Rota/pin renkleri **[HESAP]**: cyan `#00DAF3` Dark Matter zemininde **11.33:1**; açık zeminde (Positron) **1.63:1** → açık haritada rota için `#0087A0` (4.04:1) + beyaz kenar (casing) ya da koyu mavi; marka `#FF4B2B` pin'i koyu zeminde 5.79:1, açık zeminde 3.19:1.

### 8.3 Alternatif altyapı (anahtar/kota/maliyet) **[B]**
- **MapLibre GL (Flutter `maplibre_gl`)**: Android, iOS, Web; "satıcıdan bağımsız, hesap/API anahtarı gerekmeden başlanır"; kümeleme, ısı haritası, veri güdümlü stil, 3B bina **[B: maplibre/flutter-maplibre-gl README]**.
- **OpenFreeMap**: halka açık örnek **ücretsiz**, istek/harita görüntüleme sınırı yok, kayıt/anahtar/çerez yok; stiller: Bright, Liberty, Positron, Dark, Fiord; **atıf zorunlu**; arama/geokodlama/rota/uydu/raster sağlamaz; bağış destekli, SLA taahhüdü belirtilmemiş **[B]** → üretimde kendi barındırma veya ticari sağlayıcı planı düşünün.
- **Protomaps basemaps**: PMTiles + çoklu renk temalı MapLibre stilleri, kendiniz barındırabilirsiniz **[B]**.
- Mapbox/Google Maps fiyat ve şartları bu çalışmada doğrulanmadı **[DOĞRULANMADI]**.

### 8.4 Kurye haritası okunabilirlik ilkeleri **[ÖNERİ]**
1. Özel MapLibre stili: Dark Matter/Positron türevi; yol/yer etiketlerini **≥ 7:1**, halo 2 px; POI yoğunluğunu azalt; bina ve park gürültüsünü kıs.
2. Birincil bilgi = rota + durak pinleri; harita ikincil zemin. Rota çizgisi kalın (6–8 dp), koyu zeminde cyan, açık zeminde koyu cyan/mavi + casing.
3. Pin: **şekil + numara** ("A restoran = kare, B müşteri = daire") + renk; yalnız renk değil.
4. Kurye konumu: dönen yön oku; hareket yumuşatma; GPS kaybında soluk + "konum eski" etiketi.
5. Gün/gece: harita teması uygulama temasına bağlı ama kontrast hedefi aynı.
6. DoorDash/DH örneklerinde harita ana ekranın büyük kısmını kaplıyor (S18, S20) → alt sayfa (bottom sheet) üç yükseklik: kapalı/yarım/tam.

---

## 9. Durum renk semantiği

### 9.1 Endüstri pratiği **[İ]**
| Ürün | Sipariş/görev durumu | Sürücü/ajan durumu |
|---|---|---|
| **Onfleet** | Atanmamış **gri** · Atandı **mor** · Yolda (aktif) **mavi** · Başarılı **yeşil** · Başarısız **kırmızı** · **Gecikmiş = ikonun sağ üstünde küçük altın nokta** (yani durum değil bindirme) | Ayrı "driver status" makalesi mevcut (içerik okunamadı) |
| **Tookan** | Atanmamış gri · Atandı turuncu · Kabul/Onay mor · Başladı açık mavi · Devam ediyor koyu mavi · Başarılı yeşil · Başarısız/İptal kırmızı | Boşta (görevde değil) **yeşil nokta** · Yolda **açık mavi** · Çevrimdışı **gri** |
| **Toast KDS** | Bilet zamanlayıcı: normal → **turuncu (dikkat)** → **kırmızı (geç)**; tamamlanan bilet yeşil arka plan | — |
| **Uber Eats Orders** | Yeni siparişte tablet **yeşil yanıp söner**; hazırlık/teslim durumu **ikonla** (fiş → tava → poşet) | — |
| **Bringg** | Uyarılar **önem kademeli** (düşük/yüksek) | — |
| **Deliverect** | Durum adı + kod sözlüğü (renk önerisi yok) | — |

Dersler: (1) **Yeşil evrensel değil:** Uber Eats'te "yeni sipariş", Toast/Onfleet'te "tamamlandı" → bir sistemde tek anlamda tutun. (2) **Gecikme bir durum değil, bir bindirmedir** (Onfleet altın noktası; Toast zamanlayıcı rengi). (3) Yürüyen aşamalar (yolda, devam ediyor) mavi ailesinde; farklar ikon/ilerlemeyle verilir. (4) Gri = "henüz kimse sahiplenmedi/bekliyor".

### 9.2 Hızla için önerilen palet **[ÖNERİ + HESAP]**

Tasarım kuralları: (a) marka kırmızı-turuncusu (`#FF4B2B`) hiçbir durum için kullanılmaz; (b) **6 renk ailesi** (daha fazlası ayırt edilemiyor); (c) aşamalar arası fark ikon + ilerleme çubuğu ile; (d) gecikme = bindirme; (e) her rozet = **renk + ikon + metin**.

| Durum | Renk ailesi | Koyu tema ön plan | Siyah/`#121212` üstü kontrast | Açık tema metin (AA ≥ 4.5:1 / AAA ≥ 7:1) | İkon önerisi (şekil) | Notlar |
|---|---|---|---|---|---|---|
| **Yeni** | Cyan (marka aksanı) | `#00DAF3` | 12.3 / 11.0 | `#008392` (4.50) / `#00616C` (7.18) | çan, dolu rozet, nabız (reduce-motion'da sabit) | Dikkat gerektirir; restoranda onay bekler |
| **Hazırlanıyor** | Mor | `#A78BFA` | 7.7 / 6.9 | `#7E55F8` (4.62) / `#5722F5` (7.11) | tencere/tava | Mutfakta |
| **Hazır (kurye bekleniyor)** | Yeşil, **çerçeve (outline)** stili | `#2ED47A` | 10.8 / 9.6 | `#1B864C` (4.60) / `#15663A` (7.02) | poşet + onay | "Tamamlandı" ile aynı aile, farklı dolgu |
| **Kurye restorana yolda** | Mavi | `#4DA3FF` | 8.0 / 7.1 | `#0072EB` (4.56) / `#0056B3` (7.04) | kurye → dükkân, ilerleme 1/3 | Üç hareket durumu **aynı renk**; ayrım ikon + 3 parçalı ilerleme çubuğu |
| **Teslim alındı** | Mavi | `#4DA3FF` | 8.0 / 7.1 | aynı | poşet taşıyan kurye, 2/3 | |
| **Yolda** | Mavi | `#4DA3FF` | 8.0 / 7.1 | aynı | rota/motosiklet, 3/3 | |
| **Teslim edildi** | Yeşil, **dolu** | `#2ED47A` | 10.8 / 9.6 | `#1B864C` / `#15663A` | onay işareti (dolu daire) | |
| **İptal** | Gül/rose | `#FF5C7A` | 7.1 / 6.3 | `#ED002C` (4.53) / `#B50021` (7.03) | X (kare/daire içinde) | Marka rengine ΔE00 = 17.7 |
| **Gecikmeli (bindirme)** | Amber | `#FFA11A` | 10.4 / 9.2 | `#AB6500` (4.57) / `#804B00` (7.18) | saat + "+N dk" | Başka durumun üstüne rozet; marka rengine ΔE00 = 27.3 |

SLA zamanlayıcısı (restoran ve dispatch): normal nötr → uyarı eşiğinde amber → geç eşiğinde gül/kırmızı **[İ: Toast kalıbı]**; eşikler restoran/ürün başına ayarlanabilir.

**Kurye durumu**
| Durum | Renk | Koyu tema | Kontrast (siyah) | Açık tema metin AA | Şekil/ikon |
|---|---|---|---|---|---|
| **Çevrimiçi** | Yeşil | `#2ED47A` | 10.8 | `#1B864C` | dolu daire |
| **Molada** | Amber | `#FFA11A` | 10.4 | `#AB6500` | duraklat (iki çubuk) |
| **Siparişte** | Mavi | `#4DA3FF` | 8.0 | `#0072EB` | poşet/rota |
| **Çevrimdışı** | Gri | `#8A8F98` | 6.5 | `#717780` (4.51) | boş daire, çizgili |
Referans: Tookan boşta yeşil / yolda açık mavi / çevrimdışı gri **[İ]**; mola için doğrudan endüstri kaynağı bulunamadı (amber seçimi tasarımcı çıkarımı) **[DOĞRULANMADI]**.

### 9.3 Renk körlüğü doğrulaması **[HESAP: Machado vd. 2009 matrisleri, şiddet 1.0, CIEDE2000]**
- Yaşam döngüsü 6 aile, en yakın çiftler (ΔE00; < 10 = ayırt etmek zor): **normal görüş** min 21 (mor/mavi) · **protanopi** mor/mavi **3**, yeşil/amber 11 · **deuteranopi** mor/mavi **2**, yeşil/gül **6** · **tritanopi** cyan/yeşil **7**.
- Kurye 4 durumu: en yakın çift ΔE00 ≥ 11 (protan: çevrimiçi/molada 11; deutan 14; tritan: çevrimiçi/siparişte 12) → renk tek başına büyük ölçüde ayırt edilebilir ama yine de ikon kuralı geçerli.
- Sonuç: **hiçbir 6'lı palet tüm renk körlüğü türlerinde ΔE00 > 10 sağlamadı** → ikon/şekil/metin zorunluluğu (WCAG 1.4.1) bu verilere dayanıyor. Mor ile mavi (hazırlanıyor vs hareket) ekranda yan yana görünmemeli; görünüyorsa ikon ve etiket ayırır.

---

## 10. Hızla için 15 tasarım tavsiyesi

1. **Kimliği "true black + cyan `#00DAF3`" üzerine kurun; `#FF4B2B`'yi tek ayırt edici olarak taşımayın.** DoorDash ile ΔE00 3.8, TR turuncu kümesiyle ≈ 10–11. Cyan kümeye ≥ 53 ΔE00 uzak (S1+hesap). Logo yan yana tanınırlık testi (3 sn) yapın.
2. **Kırmızı-turuncuyu "birincil eylem + logo vurgusu"na daraltın; hata/iptal/gecikme için ayrı aileler kullanın** (gül `#FF5C7A` + X, amber `#FFA11A` + saat). Birincil ile destructive eylem karışmasın.
3. **Buton metni `#FF4B2B` üstünde siyah** (6.29:1) veya koyu varyant `#D93A1E` üstünde beyaz (4.59:1). Beyaz-`#FF4B2B` (3.34:1) AA'yı geçemez.
4. **Kurye uygulamasında kontrast hedefi AAA (7:1) + "Güneş modu";** ikincil metin ≥ 4.5:1 (`#A1A1AA`/`#8A8F98`; `#6B7280` yasak). Gün ışığı saha testini erken yapın (koyu vs açık).
5. **Dokunma hedefleri:** ana eylem 64 dp, ikincil 56 dp, mutlak min 48 dp, aralık ≥ 8–12 dp (Parhi ≈ 9.2–9.6 mm ≈ 58–61 dp).
6. **Alt-odaklı tek el düzeni;** birincil CTA alt kenarda, sol/sağ el ayarı, bottom sheet; hareket halindeyken çok adımlı akış ve metin girişi kilitli (NHTSA 2 sn / 12 sn referansı).
7. **Slide-to-confirm yalnız geri döndürülemez adımlarda ve her zaman tek-dokunuş/basılı-tut alternatifiyle** (WCAG 2.5.7). Sık adımlar (kabul) tek dokunuş.
8. **Bildirim mimarisi:** Android kanal id'lerini sürümleyin (ses/titreşim sonradan değişmez); DnD bypass ve tam ekran niyet izinlerini baştan planlayın; iki ayrı ses profili; restoran tarafında onaylanana dek tekrarlayan alarm + "Ses kapalı" kalıcı uyarısı.
9. **Tipografi:** Inter (UI + rakam, `tnum` daima açık) + Plus Jakarta Sans (display) + IBM Plex Mono (kodlar). ₺ glifi olmayan (Geist, Figtree, Rubik, Sora, Outfit, Instrument Sans, Urbanist, JetBrains/Geist Mono) ve `tnum`'u olmayan (DM Sans, Urbanist) fontları para/tablolarda kullanmayın. Fontları bundle edin (çevrimdışı).
10. **Türkçe doğruluk:** `toUpperCase()` yerine `İ/ı` farkındalıklı yardımcı; `₺` biçimi `tr_TR`; büyük harf etiketlerde satır yüksekliği ≥ 1.25; metin ölçeği 1.0/1.3/2.0 test matrisi; `reduceMotion` + `disableAnimations` ikisini de oku.
11. **Durum sistemi: 6 renk ailesi + ikon + metin; gecikme = bindirme rozeti;** aşama farkı (restorana yolda / teslim alındı / yolda) renkle değil ikon + 3 parçalı ilerlemeyle. Yeşil'in anlamını tek yere bağlayın (Uber Eats'te "yeni", Onfleet'te "tamamlandı" çelişkisi).
12. **Harita:** özel MapLibre stili (etiket ≥ 7:1, stok Dark Matter yol etiketi 1.65:1); rota koyu zeminde cyan, açık zeminde `#0087A0` + casing; pin şekil+numara. CARTO için API anahtarı/kota (ticari 1M tile/ay) planı ya da OpenFreeMap/Protomaps alternatifi seçin.
13. **İşletme paneli:** tek dokunuşla kabul (kaydırma yok), hazırlık süresi stepper'ı, yatay tablette 3 sütunlu Kanban, kurye ETA'sı kartta büyük; teslimat tipi (platform kuryesi / restoran kuryesi) bilet kenarlığında; panel otomatik kapanırsa sebep + zaman damgası (Yemeksepeti panel şikâyetlerinden ders).
14. **Dispatch:** harita + liste + ayrıntı çekmecesi; "exception ile yönetim" (varsayılan görünüm sorunlu siparişler), doygun renk yalnız anormal durumlar için; P1/P2/P3 alarm kademeleri (ack/erteleme/otomatik kapanma); tazelik rozeti; Base Web benzeri yoğun ölçek (12/14/16 px).
15. **Kurye kazanç/teklif ekranları:** teklif kartında ₺ kazanç en büyük + mesafe/süre + geri sayım (referans 45–50 sn); kazanç ekranında gün toplamı + sipariş sayısı + ₺/saat, sipariş başına şeffaf kırılım, ödeme durumu; tüm sayılar `tnum`.

---

## 11. Açık / doğrulanamayan konular (sonraki turda kapatılmalı)

- Yemeksepeti (2021 sonrası), Getir, Trendyol Go, Migros, Wolt **resmi HEX** değerleri; Glovo, Deliveroo, Just Eat, Swiggy, Wolt (güncel), Yemeksepeti, Getir, Trendyol, Migros **yazı tipleri**.
- Glovo sarısı: Simple Icons `#F2CC38` ↔ başka bir kaynak `#FFC244` (çelişki).
- DoorDash: `#FF3008` ↔ `#EB1700` (hangisi güncel birincil?).
- Eldivenli dokunma için sayısal çalışma; güneşte koyu/açık tema üstünlüğü.
- Apple Critical Alerts entitlement şartları; iOS Dynamic Type erişilebilirlik ölçek üst sınırı; Türkiye'de sürüş sırasında telefon kullanımı mevzuatı.
- Mapbox / Google Maps güncel fiyat/şartlar.
- Mola durumu için endüstri renk pratiği.
- Deliveroo/Glovo/Wolt kurye uygulaması tasarım blog yazıları (bulunamadı; vaka çalışmaları portföy düzeyinde).
- `reduceMotion` bayrağının Flutter **stable** sürümündeki durumu (kaynak master dalı).

**Önerilen saha testleri:** (1) öğle güneşinde 5–8 kuryeyle koyu/açık/Güneş modu okunabilirlik; (2) eldivenle (yaz/kış) hedef boyutu 48/56/64 dp hata oranı; (3) mutfakta alarm sesi duyulabilirliği ve ilk-kabul süresi; (4) 3 sn logo tanınırlık testi (DoorDash/Trendyol Go/Yemeksepeti yanında).

---

## 12. Kaynakça

Güven: **[B]** birincil · **[İ]** ikincil/arama özeti · **[İ düşük]** zayıf kaynak. "Okunamadı" = sayfanın kendisi WebFetch ile açılamadı; yalnızca arama sonucu özeti kullanıldı.

**Birincil (GitHub'dan doğrudan okunan/ölçülen)**
- S1 — Simple Icons marka verisi (HEX + marka kaynağı): https://github.com/simple-icons/simple-icons/blob/develop/data/simple-icons.json **[B]**
- S2 — Uber Base Web tipografi kaynağı (UberMove/UberMoveText/UberMoveMono; 12–28 px ölçek): https://github.com/uber/baseweb/blob/main/src/themes/shared/typography.ts **[B]**
- S3 — Google Fonts font dosyaları ve METADATA: https://github.com/google/fonts/tree/main/ofl (inter, plusjakartasans, manrope, figtree, geist, dmsans, outfit, rubik, sora, spacegrotesk, onest, instrumentsans, bricolagegrotesque, urbanist, jetbrainsmono, geistmono, ibmplexmono) **[B]**
- S4 — W3C WCAG 2.2 kaynak (Understanding/SC): https://github.com/w3c/wcag/tree/main/understanding ve https://github.com/w3c/wcag/tree/main/guidelines/sc; yayımlanmış hali https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html (okunamadı; GitHub kaynağı okundu) **[B]**
- S5 — Flutter kaynağı: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/media_query.dart ; https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/constants.dart ; https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/constants.dart ; https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/painting/text_style.dart ; https://github.com/flutter/engine/blob/main/lib/ui/text.dart **[B]**
- S6 — `google_fonts` paketi (README, CHANGELOG, üretilmiş font parçaları): https://github.com/flutter/packages/tree/main/packages/google_fonts **[B]**
- S7 — CARTO basemap-styles (README, `mapboxgl/*_vars.json`): https://github.com/CartoDB/basemap-styles **[B]**
- S8 — OpenFreeMap: https://github.com/hyperknot/openfreemap ; stiller: https://github.com/hyperknot/openfreemap-styles **[B]**
- S9 — flutter-maplibre-gl: https://github.com/maplibre/flutter-maplibre-gl ; Protomaps: https://github.com/protomaps/basemaps **[B]**
- S10 — flutter_local_notifications README: https://github.com/MaikuB/flutter_local_notifications **[B]**
- S11 — Dart SDK `String.toUpperCase` belgesi: https://github.com/dart-lang/sdk/blob/main/sdk/lib/core/string.dart **[B]**
- S12 — Inter deposu (tnum/variable/lisans): https://github.com/rsms/inter **[B]**

**İkincil (arama özeti; sayfa okunamadı)**
- S13 — Hoober, "How Do Users Really Hold Mobile Devices?": https://www.uxmatters.com/mt/archives/2013/02/how-do-users-really-hold-mobile-devices.php
- S14 — NHTSA görsel-manuel dikkat dağınıklığı yönergeleri: https://www.nhtsa.gov/node/7116 ; https://www.nhtsa.gov/sites/nhtsa.gov/files/811781.pdf
- S15 — NN/g Touch Target Size: https://www.nngroup.com/articles/touch-target-size/ ; Parhi vd.: https://www.microsoft.com/en-us/research/?p=155150 ; https://www.redalyc.org/pdf/496/49645986004.pdf ; W3C hedef boyutu araştırma özeti: https://www.w3.org/WAI/GL/mobile-a11y-tf/wiki/Summary_of_Research_on_Touch/Pointer_Target_Size
- S16 — NTNU tezi, ortam aydınlatmasının metin tanımaya etkisi: https://ntnuopen.ntnu.no/ntnu-xmlui/handle/11250/2588645 **[İ düşük]**
- S17 — DoorDash, "Launching Dark Mode While Building a Scalable Design System" (17 Mart 2021): https://careersatdoordash.com/blog/launching-dark-mode-while-building-a-scalable-design-system/
- S18 — DoorDash, "Delivering a Better Experience for Dashers": https://about.doordash.com/en-us/news/delivering-a-better-experience-for-dashers
- S19 — DoorDash teklif kabul yardım sayfası: https://help.doordash.com/en-ca/dashers/article/how-to-accept-an-order ; https://www.ridesharingdriver.com/doordash-pause-dash-acceptance/
- S20 — Delivery Hero, "From Streets to Screens: Redesigning the Rider App": https://tech.deliveryhero.com/from-streets-to-screens-redesigning-the-rider-app ; https://deliveryhero.jobs/blog/from-streets-to-screens-redesigning-the-rider-app/
- S21 — Uber yeni Driver app: https://www.uber.com/newsroom/new-driver-app ; https://www.uber.com/blog/introducing-a-new-app-built-together-with-drivers-2 ; tasarım ilkeleri: https://www.designprinciplesftw.com/collections/guiding-principles-of-uber
- S22 — Uber 2018 marka yenileme: https://www.uber.com/careers/design/work/2018-redesign
- S23 — Glovo kurye uygulaması vaka (portföy): https://reginamizuno.myportfolio.com/glovo ; https://contra.com/nutripup_cooggl18/work **[İ düşük]**
- S24 — Wolt Partner uygulaması kullanılabilirlik tezi: https://www.theseus.fi/handle/10024/148887
- S25 — Skip The Dishes, bölge tercihi: https://insidetrack.skipthedishes.com/self-serve-your-preferred-zone/
- S26 — Uber Eats Orders: https://merchants.ubereats.com/gb/en/resources/learning-center/uber-eats-orders-app/
- S27 — DoorDash Tablet Order Manager: https://help.doordash.com/en-us/merchants/article/tablet-order-manager-overview
- S28 — Deliverect sipariş/kurye durumları: https://developers.deliverect.com/page/order-status
- S29 — Toast KDS bilet görünümü: https://support.toasttab.com/en/article/Customize-the-Appearance-of-KDS-Tickets
- S30 — Onfleet görev durumu: https://support.onfleet.com/hc/en-us/articles/20509786766228-Task-Status ; harita/kenar çubuğu: https://support.onfleet.com/hc/en-us/articles/360023669612
- S31 — Tookan görev/ajan durumu: https://help.jungleworks.com/?p=188
- S32 — Bringg uyarılar ve yeni dispatch deneyimi: https://help.bringg.com/docs/resolve-delivery-problems-by-checking-alerts-1 ; https://help.bringg.com/docs/introducing-the-new-dispatch-and-planning-experience
- S33 — Shipday dispatch (entegrasyon sayfası özeti): https://www.lightspeedhq.com/integrations/shipday/
- S34 — ISA-101 / ISA-18.2 yüksek performanslı HMI: https://docs.tatsoft.com/display/FX/ISA-101+HMI+Compliance+How-to ; https://orise.com/boosting-operator-effectiveness-traditional-vs-high-performance-hmi **[İ; satıcı iddiaları içerir]**
- S35 — Deliveroo yeniden markalama: https://www.creativereview.co.uk/deliveroo-global-identity/ ; https://www.creativebloq.com/news/deliveroo-rebrand
- S36 — Just Eat yeniden markalama (2016): https://www.designweek.co.uk/issues/12-18-september-2016/just-eat-reveals-rebrand/
- S37 — Grab Community Font: https://lovethework.com/work-awards/campaigns/grab-community-1493875
- S38 — Yemeksepeti logo/tasarım yenileme (2021): https://webrazzi.com/2021/09/29/yemeksepeti-logosunu-ve-tasarimini-yeniledi/ ; https://www.log.com.tr/yemeksepeti-icin-logo-ve-tasarimda-guncellemeye-gidildi/
- S39 — Trendyol / Trendyol Go logo: https://logowik.com/trendyol-go-delivery-logo-vector-77409.html ; https://whatthelogo.com/logo/trendyol/220170 **[İ düşük]**
- S40 — Migros logo: https://logotyp.us/logo/migros/ **[İ düşük]**
- S41 — Getir logo: https://whatthelogo.com/logo/getir/214582 ; https://ben.page/getir-colors **[İ düşük]**
- S42 — Wolt Omnes: https://fontsinuse.com/uses/41307/wolt
- S43 — DoorDash TT Norms Pro: https://typetype.org/font-in-use/doordash/
- S44 — Zomato (Okra, renk): https://blakecrosley.com/guides/design/zomato **[İ düşük]**
- S45 — Uber–Trendyol Go: https://news.bloomberglaw.com/antitrust/uber-said-in-talks-to-buy-turkish-delivery-platform-trendyol-go ; https://www.ekonomist.com.tr/sirketler/uber-trenyol-go-yu-satin-aliyor-59785
- S46 — Yemeksepeti restoran paneli şikâyeti: https://www.sikayetvar.com/yemeksepeti/restoran-panelim-surekli-kapaniyor-siparis-ve-musteri-kaybi-yasiyorum
- S47 — GetirYemek "Restoran getirsin": https://webrazzi.com/2019/11/22/getiryemek-ten-yeni-teslimat-secenegi-restoran-getirsin/
- S48 — Swiggy 2026 Master Brand Guidelines (okunamadı): https://www.swiggy.com/corporate/wp-content/uploads/2026/07/master-brand-guidelines.pdf
- S49 — WCAG 2.5.7 slide-to-confirm yorumu: https://sparkbox.com/foundry/understanding_implementing_wcag_dragging_movements_accessibility ; https://www.disabilityworld.org/toolkit/standards/wcag/2-5-7-dragging-movements/
- S50 — Postmates Fleet vaka: https://bootcamp.uxdesign.cc/postmates-fleet-redesign-a-ux-case-study-65717ec75dc0 ; kabul ekranları: https://therideshareguy.com/best-delivery-acceptance-screen/ **[İ düşük]**
- S51 — Apple HIG Accessibility (44×44 pt; özet doğrulanmalı): https://developer.apple.com/design/human-interface-guidelines/accessibility
- S52 — Çevrimdışı görünüm kalıbı: https://spin.atomicobject.com/where-is-the-offline-view-pattern/
- S53 — Material koyu tema: https://m2.material.io/design/color/dark-theme

---

## Ek-A. Hesaplama yöntemi (tekrarlanabilirlik)

- **Kontrast:** WCAG göreli parlaklık (sRGB doğrusallaştırma, 0.2126/0.7152/0.0722), oran = (L1+0.05)/(L2+0.05).
- **Renk farkı:** sRGB → XYZ (D65) → CIELAB → **CIEDE2000** (Sharma formülasyonu).
- **Renk körlüğü simülasyonu:** Machado, Oliveira, Fernandes (2009) protan/deutan/tritan matrisleri, şiddet 1.0, doğrusal RGB üzerinde; ardından CIEDE2000.
- **Font ölçümü:** `fontTools` 4.66.1; `cmap` ile glif varlığı, GSUB özellik listesi, `tnum` tek-yerine-koyma (single substitution) eşlemesi uygulanıp `hmtx` ilerlemelerinin eşitliği; `x` ve `H` glif sınır kutularından x-yüksekliği/cap oranı.
- **dp→mm:** mm = dp × 25.4 / 160 (Android dp referansı; iOS pt ≈ 1/163 inç).
