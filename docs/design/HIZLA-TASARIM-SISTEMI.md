# Hızla Tasarım Sistemi

> **Sürüm 1.0 · 2026-10-06** · Kapsam: kurye uygulaması (Flutter), işletme paneli (web, tablet öncelikli), operasyon paneli (web, masaüstü)
> Görsel referans: kaynak dosyası [`hizla-tasarim-sistemi.html`](hizla-tasarim-sistemi.html) (renkler, yazı tipleri, bileşenler ve üç yüzeyin örnek ekranları; açık ve koyu tema)
> Kardeş dokümanlar: [Fizibilite ve Rakip Raporu](../reports/HIZLA-FIZIBILITE-VE-RAKIP-RAPORU.md) · [Mimari Geçiş Planı](../ARCHITECTURE-PLAN.md)

Bu doküman Hızla'nın üç yüzeyinin **tek** görsel ve davranışsal dilini tanımlar. Kurye, işletme ve operasyon aynı token'ları, aynı yazı tiplerini, aynı ikon setini, aynı durum dilini ve aynı terimleri kullanır. Yüzeyler arasında değişen tek şey **yoğunluktur** (§7): kurye ekranı büyük ve seyrek, operasyon ekranı küçük ve yoğun. Renk, şekil ve kelime değişmez.

---

## 0. Özet: kararlar

| Konu | Karar | Bugünkü durum |
|---|---|---|
| Ana renk | **Turkuaz** (`#16BCCB` dolgu, `#006A77` metin) | Kor kırmızı-turuncu `#FF4B2B` |
| Nötr | **Asfalt**: turkuaza hafif eğilimli soğuk gri; koyu temada `#0B1214`, saf siyah değil | Saf siyah `#0E0E0E` + sıcak gri |
| Kor `#FF4B2B` | Yalnızca logodaki hareket noktası ve pazarlama | Ana renk |
| Durum dili | **Renk = dikkat düzeyi; ikon + etiket = adım; gecikme durum değil rozet** | Her durum ayrı renk, tutarsız |
| Harita | **MapLibre + Hızla'ya özel vektör stil** (etiket kontrastı ≥ 7:1); geçişte CARTO raster + API anahtarı | CARTO raster, anahtarsız (artık filigranlı geliyor) |
| Yazı tipleri | **Archivo** (başlık ve büyük rakam) · **Atkinson Hyperlegible Next** (metin) · **Atkinson Hyperlegible Mono** (kod, PIN, plaka) | Web: Inter + kullanılmayan Space Grotesk; mobil: Inter + Space Grotesk + JetBrains Mono |
| Para | `₺1.284,50`, yalnızca yerel ayar biçimlendiricisiyle; ₺ glifi Archivo'dan | JetBrains Mono'da ₺ glifi yok |
| İkonlar | **Phosphor** (web ve Flutter'da aynı set) | Web emoji, mobil Material Rounded |
| Köşe | Rol bazlı ölçek: 4 · 8 · 12 · 16 · 24 · tam | Web 16 her yerde, mobil kartta 28 |
| Çizgi | Veri yoğun yüzeyde 1 px ince çizgi serbest; kurye kartları tonal | Çizgi yasak |
| Tema | Kurye: **Otomatik** (gündüz açık, gece koyu; harita kuralıyla aynı). İşletme: açık. Operasyon: sistem | Varsayılan koyu |
| Token kaynağı | Tek `tokens.json` → CSS değişkenleri + Dart sınıfı (üretilir) | Web ve mobilde elle yazılmış, birbirinden farklı değerler |
| Dil | Türkçe varsayılan, i18n ile; kuryeye "sen", işletmeye "siz" | Mobilde Türkçe-İngilizce karışık (`CURRENT BALANCE`, `Mission`) |

---

## 1. Neden bu yön

### 1.1 Ürünün dünyası

Hızla bir tüketici markası değil; tüketici markalarının **arkasında** çalışan bir operasyon markası. Ekranlarında sürekli başka markalar görünür: her teslimatın üzerinde siparişin geldiği platformun rozeti vardır (Yemeksepeti pembe-kırmızı, Getir mor, Trendyol turuncu). Hızla'nın kendi rengi bu rozetlerle karışmamalı, onların yanında sakin ve ayırt edilir durmalı.

Üç kullanıcısı çok farklı koşullarda çalışır:

| | Kurye | İşletme | Operasyon |
|---|---|---|---|
| Ortam | Motor üstünde, güneş altında ya da gece, eldivenle, tek elle | Mutfak tezgâhı, gürültü, yağlı eller, ara ara bakış | Masa başı, uzun süre, birden fazla ekran |
| Bakış süresi | 1–2 saniye | 3–5 saniye | Dakikalarca, tarama |
| Asıl soru | "Bu iş bana ne kazandırır, nereye gidiyorum?" | "Kurye ne zaman burada?" | "Nerede sorun var?" |
| Hata maliyeti | Kaza, yanlış adres, kayıp kazanç | Soğuyan yemek, kızgın müşteri | Toplu gecikme, kaybedilen işletme |

Bu tablo tasarımın üç kuralını belirler: **okunabilirlik güvenlik özelliğidir**, **dikkat gerektiren şey rengini kazanır, gerisi sessiz kalır**, **para her zaman açık yazılır**.

### 1.2 Kor kırmızısından Turkuaza

Bugünkü ana renk `#FF4B2B` dört nedenle değişiyor:

1. **Hata rengiyle çakışıyor.** Operasyon panelinde kırmızı "geç kaldı / sorun var" demek zorunda. Ana renk de kırmızıya yakınken, birincil buton ile gecikme uyarısı aynı aileden olur ve en önemli sinyal gürültüde kaybolur.
2. **Platform rozetleriyle çakışıyor.** Trendyol turuncusu (`#FF6000`) ve Yemeksepeti pembe-kırmızısı (`#EA004B`) her ekranda rozet olarak durur. Turuncu-kırmızı bir ana renk, rozetin Hızla'nın kendi vurgusu mu yoksa siparişin kaynağı mı olduğunu belirsizleştirir.
3. **Beyaz zeminde metin olarak okunmuyor.** `#FF4B2B` beyaz üzerinde 3,34:1 kontrast verir; WCAG AA'nın normal metin eşiği 4,5:1'dir. Bugün bu renk metin ve küçük ikon olarak da kullanılıyor.
4. **Ayırt edici değil.** Türkiye'de yemek teslimatında sıcak renkler (pembe-kırmızı, turuncu) ve mor dolu; soğuk turkuaz alanı boş. Turkuaz ayrıca Türkçede adını Türk'ten alan renktir.

Süreklilik korunuyor: bugünkü vurgu rengi neon cyan `#00DAF3` zaten turkuaz ailesinden. Koyu temada ana renk `#4FD2DC` olur ve mevcut kullanıcı alışık olduğu tonu görmeye devam eder. Kor `#FF4B2B` de tamamen gitmiyor: logodaki hareket noktası olarak kalıyor (§5).

---

## 2. Renk

### 2.1 Ham paletler

**Turkuaz (marka)**

| Token | HEX | Kullanım |
|---|---|---|
| `tz-50` | `#E8FAFB` | açık temada marka zemin tonu (seçili satır, bilgi alanı) |
| `tz-100` | `#C6F1F4` | |
| `tz-200` | `#93E3EA` | |
| `tz-300` | `#4FD2DC` | **koyu temada ana renk** (dolgu ve metin) |
| `tz-400` | `#16BCCB` | **açık temada ana dolgu** (birincil buton, aktif durum) |
| `tz-500` | `#00A0B0` | odak halkası |
| `tz-600` | `#00808E` | |
| `tz-700` | `#006A77` | **açık temada marka metni ve ikonu** |
| `tz-800` | `#0A5560` | |
| `tz-900` | `#0C434B` | koyu temada marka zemin tonu |
| `tz-950` | `#062A2F` | marka dolgusu üzerindeki metin ("mürekkep") |

**Asfalt (nötr)**

| Token | HEX | | Token | HEX |
|---|---|---|---|---|
| `as-0` | `#FFFFFF` | | `as-500` | `#63737A` |
| `as-25` | `#F6F8F8` | | `as-600` | `#4B5A60` |
| `as-50` | `#EEF2F3` | | `as-700` | `#374348` |
| `as-100` | `#E3E8EA` | | `as-800` | `#253035` |
| `as-200` | `#CBD3D6` | | `as-850` | `#1A2327` |
| `as-300` | `#A9B5B9` | | `as-900` | `#131B1E` |
| `as-400` | `#83939A` | | `as-950` | `#0B1214` |

Asfalt, turkuaza doğru hafif eğilimli bir soğuk gridir. Saf gri yerine bunun seçilmesinin nedeni, marka renginin yanında "ayarlanmamış" görünmemesidir. Koyu temada zemin `#0B1214`'tür; saf siyah (`#000`, bugünkü `#0E0E0E`) OLED ekranlarda kaydırırken iz bırakır ve gece gözü yoran sert kontrast üretir.

**Anlam renkleri**

| Rol | Açık · mürekkep | Açık · zemin tonu | Koyu · mürekkep | Koyu · zemin tonu | Dolgu (rozet) |
|---|---|---|---|---|---|
| Başarı | `#16794A` | `#E5F5EC` | `#4CC987` | `#12301F` | `#1B8A50` |
| Uyarı | `#9A5B00` | `#FFF3DC` | `#FFC24D` | `#3A2A08` | `#F5A524` (üzerinde `#2A1A00`) |
| Tehlike | `#B42A23` | `#FDE8E6` | `#FF7B72` | `#3D1513` | `#D63A31` |
| Bilgi | `#2B55C9` | `#E8EEFD` | `#8EA8FF` | `#18234A` | `#3461DA` |

**Logo noktası:** `kor` `#FF4B2B`. Uygulama arayüzünde bildirim rozeti, buton ya da metin olarak **kullanılmaz**.

**Platform renkleri** (yalnızca rozetteki küçük işaret; büyük alan boyanmaz):

| Platform | Renk | Kaynak |
|---|---|---|
| Yemeksepeti | `#EA004B` | mevcut kod tabanı (`theme.js`, `app_colors.dart`); resmi rehberle teyit edilecek |
| Getir | `#5D3EBD` | mevcut kod tabanı |
| Trendyol Go | `#FF6000` | mevcut kod tabanı |
| Migros Yemek | teyit edilecek | — |
| Doğrudan (elle / işletmenin kendi kanalı) | `as-500` | — |

### 2.2 Anlamsal token'lar

Bileşenler ham paleti **hiçbir zaman** doğrudan kullanmaz; yalnızca aşağıdaki anlamsal token'ları kullanır. Tema değişimi yalnızca bu tablonun sağ iki sütununu değiştirir.

| Token | Rol | Açık | Koyu |
|---|---|---|---|
| `--hz-bg` | sayfa zemini | `as-25` | `as-950` |
| `--hz-surface` | kart, tablo, panel | `as-0` | `as-900` |
| `--hz-surface-2` | gömülü alan, giriş kutusu, ikincil kart | `as-50` | `as-850` |
| `--hz-surface-3` | basılı/seçili zemin, ilerleme izi | `as-100` | `as-800` |
| `--hz-line` | ince ayırıcı çizgi | `as-100` | `as-800` |
| `--hz-line-strong` | giriş kutusu kenarı, tablo başlığı altı | `as-200` | `as-700` |
| `--hz-text` | ana metin | `as-900` | `as-100` |
| `--hz-text-2` | ikincil metin | `as-600` | `as-300` |
| `--hz-text-3` | yardımcı metin, devre dışı olmayan ipucu | `as-500` | `as-400` |
| `--hz-brand-fill` | birincil buton, aktif sekme işareti, seçili çip | `tz-400` | `tz-300` |
| `--hz-on-brand` | marka dolgusu üzerindeki metin | `tz-950` | `#04262B` |
| `--hz-brand-ink` | marka rengindeki metin, link, ikon | `tz-700` | `tz-300` |
| `--hz-brand-tint` | marka zemin tonu | `tz-50` | `tz-900` |
| `--hz-focus` | klavye odak halkası (2 px + 2 px boşluk) | `tz-500` | `tz-300` |
| `--hz-success` / `-tint` | | §2.1 | §2.1 |
| `--hz-warning` / `-tint` | | §2.1 | §2.1 |
| `--hz-danger` / `-tint` | | §2.1 | §2.1 |
| `--hz-info` / `-tint` | | §2.1 | §2.1 |
| `--hz-scrim` | modal arkası | `rgba(11,18,20,.48)` | `rgba(0,0,0,.6)` |

### 2.3 Kontrast doğrulaması (WCAG 2.2)

Değerler hesaplandı (göreli parlaklık formülüyle). AA eşiği normal metin 4,5:1, büyük metin ve arayüz bileşeni 3:1.

| Çift | Oran | Sonuç |
|---|---|---|
| `--hz-text` / `--hz-bg` (açık) | 16,37 | AAA |
| `--hz-text-2` / `--hz-surface` (açık) | 7,17 | AAA |
| `--hz-text-3` / `--hz-surface` (açık) | 4,93 | AA |
| `--hz-brand-ink` / beyaz | 6,31 | AA |
| `--hz-on-brand` / `--hz-brand-fill` (açık) | 6,59 | AA |
| `--hz-text` / `--hz-bg` (koyu) | 15,30 | AAA |
| `--hz-text-2` / `--hz-surface` (koyu) | 8,31 | AAA |
| `--hz-text-3` / `--hz-surface` (koyu) | 5,49 | AA |
| `--hz-brand-ink` / `--hz-bg` (koyu) | 10,43 | AAA |
| `--hz-on-brand` / `--hz-brand-fill` (koyu) | 8,79 | AAA |
| Başarı / Uyarı / Tehlike / Bilgi mürekkebi (açık, beyaz üzerinde) | 5,43 / 5,43 / 6,37 / 6,47 | AA |
| Aynıları (koyu, `as-900` üzerinde) | 8,32 / 10,87 / 6,92 / 7,64 | AA–AAA |
| Beyaz / Tehlike dolgusu | 4,66 | AA |
| `#2A1A00` / Uyarı dolgusu | 8,26 | AAA |
| Karşılaştırma: bugünkü `#FF4B2B` / beyaz | 3,34 | **AA altında** |
| Karşılaştırma: beyaz / Trendyol `#FF6000` | 3,03 | AA altında: rozet metni beyaz değil `as-900` yazılır |

Kural: Başarı dolgusu (`#1B8A50`) üzerine beyaz küçük metin yazılmaz (4,38:1); başarı rozetlerinde zemin tonu + mürekkep kullanılır.

### 2.4 Durum dili: renk dikkat düzeyini, ikon ve etiket adımı söyler

Teslimatın 10'a yakın durumu var (Mimari Plan §5.4). Her birine ayrı renk vermek, ekranda gökkuşağı ve "hangi renk neydi" ezberi üretir. Bunun yerine renk yalnızca **ne kadar dikkat gerektiğini** söyler; hangi adımda olunduğunu ikon ve etiket söyler.

**Durum çipi** (adım: üç ton yeter)

| Ton | Anlamı | Teslimat durumları | Kurye varlığı |
|---|---|---|---|
| **Nötr** (`--hz-text-2` / `--hz-surface-2`) | beklenen, normal akış, henüz kimsede değil | `created` Hazırlanıyor · `searching` Kurye aranıyor · `offered` Teklif edildi · `cancelled` İptal (üstü çizili değil, `XCircle` ikonu) | `offline` Çevrimdışı · `on_break` Molada |
| **Marka** (`--hz-brand-ink` / `--hz-brand-tint`) | Hızla'nın elinde, hareket hâlinde | `assigned` Kurye yolda · `at_pickup` Kurye işletmede · `picked_up` Teslim alındı · `at_dropoff` Adreste | `on_delivery` Teslimatta |
| **Başarı** | bitti, sorunsuz | `delivered` Teslim edildi | `online_idle` Müsait |

Hareket hâlindeki dört adım aynı tonu taşır; aralarındaki fark ikonla (`Moped`→`Storefront`, `Package`, `Moped`→`House`, `House`) ve 4 parçalı ilerleme çizgisiyle verilir.

**Dikkat rozeti** (gecikme ve sorun: çipin yanına eklenir, çipin yerine geçmez)

| Rozet | Ne zaman | Görünüm |
|---|---|---|
| **Uyarı** | SLA riski: kurye aranıyor > 3 dk, işletmede bekleme > 8 dk, tahmini varış sözün üstünde | amber zemin tonu + `Clock` + "+6 dk" |
| **Tehlike** | geç kaldı, `failed_dropoff`, açık `delivery_issue`, slot başladı ama giriş yok | tehlike dolgusu + `Siren` + kısa neden |

Gecikme bir durum değildir, herhangi bir durumun üstüne gelen bir bindirmedir; Onfleet'in geciken görev ikonuna eklediği nokta ve Toast mutfak ekranının nötr → turuncu → kırmızı zamanlayıcısı aynı kalıbı kullanır. Bu, kontrol odası arayüz standardı ISA-101'in ilkesiyle de aynıdır: **doygun renk yalnızca anormal durum içindir.** Normal akışta ekran sakin kalır; operatörün gözü yalnızca rozetlere gider.

Eşikler `delivery` kurallarından gelir ve operasyon panelinde ayarlanabilir; kurye uygulamasında uyarı rozeti **kuryeye ceza gibi gösterilmez** (§12): kurye kendi teslimatında gecikme rozeti görmez, yalnızca güncellenmiş tahmini varışı görür.

**Renk körlüğü kuralı:** Ton asla tek sinyal değildir. Renk körlüğü simülasyonunda (Machado 2009 matrisleri) hiçbir 6'lı palet tüm türlerde ayırt edilebilir kalmıyor; bu yüzden her çipte ikon + metin zorunludur (WCAG 1.4.1). Harita işaretlerinde dikkat rozeti şekille de tekrarlanır (uyarı: kesikli halka, tehlike: çift halka).

---

## 3. Tipografi

### 3.1 Aileler

| Rol | Aile | Neden |
|---|---|---|
| **Başlık ve büyük rakam** | **Archivo** (değişken: genişlik 62–125, ağırlık 100–900) | Genişlik ekseni hızı ifade eder: büyük kazanç ve tahmini varış rakamları geniş (`wdth 112`), yoğun tablolar dar kesimle yazılabilir. Türkçe karakterler tam, tabular rakam (`tnum`) var, **₺ glifi var**. |
| **Metin ve arayüz** | **Atkinson Hyperlegible Next** (200–800, italik) | Braille Institute'un az gören okurlar için tasarladığı ailenin 2025 sürümü. Karıştırılan harfleri bilinçli olarak ayırır: sıfırın çizgisi var (0 ≠ O), `l`'nin kuyruğu var, `I`'nın tırnakları var (1 ≠ l ≠ I). Motor üstünde bir saniyelik bakışta "No:10/B D:1" adresi yanlış okunmamalı. Türkçe karakterler tam, `tnum` var. |
| **Kod** | **Atkinson Hyperlegible Mono** | Sipariş kodu, teslim PIN'i, plaka (`34 HZL 482`), IBAN. Metin ailesiyle aynı harf ayrımları; varsayılan rakamları zaten tabular. |

Üçü de Google Fonts'ta, SIL Open Font License ile. Bu aileler 2026-10-06'da font dosyalarından doğrulandı: hepsinde `ğĞşŞıİçÇöÖüÜâÂîÎûÛ` tam; Archivo ve Atkinson Next'te `tnum` özelliği var.

**₺ uyarısı (doğrulandı):** Atkinson Hyperlegible Next ve Mono'da `₺` (U+20BA) glifi **yok**. Bugün mobilde para için kullanılan JetBrains Mono'da da yok; şu an ekrandaki ₺ işaretleri sistem fontuna düşüyor. Çözüm: her yığında Archivo ikinci sıradadır, tarayıcı ve Flutter eksik glifi Archivo'dan alır. Para bileşeni (`HzMoney`) zaten Archivo ile yazılır.

```css
--hz-font-display: 'Archivo', 'Atkinson Hyperlegible Next', system-ui, sans-serif;
--hz-font-text:    'Atkinson Hyperlegible Next', 'Archivo', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
--hz-font-mono:    'Atkinson Hyperlegible Mono', 'Archivo', ui-monospace, 'SFMono-Regular', Menlo, monospace;
```

```dart
// Flutter: fontFamilyFallback eksik ₺ glifini Archivo'dan alır.
const textStyleBase = TextStyle(
  fontFamily: 'AtkinsonHyperlegibleNext',
  fontFamilyFallback: ['Archivo'],
  fontFeatures: [FontFeature.tabularFigures()],
);
```

**Flutter'da fontlar paketlenir** (`pubspec.yaml` `fonts:`), `google_fonts` ile çalışma anında indirilmez. Gerekçe: kurye zayıf şebekede uygulamayı açtığında ilk ekran yanlış fontla çizilip sonra zıplamamalı; ayrıca indirme gereksiz veri harcar.

Archivo'nun genişlik eksenini Flutter'da kullanmak için değişken font dosyası paketlenir ve `TextStyle(fontVariations: [FontVariation('wdth', 112)])` verilir; `google_fonts` paketi `fontFeatures`'ı destekler ama değişken eksenleri desteklemez, paketlemenin ikinci gerekçesi budur.

**Bırakılanlar:** Inter (yerine Atkinson Next), Space Grotesk (web'de yüklenip hiç kullanılmıyordu), JetBrains Mono (₺ yok).

**Değerlendirilen alternatif:** Inter (metin) + Plus Jakarta Sans (başlık) + IBM Plex Mono (kod) de Türkçe, `tnum` ve ₺ açısından eksiksiz ve güvenli bir üçlü. Atkinson'ın seçilme nedeni karışan harfleri bilinçli olarak ayırması; kurye bir saniyelik bakışla adres ve kod okuduğu için bu ayrım bir güvenlik özelliği. Saha testinde Atkinson'ın Türkçe metinde yorucu bulunması hâlinde bu üçlüye geçiş, token'lardaki üç aile adını değiştirmekten ibarettir.

### 3.2 Ölçekler

Üç yüzey aynı adları kullanır; boyutlar yoğunluğa göre değişir. Değerler px (Flutter'da mantıksal piksel). Satır yüksekliği `/`'den sonra.

| Ad | Aile · ağırlık · genişlik | Kurye | İşletme | Operasyon | Kullanım |
|---|---|---|---|---|---|
| `display-xl` | Archivo 800 · 112 | 44/48 | 36/42 | 32/38 | kazanç tutarı, tahmini varış, KPI rakamı |
| `display` | Archivo 750 · 112 | 34/40 | 30/36 | 26/32 | ekran başlığı (kurye), büyük sayaç |
| `title-l` | Archivo 700 · 100 | 26/32 | 24/30 | 20/26 | sayfa başlığı |
| `title` | Atkinson 700 | 21/28 | 19/26 | 16/22 | kart başlığı, işletme adı |
| `body-l` | Atkinson 400 | 18/26 | 17/24 | 15/22 | adres, teklif dökümü |
| `body` | Atkinson 400 | 16/24 | 16/24 | 14/20 | genel metin |
| `label` | Atkinson 700 | 16/20 | 15/20 | 13/18 | buton, sekme, çip |
| `table` | Atkinson 400 · `tnum` | — | 15/22 | 13/18 | tablo hücresi |
| `caption` | Atkinson 400 | 14/20 | 13/18 | 12/16 | yardımcı metin; **kuryede 14'ün altı yok** |
| `overline` | Atkinson 700 · harf aralığı +0,06em · büyük harf | 13/16 | 12/16 | 11/14 | bölüm etiketi |
| `code` | Mono 700 | 22/28 | 16/22 | 13/18 | PIN, sipariş kodu, plaka |

Kurallar:
- Rakam içeren her yerde `font-variant-numeric: tabular-nums` (Flutter: `FontFeature.tabularFigures()`); sütunlar ve geri sayımlar kaymaz.
- Başlıklar `text-wrap: balance`. Metin sütunu en fazla ~68 karakter.
- Ağırlık 300'ün altı kullanılmaz (güneş altında kaybolur).
- **Türkçe büyük harf:** `overline` gibi büyük harfli etiketlerde web'de `<html lang="tr">` zorunlu; CSS `text-transform: uppercase` ancak bu sayede "istanbul"u "İSTANBUL" yazar (aksi hâlde "ISTANBUL"). Flutter'da `String.toUpperCase()` yerel ayara duyarlı değildir; büyük harf etiketler çeviri dosyasında büyük harfle yazılır ya da `toUpperCaseTr()` yardımcı fonksiyonu kullanılır (`i→İ`, `ı→I`).

---

## 4. Boşluk, köşe, gölge, hareket

### 4.1 Boşluk

4 tabanlı ölçek: `2 · 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48 · 64 · 80`. Kardeş öğeler `gap` ile dizilir; tek tek margin verilmez.

### 4.2 Köşe yarıçapı (rol bazlı)

| Token | Değer | Rol |
|---|---|---|
| `--hz-radius-xs` | 4 | tablo içi çip, harita etiketi |
| `--hz-radius-sm` | 8 | operasyon butonu ve giriş kutusu |
| `--hz-radius-md` | 12 | işletme butonu ve giriş kutusu, operasyon kartı |
| `--hz-radius-lg` | 16 | kurye butonu, kurye ve işletme kartı |
| `--hz-radius-xl` | 24 | alt sayfa (bottom sheet) üst köşeleri, teklif kartı |
| `--hz-radius-full` | 9999 | durum çipi, avatar, slider tutamacı |

Bugün web her yerde 16, mobil kartta 28, butonda 10 kullanıyor. Yeni ölçek iki platformda birebir aynıdır.

### 4.3 Çizgi ve gölge

- **Kurye:** kartlar tonal ayrımla ayrılır (`--hz-surface` üstünde `--hz-surface-2`), çizgi yok. Bu, bugünkü "Kinetic Nocturne" kuralının korunan kısmıdır.
- **İşletme ve operasyon:** tablo satırları, form alanları ve panel bölümleri `1px var(--hz-line)` ile ayrılır. Veri yoğun ekranda tonal ayrım tek başına taranabilirliği düşürür.
- **Gölge** yalnızca açık temada ve yalnızca üç seviyede:
  - `e1` kart: `0 1px 2px rgb(19 27 30 / .06), 0 1px 1px rgb(19 27 30 / .04)`
  - `e2` açılır menü: `0 8px 24px rgb(19 27 30 / .12)`
  - `e3` alt sayfa / modal: `0 16px 48px rgb(19 27 30 / .18)`
- Koyu temada gölge yok; yükseklik zemin tonuyla (`surface` → `surface-2` → `surface-3`) ve `1px var(--hz-line)` ile gösterilir.
- Cam (glassmorphism) efekti kaldırılır: güneş altında yarı saydam kartın üzerindeki metin harita dokusuyla karışır.

### 4.4 Hareket

| Token | Süre | Kullanım |
|---|---|---|
| `--hz-dur-instant` | 80 ms | basma geri bildirimi |
| `--hz-dur-quick` | 160 ms | çip, sekme, hover |
| `--hz-dur-base` | 240 ms | kart açılması, alt sayfa |
| `--hz-dur-slow` | 360 ms | ekran geçişi |

Eğriler: standart `cubic-bezier(.2,0,0,1)`, çıkış `cubic-bezier(.4,0,1,1)`. Teklif geri sayımı doğrusal. `prefers-reduced-motion` (Flutter: `MediaQuery.disableAnimations`) açıksa geçişler anlık, nabız animasyonları kapalı.

**Kuryede titreşim ve ses:** yeni teklif = iki güçlü titreşim + kendine özgü kısa ses (sessiz modda da titreşim); kabul = tek hafif titreşim; hata = üç kısa titreşim. İşletmede "kurye geldi" sesi teklif sesinden farklı olmalı; mutfakta iki ses karışmamalı.

**Bildirim kanalları (uygulama notu):** Android 8+ bildirim kanalının sesi ve titreşimi kanal ilk oluşturulurken sabitlenir, sonra aynı kimlikle değiştirilemez. Kanal kimlikleri sürümlenir: `offer_v1`, `delivery_update_v1`, `slot_v1`, `support_v1`. Teklif kanalı en yüksek önem düzeyindedir; Rahatsız Etmeyin modunu aşmak (`ACCESS_NOTIFICATION_POLICY`) ve tam ekran bildirim (`USE_FULL_SCREEN_INTENT`) Play politikalarına tabidir, başvuru aşamasında kuryeden izin istenir ve pil optimizasyonu istisnası yönlendirmesi yapılır.

---

## 5. Marka işareti

- **Logotip:** küçük harf `hızla`, Archivo 800, genişlik 118. Kanca, Türkçeye özgü **noktasız ı**'dır: ı'nın üzerinde olması gereken nokta Kor (`#FF4B2B`) renginde, sağa ve yukarı kaymış olarak çizilir. Nokta = yoldaki kurye. Başka hiçbir dilde bu harf yok; işaret Türkçe okuyana anında anlamını verir.
- **Uygulama ikonu:** Turkuaz (`tz-400`) kare zemin, `tz-950` renginde tek bir `ı` ve sağ üstünde Kor nokta.
- **Kor kullanım sınırı:** yalnızca logo noktası, açılış ekranı ve pazarlama. Arayüzde vurgu, rozet ya da buton rengi değildir.
- Logonun yanında platform logosu kullanılmaz; platformlar arayüzde yalnızca rozet olarak görünür (§8.4).

---

## 6. İkonlar

- Set: **Phosphor Icons**. Web'de `@phosphor-icons/react` (şablonun zorunlu frontend paketi), Flutter'da `phosphor_flutter`. İki platformda aynı ikon adları.
- Ağırlık: arayüzde **Regular**; kuryede 24 px ve üstünde **Bold** (güneş altında ince çizgi kaybolur); seçili sekme ve aktif durum **Fill**.
- Boyut: kurye 28, işletme 24, operasyon 20.
- Emoji arayüzde ikon yerine kullanılmaz (bugün web'de kullanılıyor). Puanlama ekranında bile yıldız/derece ikonları kullanılır; emojiler platformlar arasında farklı çizilir.

Sık ikonlar: `Storefront` işletme · `House` teslim adresi · `Moped` kurye · `Package` teslimat · `CalendarCheck` slot · `Wallet` kazanç · `Timer` süre · `MapPinLine` konum · `QrCode` teslim alma · `Password` PIN · `Camera` teslim fotoğrafı · `Lifebuoy` destek · `Siren` acil durum.

---

## 7. Yoğunluk: üç yüzey, tek sistem

| Token | Kurye (rahat) | İşletme (orta) | Operasyon (sıkı) |
|---|---|---|---|
| `--hz-target-min` (en küçük dokunma/tıklama alanı) | **56** | 48 | 32 |
| `--hz-control-h` (buton/giriş yüksekliği) | 56 (birincil eylem **64**) | 48 | 36 |
| `--hz-row-h` (liste/tablo satırı) | 72 | 56 | 36 |
| `--hz-card-pad` | 20 | 16 | 12 |
| `--hz-gutter` (ekran yan boşluğu) | 20 | 24 | 24 |
| Yazı ölçeği | §3.2 Kurye | §3.2 İşletme | §3.2 Operasyon |
| Buton köşesi | `lg` 16 | `md` 12 | `sm` 8 |
| İkon | 28 | 24 | 20 |
| Varsayılan tema | Otomatik | Açık | Sistem |

Kurye için 56 px, WCAG 2.5.8'in 24 px asgarisinin çok üstündedir; gerekçe eldivenle ve titreyen bir motor üzerinde dokunmaktır. Birincil eylem butonu (Teslim aldım, Teslim ettim) 64 px ve ekranın alt üçte birinde, başparmak bölgesindedir.

Web'de yoğunluk `<body data-density="merchant|ops">` ile seçilir; token'lar bu öznitelik altında yeniden tanımlanır. Flutter yalnızca kurye yoğunluğunu kullanır.

---

## 8. Bileşenler

Adlar web ve Flutter'da aynıdır (web: `HzButton.jsx`, Flutter: `HzButton` widget'ı). Ham MUI bileşeni kullanılmaz (şablon §16.10); her bileşen bir sarmalayıcıdır ve token'larla çizilir.

### 8.1 Temel

| Bileşen | Varyantlar | Notlar |
|---|---|---|
| `HzButton` | `primary` (marka dolgusu + mürekkep metin) · `secondary` (`surface-2` + metin) · `ghost` · `danger` | Ekranda tek bir `primary`. Yükseklik yoğunluk token'ından. Yükleniyor durumunda genişlik değişmez. |
| `HzSlideToConfirm` | yalnızca kurye | **Yalnızca geri alınamaz ve başka doğrulaması olmayan** eylemlerde: "Teslim edilemedi, iade et", "Slotu bırak" (12 saatten az kala). Kaydırma eşiği %85, onayda titreşim. **Her zaman** yanında tek dokunuşluk alternatif vardır: 1 sn basılı tutulan buton ve ekran okuyucu eylemi (WCAG 2.5.7, yalnızca sürüklemeyle yapılabilen eylem AA'yı geçmez). Sık yapılan eylemler (teklif kabulü, çevrimiçi olma) tek dokunuştur. |
| `HzInput`, `HzSelect`, `HzSegmented`, `HzSwitch` | | Etiket her zaman kutunun üstünde; yer tutucu etiket yerine geçmez. |
| `HzCard` | `flat` · `raised` | Kurye: tonal; panel: çizgili. |
| `HzSheet` | alt sayfa (kurye), yan çekmece (panel) | |
| `HzTabs` | | Aktif sekme: 3 px marka çizgisi + `label` ağırlığı. |
| `HzToast`, `HzBanner` | bilgi · başarı · uyarı · tehlike | Toast 4 sn, eylem içeriyorsa kalıcı. |
| `HzEmptyState` | | Ne görüneceğini ve ilk adımı söyler ("Bugün henüz teslimat yok. Yeni teslimat oluşturmak için…"). |

### 8.2 Alana özgü

| Bileşen | Ne gösterir |
|---|---|
| `HzMoney` | `₺1.284,50`; tam kısım `display`, kuruş bir kademe küçük. Negatif tutar `−₺42,00` (eksi işareti U+2212). Archivo, `tnum`. |
| `HzEta` | Tahmini varış: büyük "12 dk" + küçük saat "21:47". Söz verilen süre aşılırsa uyarı tonu. |
| `HzCountdownRing` | Teklif yanıt süresi (45 sn). Halka azalır, son 10 sn'de uyarı tonu. Yalnızca teklif için kullanılır; teslimat süresi geri sayım olarak gösterilmez (§12). |
| `HzStatusChip` | §2.4 tonu + Phosphor ikonu + etiket. Boyut yoğunluğa göre. |
| `HzPlatformBadge` | 8 px platform renginde kare + platform adı, `surface-2` zemin. Platform rengi büyük alanı boyamaz. |
| `HzStepper` | Teslimat adımları (Restorana git → İşletmede → Teslim alındı → Adrese git → Teslim edildi). Geçilen adım marka, şimdiki adım dolu, gelecek nötr. |
| `HzTimeline` | `delivery_event` kayıtları: saat, olay, kim, nerede. İşletme ve operasyon detay ekranında. |
| `HzMapPin` | işletme: marka dolgulu yuvarlatılmış kare + `Storefront`; teslim adresi: metin rengi daire + `House`; kurye: yön oku + varlık halkası. |
| `HzCourierAvatar` | fotoğraf/baş harfler + varlık halkası (müsait başarı, teslimatta marka, molada nötr, çevrimdışı boş halka). |
| `HzKpiTile` | operasyon üst şeridi: etiket, `display-xl` değer, son 60 dk mini çizgi, eşik aşıldıysa ton. |
| `HzSlotCard` | saat aralığı, bölge, doluluk çubuğu, garanti/teşvik tutarı, durum (talep edildi, onaylandı, takasta). |
| `HzEarningBreakdown` | taban + mesafe + bekleme + teşvik + bahşiş − kesinti = net. Her satır `HzMoney`. |
| `HzDataTable` | AG Grid Community teması; token'lardan beslenir, satır yüksekliği `--hz-row-h`, sayılar sağa yaslı `tnum`. |

### 8.3 Formlar ve hata

- Hata metni alanın altında, tehlike mürekkebiyle, ikonla; neyin yanlış olduğunu ve nasıl düzeltileceğini söyler: "Telefon numarası 10 haneli olmalı (5XX XXX XX XX)".
- Sunucu hata kodları i18n'deki `apiErrors.<KOD>` anahtarından çevrilir (şablon §8.11).

### 8.4 Platform rozeti kuralı

Rozet her zaman "nereden geldi" bilgisidir, "ne durumda" bilgisi değildir. Bu yüzden rozet her kartta aynı yerde (başlık satırının sağında) durur ve durum çipiyle yan yana gelmez.

---

## 9. Harita

### 9.1 Altyapı kararı

Bugün iki platform da CARTO'nun raster karolarını anahtarsız kullanıyor. İki sorun var:

1. **CARTO artık API anahtarı istiyor.** Anahtarsız istekler "API key required" filigranıyla geliyor; anahtarla ticari kullanımda ayda 1 milyon karo ücretsiz, üstü ücretli. Kaba hesap: 1.000 kurye × günde 20 oturum × 30 gün × 15 karo ≈ ayda 9 milyon karo [CARTO basemap-styles README; hesap varsayımsal].
2. **Stok stiller kurye için fazla soluk.** CARTO stilleri "veri katmanının altında yumuşak zemin" olarak tasarlanmış. Stil dosyalarındaki renklerle hesaplanan kontrastlar: Dark Matter'da yol etiketi **1,65:1**, yer adı 3,36:1; Positron ve Voyager'da yol etiketi 4,41:1. Kurye için harita birincil bilgidir; güneş altında 1,65:1 okunmaz.

**Karar:**
- **Hedef (V1):** MapLibre (web: `maplibre-gl`, Flutter: `maplibre_gl`) + Hızla'ya özel vektör stil "Hızla Yol" (açık ve koyu). Stil, token'lardan üretilir: zemin `--hz-bg`, yollar `as-200/as-700`, etiketler **≥ 7:1** ve 2 px hale, POI ve bina gürültüsü azaltılmış. Karo kaynağı: pilotta OpenFreeMap (anahtarsız, kotasız, atıf zorunlu, SLA yok), üretimde Türkiye kesitinin Protomaps PMTiles olarak kendi sunucumuzda barındırılması.
- **Geçiş (MVP):** mevcut `flutter_map` / Leaflet + CARTO raster, **API anahtarıyla**; karo sayısı izlenir. Kurye haritasında Voyager (etiketleri en okunaklı stok stil), panellerde Positron/Dark Matter.
- Mimari Plan'daki D-09 kararı buna göre güncellendi.

### 9.2 Yüzeylere göre harita

| | Kurye | İşletme | Operasyon |
|---|---|---|---|
| Stil (V1) | Hızla Yol, etiketler büyük, sokak adları öncelikli | Hızla Yol, sade | Hızla Yol, en sade (veri katmanı ön planda) |
| Stil (MVP geçişi) | CARTO Voyager / Dark Matter | Positron / Dark Matter | Positron / Dark Matter |
| Mod | Otomatik (06:00–19:00 açık), elle seçilebilir | temayla aynı | temayla aynı |
| İçerik | kendi konumu, alım ve teslim noktası, rota çizgisi | şube, gelen kuryeler ve varış süreleri | bölgeler, tüm kuryeler, teslimatlar, istisnalar |

- Kurye sokak okur, panel kullanıcısı işaret okur; stil yoğunluğu bu yüzden yüzeye göre değişir, renkler değişmez.
- Rota: koyu zeminde `tz-300`, açık zeminde `tz-700`; her ikisinde de 2 px karşıt kenar (casing). Açık zeminde parlak turkuaz (`tz-400`) rota rengi olarak kullanılmaz (Positron üzerinde ~1,6:1).
- Pin: şekil + numara + renk. İşletme kare (A), teslim adresi daire (B); toplu teslimatta B1, B2.
- Kurye konumu: yönü gösteren ok; GPS 30 sn'den eskiyse ok solar ve "Konum eski" etiketi çıkar.
- Alt sayfa (bottom sheet) üç yükseklikte: kapalı (yalnızca hedef ve tahmini varış), yarım, tam.
- Kurye, adım adım yol tarifi için kendi seçtiği navigasyon uygulamasına derin bağlantıyla gönderilir (ayar: Google Haritalar, Yandex Navigasyon, Apple Haritalar). Hızla kendi navigasyonunu yazmaz.
- Bölge poligonu: `--hz-brand-tint` %60 dolgu, `--hz-brand-ink` 1,5 px kenar; pasif bölge kesikli kenar.
- Rota: 4 px `--hz-brand-fill`, koyu temada 2 px koyu kenar ile; toplu (batch) teslimatta duraklar numaralı.
- Harita kartlarında sabit yükseklik verilmez: `clamp(360px, 52vh, 620px)` (şablon §21).
- Tema ve harita için "Otomatik" saat kuralı tektir; bugün web (`tileUrl.js`) ve mobilde (`map_style_provider.dart`) ayrı ayrı yazılı ve senkron tutulması gerekiyor. Yeni yapıda kural `tokens.json`'daki `theme.auto` değerinden üretilir.

---

## 10. Uygulama: tek kaynaktan token

Tutarlılığın teknik garantisi, token'ların tek bir dosyada yaşaması ve iki platforma **üretilmesidir**; elle kopyalanması değil.

```
packages/design-tokens/
├── tokens.json          # W3C Design Tokens (DTCG) biçimi: renk, tipografi, boşluk, köşe, yoğunluk, hareket, tema
├── build.mjs            # tokens.json → iki çıktı
└── README.md
↓ npm run build:tokens
hizla-web-app/src/styles/_tokens.scss          # :root + [data-theme] + [data-density] CSS değişkenleri (--hz-*)
hizla-mobile-app/lib/core/theme/hz_tokens.g.dart # HzTokens ThemeExtension (açık/koyu) + HzType + HzSpace + HzRadius
```

- `*.g.dart` ve `_tokens.scss` üretilen dosyalardır; elle düzenlenmez, başlıklarında `// ÜRETİLDİ — packages/design-tokens/tokens.json'ı düzenle` yazar.
- CI'da `npm run build:tokens && git diff --exit-code` koşar: biri üretilen dosyayı elle değiştirirse ya da üretmeyi unutursa kırmızı olur.
- Yeni kodda sabit HEX yazılmaz (bugünkü cerebrum kuralı korunuyor): web'de `var(--hz-*)`, Flutter'da `context.hz.*`.

### 10.1 Bugünkü token'lardan geçiş

| Web bugün | Mobil bugün | Yeni |
|---|---|---|
| `--bg` | `scaffold` | `--hz-bg` |
| `--surface` | `surface` | `--hz-surface` |
| `--surface-container` | `surfaceContainer` | `--hz-surface-2` |
| `--surface-container-high(est)` | `surfaceContainerHigh(est)` | `--hz-surface-3` |
| `--text` | `onSurface` | `--hz-text` |
| `--text-secondary` (`#9e9e9e`) ve MUI `text.secondary` (`#e5bdb6`) | `onSurfaceVariant` | `--hz-text-2` (iki farklı değer tek değere iner) |
| `--text-muted` | — | `--hz-text-3` |
| `--brand` `#FF4B2B`, `--brand-dark` | `brand`, `gradientStart/End`, `colorScheme.primary` `#FF5637` | `--hz-brand-fill`, `--hz-on-brand`; gradyan kaldırılır |
| `--neon` | `neonCyan` | `--hz-brand-ink` |
| `--error` | `error` | `--hz-danger` |
| `--success` | (yok) | `--hz-success` |
| `--outline` (yarı saydam) | `outline` (opak) | `--hz-line` / `--hz-line-strong` |
| `GlassCard` sabit `rgba(42,42,42,.6)` | `glassBase` | kaldırılır → `HzCard` |
| `yemeksepeti/getir/trendyol` | aynı | `--hz-platform-*` (yalnızca `HzPlatformBadge` içinde) |

Birincil butondaki gradyan kaldırılıyor: düz `--hz-brand-fill`. Gradyan üzerindeki metnin kontrastı bir uçta düşer ve iki platform zaten iki farklı gradyan kullanıyordu.

---

## 11. Ekranlar

Her ekran için düzen, içerik önceliği ve eylemler. Görsel örnekler HTML referansında (§ başındaki bağlantı).

### 11.1 Kurye uygulaması (Flutter)

Alt gezinme 4 sekme, her zaman aynı sırada: **Bugün · Slotlar · Kazanç · Profil**. Destek, her ekranın sağ üstündeki `Lifebuoy` ikonundan ve Profil'den açılır. (Bugün mobilde üç farklı alt gezinme dizisi var: `Dashboard/Slots/Earnings/Profile`, `Wallet/Home/Scan/Chat`, `Drive/Earnings/Quests/Profile`.)

**K1 · Bugün (ana ekran)**
- Üst: tarih, bölge, varlık durumu çipi.
- Ortada: aktif slot kartı ("18:00–22:00 · Kadıköy · başladı, 1 sa 12 dk kaldı") ya da bir sonraki slot.
- Bugünkü kazanç `HzMoney display-xl` + teslimat sayısı + çevrimiçi süre. Dokununca Kazanç'a gider.
- Harita: ekranın üst yarısı; kendi konumu ve bölge sınırı.
- Alt: **Çevrimiçi ol** (tek dokunuş, 64 px, tam genişlik). Çevrimiçiyken: **Mola ver** (ikincil) ve **Çevrimdışı ol**.
- Ağ bağlantısı koparsa üstte ince amber şerit: `CloudSlash` + "Bağlantı yok · son güncelleme 14 sn önce". Aktif teslimatın adresi, telefonu ve kodu çevrimdışı da görünür; "Teslim ettim" gibi olaylar cihazda sıraya alınır ve "Gönderilmedi (2)" rozetiyle gösterilir.
- Slot dışında çevrimiçi olmak, bölgede serbest kapasite varsa mümkün; yoksa buton yerine "Bu saatte serbest kapasite yok, en yakın açık slot 20:00" bilgisi.

**K2 · Teklif (tam ekran alt sayfa)**
- En üstte geri sayım halkası (45 sn) ve **net kazanç** (`display-xl`, ör. ₺86,40). Kabulden önce kazanç gösterilmesi pazarlıksız bir kuraldır.
- Altında kalem dökümü (taban, mesafe, varsa teşvik), toplam mesafe (alım + teslim), tahmini süre.
- İşletme adı + platform rozeti, alım mesafesi; teslim **ilçesi ve mahallesi** (tam adres kabul sonrası).
- Toplu teklifte (batch) iki durak sıralı gösterilir, toplam kazanç tek rakam.
- Eylemler: **Kabul et** (tek dokunuş, 64 px, tam genişlik, başparmak bölgesinde) ve **Geç** (ikincil metin butonu, aralarında 12 px boşluk). "Reddet" kelimesi kullanılmaz; geçmek cezasızdır ve bu, butonun altında yazar: "Geçmek puanını etkilemez." Hiçbir yerde "kabul oranı" gösterilmez.
- Teklif uygulama arka plandayken gelirse yüksek öncelikli bildirim + ses + titreşim; ses 45 sn boyunca tekrar eder.

**K3 · Aktif teslimat**
- Üstte `HzStepper`. Ortada harita (rota). Altta bilgi kartı: şu anki hedef (işletme ya da adres), tam adres `body-l`, kat/daire/tarif notu, işletmenin "teslim alma talimatı".
- Tek birincil eylem, adıma göre değişir: **İşletmeye vardım** → **Teslim aldım** (QR okut ya da PIN gir) → **Adrese vardım** → **Teslim ettim** (müşteri PIN'i ya da kapı fotoğrafı).
- İşletmede bekleme sayacı: "Bekleme 6 dk · 8. dakikadan sonra bekleme ücreti işler". Kurye beklediği sürenin karşılığını görür.
- İkincil: **Yol tarifi** (derin bağlantı), **Ara** (maskeli numara), **Sorun bildir** (müşteri yok, adres yanlış, işletme kapalı, kaza).
- **Hareket hâli:** hız 10 km/sa üstündeyken ekran yalnızca hedef, tahmini varış ve tek büyük buton gösterir; metin girişi ve listeler kilitlenir. Ölçü: tek bakış ≤ 2 sn, bir görev için toplam bakış ≤ 12 sn (NHTSA'nın araç içi cihaz yönergesi; motosiklet için ayrı standart yok, üst sınır olarak alındı).

**K4 · Slotlar**
- Üst: hafta şeridi (Pzt–Paz) ve "Talep penceresi: Pazartesi 12:00'ye kadar açık" bandı.
- Gün listesi: `HzSlotCard`'lar. Her kartta saat, bölge, beklenen yoğunluk (düşük/orta/yüksek), saatlik garanti ve teşvik.
- Talep penceresinde kurye istediği slotları **işaretler**; sıra önemli değildir, yarış yoktur. Pencere kapanınca dağıtım yapılır ve sonuç bildirilir.
- Sekmeler: **Haftam** (onaylı slotlar) · **Talep et** · **Takas** (başkalarının devrettiği slotlar ve benim devrettiklerim).
- Her alınamayan slot için **"Neden alamadım?"**: "Bu slota 14 talep, 9 kapasite vardı. Dağıtım sırası: asgari hak, süreklilik, geçen hafta alamayanlar. Sen 11. sıradaydın; geçen hafta alamadığın için sonraki haftada önceliğin arttı."
- Slot bırakma: kalan süreye göre kural kartı **önceden** gösterilir (> 48 sa serbest · 48–12 sa takasa açılır · < 12 sa mazeretle cezasız).

**K5 · Kazanç**
- Bugün / Bu hafta / Hakediş dönemi segmenti. Üstte `HzMoney display-xl`.
- Teslimat listesi: her satırda saat, işletme, km, net tutar; dokununca `HzEarningBreakdown`.
- **Hedefler** (bugünkü "Görevler"): "Bu hafta 60 teslimat: +₺600 · 42/60". Nadirlik seviyesi (`common…legendary`) ve oyunlaştırma dili kaldırılır; hedef, tutar ve ilerleme yazar.
- Hakediş: dönem, toplam, ödeme tarihi, IBAN'ın son 4 hanesi, durum; kurye adına kesilen e-arşiv faturanın bağlantısı.

**K6 · Profil**
- Kurye puanı ve **bileşenleri** (güvenilirlik: slot katılımı, takas, mazeretsiz bırakma; işletme ve müşteri değerlendirmesi). Hız bileşen değildir. Her bileşenin yanında "nasıl iyileşir".
- Belgeler ve bitiş tarihleri (ehliyet, SRC KURYE, ruhsat, sigorta); 30 gün kala uyarı.
- Ayarlar: tema (Otomatik/Açık/Koyu), harita modu, navigasyon uygulaması, dil, bildirimler.
- Destek talepleri ve **Acil durum** (`Siren`): tek dokunuşla konum paylaşımı ve operasyona öncelikli çağrı.

**K7 · Başvuru** (6 adım, ilerleme çubuğuyla): Kişisel bilgiler → Araç (bisiklet, motosiklet, otomobil) → Belgeler (kimlik, ehliyet, ruhsat, SRC KURYE, adli sicil; her biri ayrı yükleme kartı, fotoğrafın okunabilirliği anında kontrol) → Eğitim (kısa videolar + sınav) → Sözleşme ve KVKK açık rızası (konumun yalnızca çevrimiçiyken toplandığı açıkça yazılı) → İnceleme (beklenen süre ve aşama).

### 11.2 İşletme paneli (web, tablet öncelikli)

Düzen: yatay tablette solda 80 px ikon + etiket rayı; dikey tablette ve telefonda alt gezinme. Rayda: **Teslimatlar · Yeni · Raporlar · Fatura · Ayarlar**.

**İ1 · Teslimatlar (canlı pano)**
- Üst şerit: şube seçici, "Şu an 4 kurye yolda", ortalama varış süresi.
- Yatay tablette **üç sütun**, iş akışı sırasıyla: **Hazırlanıyor** · **Kurye geliyor / burada** · **Yolda**. Bugün teslim edilenler sütunların altında daraltılmış bir şerittir. Dikey tablette ve telefonda sütunlar sekmeye dönüşür.
- Kart: sipariş kodu (`code`, büyük), platform rozeti, müşterinin ilçesi, kurye avatarı + adı + `HzEta` (kartın sağında büyük: "Kurye 3 dk"), bekleme süresi. Kartın sol kenarındaki 4 px şerit teslimat tipini söyler: Hızla kuryesi (marka) ya da gel-al (nötr).
- "Hazırlanıyor" kartında tek dokunuşla **Hazır** (kaydırma yok; eller ıslak ya da yağlı olabilir) ve hazırlık süresi için −5 / +5 dk adımlayıcısı.
- Kurye 8 dakikadan uzun beklerse karta uyarı rozeti eklenir; kart yanıp sönmez.
- Yeni gelen platform siparişi ses + üst bant ile duyurulur ve ses, kart açılana kadar tekrar eder. Ekranın üstünde **kalıcı "Ses kapalı" şeridi** cihaz sesi kısıksa görünür; Ayarlar'da "Sesi dene" butonu vardır. Mutfakta 50–80 cm'den okunması için kart metni en az 18 px, sipariş kodu 24 px.
- Panel kendiliğinden bir durum değiştirirse (ör. şube "meşgul" moduna geçerse) nedeni ve saati yazar: "15:42'de yoğunluk nedeniyle hazırlık süresi 20 dk'ya çıkarıldı."

**İ2 · Yeni teslimat (elle)**
- Tek sütun form: müşteri adresi (adres arama + harita pini), kat/daire/tarif, telefon (isteğe bağlı), sipariş kodu, paket boyutu (30 kg / 300 dm³ üstü uyarısı), hazır olma süresi segmenti (Şimdi · 5 · 10 · 15 · 20 dk), not.
- Gönderilmeden önce **fiyat** gösterilir: "Bu teslimat ₺74,00 (sabit paket ücreti, 3,2 km)".

**İ3 · Teslimat detayı**: zaman çizelgesi, harita, kurye, teslim kanıtı (PIN ya da fotoğraf), değerlendirme (kurye için 5 derece + etiketler), sorun bildir.

**İ4 · Raporlar**: ortalama teslim süresi, ortalama kurye bekleme süresi (işletmenin kendi hızını görmesi için), gecikme oranı, saatlik sipariş dağılımı.

**İ5 · Fatura**: dönem ekstresi; her teslimat bir satır, tek fiyat kalemi. **Karşılaştırma kutusu**: "Bu ay 412 teslimat, Hızla bedeli ₺30.488. Aynı siparişler platform kuryesiyle teslim edilseydi tahmini ek komisyon: ₺X" (platform komisyon oranını işletme kendi girer; Hızla tahmin etmez). Bu kutu Hızla'nın değer iddiasının kanıtıdır.

**İ6 · Ayarlar**: şubeler (adres, ortalama hazırlık süresi, teslim alma talimatı: "arka kapı, zile basın"), platform bağlantıları (Yemeksepeti, Getir, Trendyol Go: bağlı / bağlanmadı), kullanıcılar ve roller.

### 11.3 Operasyon paneli (web, masaüstü)

Düzen: solda 232 px daraltılabilir menü; üstte bölge seçici, genel arama (`Ctrl/⌘ K`: teslimat kodu, kurye, işletme), tema. Menü: **Canlı · Teslimatlar · Kuryeler · Slotlar · İşletmeler · Finans · Destek · Bölgeler**.

**O1 · Canlı**
- Üst KPI şeridi (`HzKpiTile`): aktif kurye / slot kapasitesi, bekleyen teslimat, ortalama atama süresi, gecikme riski taşıyan teslimat. Eşiği aşan kutu tonunu alır.
- Sol %62: harita (bölgeler, kuryeler, teslimatlar). Sağ %38: **İstisna kuyruğu**: yalnızca uyarı ve tehlike tonundaki teslimatlar, en acil üstte. Her satırda neden ("Kurye aranıyor 4 dk", "İşletmede bekleme 11 dk", "Müşteriye ulaşılamıyor") ve tek tık eylem (elle ata, işletmeyi ara, kuryeyle konuş).
- Harita ile kuyruk bağlı: satırın üzerine gelince haritada ilgili işaret vurgulanır.

**O2 · Teslimatlar**: `HzDataTable`; sütunlar: kod, durum çipi, yaş (dk, `tnum`), SLA sayacı, işletme, bölge, kurye, platform, tutar. Filtreler üstte çip olarak. Satıra tıklayınca sağdan çekmece: zaman çizelgesi, elle atama (en yakın 5 müsait kurye ve varış süreleri), iptal, geri alma (ayrı izin).

**O3 · Kuryeler**: liste (avatar, varlık, bölge, bugün teslimat, puan, belge durumu); **Başvurular** sekmesi: belge görüntüleyici yan yana, belge bazında onay/ret ve ret nedeni (zorunlu, kuryeye gösterilir).

**O4 · Slotlar**
- Bölge × saat **ısı haritası**: her hücrede talep tahmini, kapasite, talep edilen, onaylanan. Kapasite tahminin altındaysa uyarı tonu.
- Hücreye tıklayınca: kapasiteyi değiştir, teşvik ekle, yayınla.
- **Adalet paneli**: kuryeler arası slot saati dağılımı (Gini katsayısı), asgari hakkını alamayan kurye sayısı, yeni kuryelerin slot alma oranı, takas başarı oranı, mazeretsiz bırakma oranı. Bu panel, "slot avı" ve "slot silme" şikâyetlerinin (Rapor §5) Hızla'da olmadığının ölçüsüdür.
- Yayınlanmış slotu 72 saatten az kala kaldırmak engellidir; zorunlu durumda sistem tazminatı otomatik yazar ve operatörden gerekçe ister.

**O5 · İşletmeler**: sözleşme, fiyat planı, şubeler, SLA performansı, ödeme durumu.

**O6 · Finans**: fiyat kuralları (işletme fiyatı ve kurye ücreti ayrı sekmelerde), hakediş dönemleri (oluştur, kontrol, onayla, ödeme dosyası), faturalar, defter raporu.

**O7 · Destek**: kurye ve işletme talepleri tek kuyrukta, kategori ve SLA ile; kurye "puan itirazları" ayrı filtre (72 saat içinde insan incelemesi).

**O8 · Bölgeler**: poligon düzenleyici, bölge kapasite varsayılanları, bölgeye bağlı işletme ve kurye sayısı.

### 11.4 Son müşteri takip sayfası (`/t/:token`)

Tek ekran, giriş yok: işletme adı, durum adımı, kuryenin haritadaki konumu (yalnızca kurye yoldayken), tahmini varış, kuryenin adının baş harfi ve aracı. Kuryenin telefonu, fotoğrafı ya da tam adı gösterilmez. Teslimden 30 dakika sonra bağlantı geçersiz olur.

---

## 12. Etik tasarım ilkeleri (pazarlıksız)

Bu ilkeler Rapor §5'teki kurye şikâyetlerinden çıkar; her biri bir ürün kuralıdır, yalnızca bir slogan değil.

1. **Kazanç önce.** Her teklifte kabulden önce net kazanç TL olarak görünür.
2. **Geçmek cezasız.** Teklifi geçmek puanı, slot önceliğini ya da kazancı etkilemez. Kabul oranı hiçbir ekranda gösterilmez ve hiçbir skora girmez.
3. **Hız ödüllendirilmez.** Teslimat süresi kuryeye geri sayım olarak gösterilmez; hız puan bileşeni değildir. Tahmini varış güvenli sürüş tamponuyla hesaplanır.
4. **Slotta yarış yok.** Talep penceresi + açık kurallı dağıtım; "Neden alamadım?" her zaman cevaplanır. Yayınlanmış slot habersiz silinmez.
5. **Her karar açıklanır, her karara itiraz edilir.** Puan değişimi, slot reddi, hesap kısıtlaması: gerekçe yazılı, itiraz butonu yanında, insan incelemesi 72 saat içinde.
6. **Bekleme ödenir, iptal ödenir.** İşletmede bekleme ve yoldayken iptal kurye kazancına kalem olarak yazılır.
7. **Karanlık desen yok.** Yapay aciliyet ("son 2 slot!"), gizli ücret, kampanyaya zorlama yok. İşletme faturasında her kalem ayrı yazılır (Ticaret Bakanlığı Genelge 2026/1'in platformlara getirdiği ilke Hızla'da varsayılandır).
8. **Konum yalnızca çevrimiçiyken.** Çevrimdışında uygulama konum göndermez; bu, başvuru ekranında ve ayarlarda açıkça yazar.

---

## 13. Ses ve terimler

### 13.1 Hitap

- **Kurye:** "sen". Kısa, eşit, saygılı. "Teslim aldın. Adres 2,1 km."
- **İşletme:** "siz". "Kurye 4 dakika içinde şubenizde."
- **Operasyon:** nötr ve kısa; fiil önce. "Kuryeyi ata", "İşletmeyi ara".
- Ünlem, emoji ve "Harika!" gibi abartılar kullanılmaz. Hata mesajı özür dilemez, neyin yanlış olduğunu ve ne yapılacağını söyler.

### 13.2 Sözlük (tüm yüzeylerde zorunlu)

| Kullan | Kullanma | Not |
|---|---|---|
| **Kurye** | Pilot, Sürücü, Driver | Kodda `courier`; bugün web'de "Sürücü", mobilde "Pilot" geçiyor |
| **Teslimat** | Mission, Görev, Sipariş (kurye bağlamında) | Sipariş müşterinin platformdaki siparişidir; teslimat Hızla'nın işidir |
| **Sipariş** | — | Yalnızca işletme bağlamında, platform siparişi için |
| **Teklif** | Gelen sipariş, Görev | Kuryeye önerilen teslimat |
| **Kabul et / Geç** | Reddet | |
| **Slot** | Vardiya, Shift | Kuryelerin kullandığı kelime |
| **Talep penceresi** | — | Slotların istendiği dönem |
| **Takas** | Devir | Slotun başka kuryeye verilmesi |
| **Kazanç** | Earnings, Gelir | Kuryenin hak ettiği tutar |
| **Hakediş** | Payout, Maaş | Dönemlik kazanç ve ödeme |
| **Hedef** | Görev, Quest | Teşvik |
| **İşletme** | Restoran, Satıcı, Vendor | Restoran dışı işletmeler de var |
| **Şube** | Mağaza, Branch | |
| **Bölge** | Zone | |
| **Bekleme** | — | İşletmede geçen ödenen süre |
| **Çevrimdışı** | — | Kurye iş almıyor (varlık durumu) |
| **Bağlantı yok** | Çevrimdışı (ağ için) | İnternet bağlantısı koptu; "çevrimdışı" kelimesi ağ için kullanılmaz |
| **Tahmini varış** | ETA | Kısaltma yalnızca operasyon tablolarında |
| **Teslim kanıtı** | POD | |

### 13.3 Biçimler

Tüm biçimlendirme yerel ayar fonksiyonlarıyla (`Intl` / Dart `intl`, `tr-TR`) yapılır, elle yazılmaz.

| Tür | Biçim |
|---|---|
| Para | `₺1.284,50` (CLDR `tr`), negatif `−₺42,00` |
| Mesafe | `850 m`, `1,8 km` |
| Süre | `14 dk`, `1 sa 12 dk` |
| Saat | `21:47` |
| Tarih | `6 Eki Pzt`, uzun: `6 Ekim 2026 Pazartesi` |
| Telefon | `0532 123 45 67`; kuryeye ve işletmeye müşteri numarası maskeli |
| Plaka | `34 HZL 482` (mono) |
| Sipariş kodu | `HZ-7F3K` (mono, karışan harfler alfabeden çıkarılır: 0, O, 1, I, L) |

---

## 14. Erişilebilirlik kontrol listesi

- [ ] Tüm metin çiftleri §2.3 tablosundaki eşikleri geçiyor; yeni renk çifti eklenince tabloya eklenir.
- [ ] Durum hiçbir zaman yalnızca renkle anlatılmıyor (ikon + metin).
- [ ] Dokunma hedefleri yoğunluk asgarisinin altında değil (kurye 56, işletme 48, operasyon 32).
- [ ] Klavye ile tüm panel kullanılabiliyor; odak halkası görünür (`--hz-focus`, 2 px + 2 px boşluk).
- [ ] Flutter `textScaler` 1,0–2,0 arasında kurye ekranları bozulmuyor; teklif ekranında rakamlar en fazla 1,6'ya ölçeklenir, metin sarar.
- [ ] Ekran okuyucu etiketleri: `HzMoney` "seksen altı lira kırk kuruş", `HzEta` "on iki dakika, saat yirmi bir kırk yedi".
- [ ] `prefers-reduced-motion` ve `MediaQuery.disableAnimations` uygulanıyor.
- [ ] Web `<html lang="tr">`; büyük harf dönüşümleri Türkçe kurala uyuyor.
- [ ] Hata mesajları alanla ilişkilendirilmiş (`aria-describedby`).

---

## 15. Bu dokümanın bakımı

- Token değişikliği yalnızca `packages/design-tokens/tokens.json`'da yapılır; bu doküman ve HTML referansı aynı PR'da güncellenir.
- Yeni bileşen önce §8 tablosuna, sonra koda girer.
