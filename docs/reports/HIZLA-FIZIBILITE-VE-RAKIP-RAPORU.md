# Hızla — Fizibilite ve Rakip Analizi Raporu

> **Sürüm 1.0 · 2026-10-06** · Kapsam: Türkiye, yemek ve hızlı teslimat kurye operasyonu
> Kardeş dokümanlar: [Tasarım Sistemi](../design/HIZLA-TASARIM-SISTEMI.md) · [Mimari Geçiş Planı](../ARCHITECTURE-PLAN.md)
> Ham araştırma notları ve tam kaynakça: [`docs/research/`](../research/)

---

## 0. Yönetici özeti

**Karar: Koşullu olumlu.** Hızla, "işletmenin kendi kuryesi gibi çalışan, birden fazla işletmenin paylaştığı, adil kurye ağı + bu ağı yöneten yazılım" olarak uygulanabilir. Saf yazılım (SaaS) ya da saf paket servis firması (3PL) olarak tek başına zayıf; ikisinin birleşimi (hibrit) olarak, dar bir bölgede, yüksek sepetli zincir işletmelerle başlarsa anlamlı.

**Neden şimdi:**
1. **Pazar büyük ve büyüyor.** Motokuryeyle yapılan "hızlı ticaret" 2025'te 388,7 milyar TL'ye ulaştı (+%55,6); bunun %69,5'i yemek, yani yaklaşık 270 milyar TL [Ticaret Bakanlığı verisi, haber aktarımı].
2. **Pazar iki bloğa toplanıyor.** Uber, Trendyol Go'yu (2025) ve GetirYemek'i (2026) aldı; Delivery Hero'ya teklif verdi ve Yemeksepeti SSW Partners'a devrediliyor (kapanış 2027 ikinci yarı). İlk üç oyuncu pazarın yaklaşık %90'ını tutuyor. İşletmeler tek bir platforma ve onun kurye filosuna bağımlı kalmaktan çekiniyor.
3. **İşletmeler komisyondan şikâyetçi ve düzenleyici onların yanında.** Platform kuryesiyle komisyon %32'ye (Yemeksepeti vale: %12 iletim + %20 dağıtım) ve bazı beyanlarda %40'a çıkıyor; kendi kuryesiyle %12 civarında. TÜRES, "1.000 TL'lik siparişin 531 TL'si restoranda kalıyor" diyor. Ticaret Bakanlığı Genelge 2026/1 (1 Nisan 2026'dan beri) ücretlerin kalem kalem gösterilmesini ve kampanyaya zorlamanın yasaklanmasını getirdi.
4. **Kuryeler mevcut sistemlere karşı örgütleniyor.** Yemeksepeti'nin slot sistemi (seviyeye göre Çarşamba/Perşembe kademeli açılış, puan–slot kısır döngüsü, Eskişehir'de slotların yaklaşık %60'ının silinmesi) ve bonusa bağlı "zam" Ocak 2026'da yaklaşık 40 ilde üç günlük kontak kapatmaya yol açtı. Adil ve açıklanabilir bir kurye modeli, kurye bulmakta gerçek bir avantaj.

**Neden koşullu:**
1. **Marj ince.** Paket başı 105 TL fiyat ve 75 TL ortalama kurye ücretiyle katkı 26 TL/paket (genel gider öncesi). Pilot ölçeğinde (aylık ~296 bin TL sabit gider) başabaş için günde **~420 teslimat** gerekiyor.
2. **Adil kurye ücreti ile işletme fiyatı arasındaki alan dar.** Paket başı 75 TL ve saatte 2,5 paket verimde kuryenin yakıt ve bakım sonrası saatlik kazancı ~144 TL; bu, Bağ-Kur ve vergi **öncesi** net asgari ücretin saatlik karşılığına eşit. Adil ücret ancak **yoğunluk ve toplu teslimat (batching)** ile saatte 2,5–3 paketin üstüne çıkılarak sağlanabilir. Yazılımın asıl işi budur.
3. **İşletmenin tasarrufu sepet tutarına bağlı.** Hızla 105 TL alırsa işletme, platform kuryesine göre ancak **525 TL'nin üstündeki** sepetlerde kazanır. Hedef müşteri yüksek sepetli zincirlerdir.
4. **Dış bağımlılıklar çözülmemiş:** platform API erişimi (Yemeksepeti belgeleri açık ama kimlik bilgisi onayla; Getir, Trendyol ve Migros koşulları doğrulanamadı), esnaf kurye modelinin muvazaa riski, BTK yetkilendirmesinin gerekip gerekmediği.

**Önerilen yol:** 12 haftalık pilot, tek bölge (İstanbul'da iki komşu yoğun ilçe), 15–20 zincir şube, 25–30 kurye. Altı karar kapısı (§11) geçilirse ikinci bölgeye ve yazılımın filo işletmecilerine satışına geçilir.

**Hızla'nın farkı tek cümlede:** *Platformdan bağımsız, işletmeye sabit ve öngörülebilir paket fiyatı, kuryeye kabulden önce görünen kazanç ve yarışsız slot.*

---

## 1. Kapsam, yöntem ve güven düzeyi

- **Kaynaklar:** üç araştırma ajanı (pazar ve rakipler, kurye deneyimi, fizibilite ve B2B yazılım) yaklaşık 140 web araması yaptı; bir dördüncü ajan kod tabanını inceledi. Ham notlar ve tam kaynakça `docs/research/` altında.
- **Önemli sınır:** Bu ortamda web sayfalarının gövdesi açılamadı; bulgular arama sonuçlarının özetlerinden derlendi. Rakamlar kaynak URL'leriyle eşleştirildi ama **birebir sayfa okunarak teyit edilmedi**. Ortak arama bütçesi bittiği için bazı konular (müşteri şikâyeti istatistikleri, B2B paket servis fiyat listeleri, Getir/Trendyol/Migros API koşulları, Yargıtay muvazaa kararları) boş kaldı.
- **Güven etiketleri:** **[Y]** birden çok bağımsız kaynakta tutarlı · **[O]** tek güvenilir kaynak ya da kısmen tutarlı · **[D]** blog, SEO sitesi ya da çelişkili kaynaklar · **[T]** bu raporun varsayımı ya da çıkarımı · **[H]** kaynaktaki rakamlardan hesap.
- Yatırım ya da sözleşme kararından önce §13'teki doğrulama listesi tamamlanmalı.

---

## 2. Pazar

### 2.1 Büyüklük

| Gösterge | Değer | Yıl | Güven |
|---|---|---|---|
| Hızlı ticaret hacmi (motokuryeyle anlık/planlı teslimat, yemek + market) | 388,7 milyar TL (+%55,6) | 2025 | [O] Ticaret Bakanlığı "E-Ticaretin Görünümü" verisi, haber aktarımı |
| Aynısı | 249,8 milyar TL (+%98,1) | 2024 | [O] |
| Yemek payı | %69,5 (2024: %66,2) | 2025 | [O] |
| **Yemek hacmi** | **≈ 270 milyar TL** | 2025 | [H] 388,7 × 0,695 |
| Hızlı ticaretin e-ticaretteki payı | %8,5 (2019: %1,6) | 2025 | [O] |
| En büyük kalemler | hamburger 26,7 · pizza 17,0 · tavuk döner 12,6 · lahmacun 6,7 milyar TL | 2025 | [O] |
| Yemek uygulaması kullanıcısı | 31,1 M (2023) → 34,8 M (2024) → 38 M (2028 tahmin) | — | [D] |
| Yemeksepeti | 13,2 M aktif kullanıcı, 135 bin+ iş ortağı, 81 il | 2025–26 | [O] şirket açıklaması |
| Trendyol Go | 200 M+ sipariş, ~2 milyar $ brüt hacim, 90 bin+ işletme, 19 bin kurye | 2024 | [Y] |
| GetirYemek | >1 milyar $ brüt hacim (+%50) | 2025 | [O] |

Not: IMARC gibi araştırma şirketleri pazarı 2,1 milyar $ gösteriyor; bu, Bakanlık verisinin yaklaşık üçte biri. Fark büyük olasılıkla tanımdan kaynaklanıyor (brüt sipariş hacmi ile platform geliri) [T]. Bu raporda brüt hacim için Bakanlık verisi esas alındı. TL rakamları yüksek enflasyonu içerir; reel büyüme nominalin belirgin altındadır [T].

**Hızla için hizmet edilebilir pazar (kaba):** Hacmin tamamı Hızla'nın değil; Hızla'nın pazarı "platform siparişini kendi kuryesiyle (ya da üçüncü taraf kuryeyle) teslim etmek isteyen işletmelerin teslimat sayısı" × paket fiyatıdır. Yalnızca İstanbul'un yoğun ilçelerinde, sepeti 525 TL'nin üstündeki zincir şubeler hedeflendiğinde bile pilotun gerektirdiği günlük 420–750 teslimat, pazarın çok küçük bir kesridir; darboğaz talep değil, **operasyonel yoğunluk ve kurye arzıdır** [T].

### 2.2 Konsolidasyon zaman çizelgesi

| Tarih | Olay | Güven |
|---|---|---|
| 2015 | Delivery Hero, Yemeksepeti'ni 589 M $'a aldı | [O] |
| 2024 Nisan–Haziran | Getir İngiltere, Almanya, Hollanda ve ABD'den çekildi; Mubadala 250 M $ ile kontrolü aldı; şirket ikiye bölündü | [Y] |
| 2025 Mayıs | Uber, Trendyol Go'nun %85'ini ~700 M $'a aldı (kurumsal değer 824 M $); Rekabet Kurulu ~10 gün içinde izin verdi | [Y] |
| 2026 Şubat | Uber, GetirYemek'i 335 M $ nakitle aldı; market/su kolunda %15 için 100 M $ | [Y] |
| 2026 Mart | Ticaret Bakanlığı Genelge 2026/1 (hizmet bedellerinde şeffaflık), uyum 1 Nisan 2026 | [Y] |
| 2026 Haziran | Rekabet Kurulu Uber–Getir'e taahhütlerle izin; 500 M $ Türkiye yatırım taahhüdü | [O] |
| 2026 Temmuz | Uber, Delivery Hero'ya hisse başına 41,50 € teklif (~14,8 milyar $); Yemeksepeti dahil 14 pazar ~1,6 milyar $'a SSW Partners'a (kapanış 2027 H2 hedefi) | [O] |

**Sonuç [T]:** 2027 sonrası Türkiye'de iki blok olması muhtemel: Uber (Trendyol Go + Getir) ve SSW (Yemeksepeti). Bu, işletmelerin pazarlık gücünü azaltabilir ve **platformdan bağımsız teslimat kapasitesi** için talebi artırabilir. Aynı zamanda platform API'lerinin (Trendyol Go ve Getir'in Uber çatısında birleşmesiyle) değişme riski yüksektir; Hızla'nın entegrasyon katmanı adaptör deseniyle yazılmalıdır (Mimari Plan §9).

### 2.3 Düzenleme ortamı

| Düzenleme | İçerik | Hızla'ya etkisi | Güven |
|---|---|---|---|
| **Ticaret Bakanlığı Genelge 2026/1** (1 Nisan 2026) | Asli hizmetler (sipariş, teslimat, ödeme altyapısı) için ayrıca bedel alınamaz; işletme kampanya ve reklama zorlanamaz; tüm kesintiler panelde kalem kalem; indirimli satışta komisyonun tabanı kurala bağlandı | İşletme kendi maliyetini daha net görüyor → alternatif teslimat kıyaslanabilir hâle geliyor. Hızla faturası aynı şeffaflığı varsayılan yapar | [Y] |
| **Rekabet Kurulu – Yemeksepeti** | 2016'da 427.977 TL ceza; 2021'de taahhütle kapanış (zorunlu asgari sepet, zorunlu Joker, en çok kayırılan müşteri şartı); 7 Mart 2024'te zorunlu platform kuryesi / 5 km sınırı / yüksek komisyon iddiasıyla soruşturma, sonuçta ceza yok; bir kaynağa göre taahhütlerle vale fiyatı maliyete bağlandı | "Kendi kuryesiyle teslim etme hakkı" gündemde; platformların bunu fiilen kısıtlaması risk taşıyor | [O] |
| **Karayolu Taşıma Yönetmeliği değişikliği** (RG 15 Mayıs 2025) | "Kurye işletmeciliği" tanımı; kurye gönderisi tek parçada ≤30 kg ve/veya ≤300 dm³; P1/P2 yetki belgeleri; Kurye Faaliyet Belgesi; reflektif yelekte "KURYE" ibaresi + firma U-NET numarası | Hızla bir kurye işletmecisi olarak yetki belgesi almalı; ürün yelek/U-NET ve gönderi boyutu kontrollerini içermeli | [Y] |
| **SRC KURYE belgesi** (RG 29 Ocak 2026, sayı 33152) | Motosiklet/moped kuryeler için mesleki yeterlilik; denetimde 15 Mayıs 2026'dan itibaren aranıyor; platform kuryeleri dahil | Kurye başvurusunda zorunlu belge (Tasarım K7); belge bitiş takibi | [O] (eğitim süresi ve ceza tutarları [D]) |
| **BTK / posta mevzuatı** (RG 8 Mart 2025) | Dijital platformlardaki hızlı teslimat posta sektörüne alındı; haberlere göre kurye çalışma saatleri bildirilecek | Hızla'nın BTK yetkisine ihtiyacı olup olmadığı **açık soru** → hukuk görüşü şart. Slot ve giriş-çıkış kayıtları düzenleyici veri olabilir: dışa aktarılabilir tutulmalı | [O] |
| **KVKK** | Konum ve müşteri verisi kişisel veri | Konum yalnızca çevrimiçiyken; saklama süresi; veri işleme sözleşmesi (işletme = veri sorumlusu, Hızla = veri işleyen) | genel bilgi |

---

## 3. Rakip analizi

Hızla'nın rakipleri tek bir grupta değil, dört ayrı grupta:

### 3.1 Tüketici platformları ve kurye filoları

| | **Yemeksepeti** | **Trendyol Go / Trendyol Yemek** | **GetirYemek** | **Migros Yemek** |
|---|---|---|---|---|
| Sahip | Delivery Hero → SSW Partners (2027 H2) | Uber %85, Trendyol %15 | Uber (yemek); Mubadala (diğer) | Migros |
| Ölçek | 13,2 M aktif kullanıcı, 135 bin+ iş ortağı; pazar payı %34–42 [O] | 200 M+ sipariş (2024), 90 bin+ işletme, 19 bin kurye [Y] | >1 milyar $ brüt hacim (2025), 60 bin+ restoran (2024) [O] | doğrulanamadı |
| Kurye modeli | Yemeksepeti Express: ağırlıklı **esnaf kurye + slot sistemi** (seviyeye göre kademeli açılış) [O]; işletmenin kendi kuryesi seçeneği | Esnaf/serbest kurye, slot zorunluluğu yok [D]; işletmenin kendi kuryesi seçeneği | Esnaf + bordrolu karma [D]; kendi kurye seçeneği | Vardiyalı/taşeron izlenimi [D] |
| İşletme komisyonu: kendi kuryesiyle | ~%12 (KDV hariç) [D] | %10'un altından %25'e kadar, kaynaklar çelişkili [D] | %10–20 [D] | doğrulanamadı |
| İşletme komisyonu: platform kuryesiyle | %12 iletim + %20 dağıtım = %32 [D]; işletme beyanı ~%40 [D] | %22–38; "Semtin Yıldızları" programına göre [D] | %20–35 [D] | doğrulanamadı |
| Kurye kazancı (2026) | %32 zam duyurusu (12 Ocak 2026); kuryelere göre cebe %10–14 yansıdı [O] | km tarifesi 6,5–7,8 TL/km (İstanbul); çoklu sipariş 25,5–50 TL; saatlik açılış 51–100 TL [O] | Birleşik paketin ilki 88 TL, sonrakiler 60,5 TL [D] | 33–70 bin TL/ay aralığı [D] |
| Son hamleler | Ypro aboneliği (27 Nisan 2026, sınırsız ücretsiz teslimat, yıllıkta ~112 TL/ay); yapay zekâ tüketici tarafında (sesli komut, görsel arama) | Uber entegrasyonu; Getir ile birleşme planı | Uber'e satış; "ertesi gün hakediş" söylemi | — |
| İşletme şikâyetleri | yüksek kesinti, zorunlu kurye iddiası, eksik/geç ödeme | reklam vermeyince görünürlük düşüşü, flaş kampanya koşulları, kurye kaynaklı iptal maliyetinin işletmeye yazılması | — | — |
| Kurye şikâyetleri | slot avı, slot silme, opak puan, bonusa bağlı zam, algoritmik hız baskısı | — | — | — |

**Okuma:** Platformların hepsi "işletmenin kendi kuryesi" seçeneğini sunuyor ve bu seçenekte komisyon 10–25 puan düşüyor. Hızla tam olarak bu boşluğa oturuyor: **işletme kendi kuryesi seçeneğini kullanır, kuryeyi Hızla sağlar.** Platformla doğrudan rekabet etmez; platformun zaten izin verdiği bir modeli kolaylaştırır.

**Ana tehdit:** Platformlar (özellikle Uber çatısı) kendi kurye filosunu daha ucuz sunarak ya da "kendi kuryesi" seçeneğinin koşullarını değiştirerek bu boşluğu daraltabilir. Rekabet Kurulu'nun 2024 soruşturması bu davranışın denetlendiğini gösteriyor, ama ceza çıkmadı [O].

### 3.2 Kurye platformları (kurye tarafındaki rakipler)

Kuryeler çok platformlu çalışıyor (multi-homing); Hızla'nın kurye bulmak için rekabet ettiği yerler:

| Platform | Model | Kuryeye ne vaat ediyor | Zayıf nokta |
|---|---|---|---|
| Yemeksepeti Express | esnaf + slot + 7 seviye | düzenli iş, ekipman | slot yarışı, opak puan, bonusa bağlı ücret, iletişimsizlik [O] |
| Trendyol Go | esnaf, serbest giriş | esneklik, km tarifesi | gelir öngörülemezliği [D] |
| Getir | esnaf + bordrolu | bordrolu güvence | düşük maaş aralığı [D] |
| Vigo | 8/10/12 saatlik vardiya, sağlık sigortası | güvence | esneklik yok [D] |
| TheKurye | açık artırma, slot yok | serbestlik | ücret baskısı [D] |
| 13+ diğer platform | | | |

### 3.3 Yerel yazılım muadilleri (işletme tarafındaki rakipler)

| Ürün | Ne yapıyor | Fiyat | Kurye operasyonu | Güven |
|---|---|---|---|---|
| **Adisyo** | bulut POS; kurye takip | Lite 1.040, Pro 2.150 TL/ay | takip var; aggregator detayı bilinmiyor | [O] |
| **Simpra** | bulut restoran otomasyonu | bulunamadı | Yemeksepeti, Getir, Trendyol entegrasyonu; paket servis | [O] |
| **YemekPOS** | otomasyon, franchise | bulunamadı | "kurye entegrasyonları" iddiası | [D] |
| **Kolay Restoran** | POS + paket servis | 540 TL/ay (tarih belirsiz) | Yemeksepeti entegrasyonu | [D] |
| **SambaPOS** | POS | bulunamadı | Getir entegrasyonu | [O] |
| **SepetTakip** | kurye ve paket servis dijitalleştirme | bulunamadı | 4 platform entegrasyonu, canlı konum, performans raporu | [O] |
| **Hemen Yolda** | kurye takip ve saha yönetimi (2017) | sipariş sayısına göre (2018) | tek sayfadan kurye ve paket takibi, müşteriye harita | [O]; Sodexo'dan 550 bin $ (2019) |
| **Loji Team** | akıllı kurye yönetimi | bulunamadı | otomatik atama, paket birleştirme | [D] "1.000+ kurye" iddiası |
| **Sipariş Ustası** | çoklu platform panel yönetimi, hakediş/mutabakat | bulunamadı | kurye değil, panel | [O] |

**Okuma:** POS firmaları kurye **takibini** bir özellik olarak paketliyor; ama hiçbiri (doğrulanabildiği kadarıyla) **kurye arzını** sağlamıyor. Kurye takip uygulamaları işletmenin zaten kuryesi olduğunu varsayıyor. Hızla'nın farkı yazılımın yanında kuryeyi de getirmesi ve bir kuryeyi birden fazla işletme arasında paylaştırarak verimi yükseltmesi.

### 3.4 Global dispatch yazılımları (fiyat çıpası)

| Ürün | Model | Fiyat (2025–26) | Güven |
|---|---|---|---|
| Onfleet | aylık + görev | 619 $/ay (2.500 görev) – 3.099 $/ay (10.000+) | [O] |
| Tookan | aylık + görev | 99–299 $/ay (1.000–6.000 görev) | [O] |
| Shipday | aylık + sipariş; 3. taraf teslimatı teslimat başı | 39–299 $/ay (plan adları tutarsız) | [D] |
| Track-POD | sürücü başı | 49–99 $/sürücü/ay | [O] |
| Detrack | sürücü başı | 29–39 $/sürücü/ay | [O] |
| Spoke (Circuit) | aylık + durak | 125–1.000 $/ay | [O] |

Teslimat başına yazılım maliyeti ~0,05–0,5 $ [H]. Bu ürünlerde vardiya/slot yönetimi, esnaf kurye hakedişi (paket + km + saat + bonus), TL faturalama ve Türk platformlarıyla entegrasyon **yok ya da doğrulanamadı**.

### 3.5 Konum haritası

```
                     Kurye ARZI sağlar
                            ▲
   Platform filoları        │         ● Hızla (hedef)
   (YS Express, TGo, Getir) │           platformdan bağımsız,
   ● platforma bağlı         │           kurye + yazılım
                            │
   Tek platform ◀───────────┼───────────▶ Platformdan bağımsız
                            │
                            │   ● Hemen Yolda, Loji Team, SepetTakip
                            │   ● POS'lar (Adisyo, Simpra, YemekPOS)
                            │   ● Onfleet, Tookan, Shipday
                            ▼
                     Yalnızca YAZILIM
```

Sağ üst köşe boş: platformdan bağımsız **ve** kurye sağlayan bir oyuncu (doğrulanabildiği kadarıyla) yok. Bölgesel paket servis firmaları bu köşede olabilir ama bu oturumda doğrulanmış veri bulunamadı [§13].

---

## 4. Sahadan sesler

### 4.1 Kuryeler

Kullanıcının gözlemi doğrulandı: Yemeksepeti'nin esnek (esnaf) kurye kolu **slot sistemiyle** çalışıyor ve şikâyetlerin merkezinde bu sistem var.

**Slot sistemi nasıl işliyor** (Yemeksepeti Express SSS ve haberler, [O]):
- Slotlar bölgedeki paket sayısı ve güzergâha göre otomatik üretiliyor.
- Gelecek haftanın slotları seviyeye göre kademeli görünüyor: **Çarşamba 1-2-3-7. seviyeler, Perşembe 4-5-6. seviyeler**. Yani erken gören iyi slotu alıyor; "slot avı" tasarımın parçası.
- 7 seviyeli puan sistemi; paket sayısı, çalışılan saat aralığı ve **teslimat hızı** belirliyor.
- Ödeme haftalık, e-fatura karşılığı.

**Şikâyet temaları:**

| # | Tema | Kanıt |
|---|---|---|
| 1 | **Kısır döngü:** slot bulamayan paket taşıyamıyor → puanı düşüyor → daha geç ve daha az slot görüyor | Eskişehir kuryeleri [O] |
| 2 | **Slot silme:** Eskişehir'de slotların yaklaşık %60'ı kaldırıldı, kuryeler iki hafta çalışamadı, muhatap bulamadı | [O] |
| 3 | **Bonusa bağlı "zam":** 12 Ocak 2026'daki %32'lik artış cebe %10–14 yansıdı; düşük bonus kademeleri kalktı; haftada 200 paket atan için artış %24,6 (Motokurye İşçileri Derneği) | [O] |
| 4 | **Algoritmik hız baskısı:** "Bu baskının nedeni tamamen algoritma. Siparişi mümkün olan en kısa sürede teslim etmemiz dayatılıyor." (Seyhun Kavut, Motokurye İşçileri Derneği) | [O] |
| 5 | **Opak puan ve itirazsızlık** | Şikâyetvar başlıkları [D] |
| 6 | **Destek yok** | Eskişehir, Bursa [O/D] |
| 7 | **Uzun mesafe, ağır yük** | Ekim 2025 talepleri: 6 km üstü siparişi kabul etmeme, ağır yük, paket ücreti 42 TL [O] |
| 8 | **Kaza ve güvenlik** | İSİG: 76 kurye ölümü (yıl belirsiz) [D] |
| 9 | **Fatura, Bağ-Kur, muhasebe yükü** | esnaf modelin doğası [O] |

**Talep listesi (Ocak 2026 eylemleri):** şeffaf ve sabit paket ücreti; erişilebilir bonus; "yapay zekâ hesabı" yerine gerçek maliyete dayalı mesafe ücreti; kötü havada ücretli izin; tam iş sağlığı ve güvenliği; kurye temsilcilerinin karar süreçlerine katılımı [O].

**Eylem takvimi:** 2022'de 26+ günlük Yemeksepeti eylemleri; Ekim 2025'te Denizli ve İstanbul'da toplantı ve eylemler; **18–20 Ocak 2026'da ~40 ilde üç günlük kontak/slot kapatma** [Y].

**Çıkarım [T]:** Kurye tarafındaki şikâyetlerin çoğu ücretin seviyesinden önce **kuralların belirsizliğinden ve tek taraflılığından** kaynaklanıyor. Hızla için bu, ücretin yanında *kural tasarımıyla* da rekabet edilebileceği anlamına geliyor; kural tasarımı ise yazılımın işi.

### 4.2 İşletmeler

| Tema | Kanıt |
|---|---|
| Komisyon yükü | TÜRES: komisyon %40'a varıyor; "1.000 TL siparişin 531 TL'si restoranda kalıyor"; 81 ilde doğrudan siparişe %20 indirim kampanyası ve "300 bin işletme sistemden çıkar" uyarısı; kendi platform planı (~2025 sonu) [O] |
| Zorunlu platform kuryesi | Şikâyetvar; 2024 Rekabet soruşturmasının konusu [O] |
| Kampanya maliyetinin işletmeye yüklenmesi | Delivery Hero, Türkiye'deki 2025 H2 kârlılığını kısmen "restoran finanslı kampanyalar"a bağladı [O] |
| Görünürlük için reklam baskısı | Trendyol Yemek şikâyetleri [D] |
| Kurye kaynaklı iptalin işletmeye yazılması | Trendyol Yemek şikâyetleri [D] |
| Hakediş gecikmesi | Yemeksepeti şikâyetleri; GetirYemek'in "ertesi gün hakediş"i pazarlama unsuru yapması [O] |
| Platform–restoran fiyat farkı | "Platformda 110 TL, restoranda 145 TL" manşeti (yalnızca başlık) [D] |

### 4.3 Son müşteriler

Bu oturumda sayısal veri (Şikâyetvar hacmi, mağaza puanları) **toplanamadı** [§13]. Dolaylı göstergeler: Genelge 2026/1'in "gizli ücret" algısını hedef alması ve Yemeksepeti'nin sınırsız ücretsiz teslimat aboneliği (Ypro). Müşteri için Hızla'nın görünür tek yüzü takip bağlantısıdır; teslimatın zamanında ve sıcak gelmesi Hızla'nın müşteriye karşı tek vaadidir.

---

## 5. Fırsat ve farklılaşma

### 5.1 Acı noktası → rakiplerin yaptığı → Hızla'nın yapacağı

| Acı noktası | Rakiplerde | Hızla'da | Nasıl ölçülür |
|---|---|---|---|
| **İşletme:** platform kuryesiyle %32–40 kesinti | Komisyona gömülü teslimat bedeli | Sabit paket fiyatı (ör. 105 TL), sepetten bağımsız; faturada tek kalem | İşletme başına aylık tasarruf (İşletme paneli "karşılaştırma kutusu") |
| **İşletme:** tek platform kuryesine bağımlılık | Her platformun kendi filosu | Tüm platform siparişleri tek kurye havuzunda, tek panelde | Platform başına teslimat dağılımı |
| **İşletme:** kendi kuryesini tutmak pahalı ve boş saat çok | Bordrolu kuryenin işverene aylık maliyeti ~40,2 bin TL + araç giderleri (~55,6 bin TL toplam) | Kurye birden fazla işletme arasında paylaşılır, verim yükselir | Kurye başına saatlik paket |
| **İşletme:** kurye ne zaman gelecek belli değil | Platform takibi | "Hazır" butonu + kuryenin hazır olma anına göre zamanlanması + canlı varış süresi | Kuryenin işletmede ortalama bekleme süresi |
| **Kurye:** slot avı ve silme | Seviyeye göre kademeli açılış; habersiz silme | Talep penceresi + açık kurallı dağıtım; yayınlanmış slot 72 saatten az kala silinemez, silinirse tazminat | Gini katsayısı; asgari hakkını alamayan kurye sayısı |
| **Kurye:** puan–slot kısır döngüsü | Puan slot erişimini belirliyor | Slot önceliği yalnızca güvenilirliğe (katılım, takas) bağlı; hız ve kabul oranı girmez | Yeni kuryelerin slot alma oranı |
| **Kurye:** kazanç öngörülemiyor | Bonus kademeleri, "yapay zekâ" mesafe hesabı | Kabulden önce net kazanç TL; açık tarife kartı; kalem kalem döküm | Kurye NPS, tarife itirazı sayısı |
| **Kurye:** restoranda bekleme karşılıksız | — | Bekleme ücreti (8. dakikadan sonra) | Ödenen bekleme dakikası |
| **Kurye:** hız baskısı ve kaza | Hız puan bileşeni | Hız ödüllendirilmez; varış süresi güvenli sürüş tamponuyla; mesai içi kaza sigortası | Kaza sayısı/1.000 teslimat |
| **Kurye:** iletişimsizlik ve itirazsızlık | Destek erişimi zayıf | Her kararda gerekçe + itiraz + 72 saat içinde insan incelemesi; kurye temsilcisi kanalı | İtiraz yanıt süresi |
| **Kurye:** boş saatte gelir yok | Yok ya da bonusa bağlı | Garantili slotta saatlik asgari kazanç (§6.3) | Garanti tamamlama tutarı |

### 5.2 Konumlandırma ifadesi

> **İşletmeler için:** Kendi kuryeniz gibi, ama yönetimi bizde. Platformdan bağımsız, sepetinizden bağımsız sabit paket fiyatı; tüm platform siparişleriniz tek panelde.
>
> **Kuryeler için:** Kabul etmeden kazancını gör. Slotu yarışla değil, açık kuralla al. Beklediğin dakika da ödenir.

### 5.3 Neyi yapmayacağız

- Tüketici uygulaması (sipariş pazaryeri) kurmayacağız; platformlarla rekabet değil, onların "kendi kuryesi" modelini kolaylaştırma.
- Kendi navigasyonumuzu yazmayacağız; kuryenin seçtiği uygulamaya yönlendireceğiz.
- İzinsiz yollarla (ekran kazıma) platform verisi çekmeyeceğiz; yalnızca resmî API'ler ve işletmenin elle girişi.

---

## 6. İş modeli

### 6.1 Seçenekler

| | (a) Saf 3PL (paket servis firması) | (b) Saf SaaS (kurye filosu yazılımı) | **(c) Hibrit (önerilen)** |
|---|---|---|---|
| Müşteri | kuryesi olmayan/yetersiz işletmeler | kurye filosu işleten firmalar, kendi kuryesi olan zincirler | önce işletmeler, sonra filo işletmecileri |
| Gelir | paket başı ücret ya da kurye/ay kiralama | kurye/ay ya da paket/ay abonelik | paket ücreti + (Faz 2) yazılım lisansı |
| Marj | ince, kurye maliyetine duyarlı | yüksek ama Türkiye'de ARPU düşük (POS'lar 540–2.150 TL/ay) | karışık |
| Sermaye | yüksek (işletme sermayesi) | düşük | orta |
| Yasal risk | yüksek (muvazaa, yetki belgesi) | düşük | orta |
| Doğrulanmış talep | orta (komisyon farkı) | zayıf–orta (yerel rakipler var) | orta |

**Neden hibrit [T]:** Saf SaaS'ın Türkiye'de doğrulanmış fiyat çıpası yok ve POS firmaları kurye takibini zaten paketliyor. Saf 3PL'in marjı ince ve emeğe bağlı. Hibritte kendi operasyonumuz yazılımın gerçek koşullarda (verim, iptal, bekleme, slot dağıtımı) çalıştığını kanıtlar ve veri üretir; aynı yığın daha sonra filo işletmecilerine (`fleet` organizasyon tipi, Mimari Plan §5.3) satılır. Mimari bu yüzden baştan çok kiracılı kuruluyor.

### 6.2 Fiyatlandırma

- **İşletme:** paket başı sabit fiyat, sepetten bağımsız. Başlangıç önerisi **105 TL + KDV** (0–4 km), 4 km üstü km başı ek; yoğun saat ya da kötü hava ek ücreti şeffaf ve önceden bildirilir. Aylık taahhütlü işletmeye kademeli indirim (ör. ayda 1.500+ teslimatta 95 TL).
- **Kurye:** paket başı taban + mesafe + bekleme (8. dakikadan sonra) + teşvik; ortalama hedef 75 TL/paket. Garantili slotta saatlik asgari kazanç (§6.3).
- **Faz 2 yazılım lisansı [T]:** filo işletmecisine kurye başı aylık ücret; çıpa olarak global ürünler (29–99 $/sürücü) ve yerel POS fiyatları; 5–10 müşteriyle fiyat testi şart (karar kapısı 6).

### 6.3 Birim ekonomi

Tüm rakamlar TL, KDV hariç. Varsayımlar açıktır; pilot verisiyle güncellenmelidir.

**Varsayımlar**

| Girdi | Değer | Dayanak |
|---|---|---|
| Benzin | 80 TL/L | İstanbul, Ekim 2026 [D] tek kaynak |
| Motosiklet tüketimi | 2,2 L/100 km → 1,76 TL/km | 110–125 cc aralığının ortası [O] |
| Paket başı km (alım + teslim + konumlanma) | 6 km → 10,6 TL yakıt | [T] platform km kademeleri 3–6 km bandını ima ediyor |
| Kuryenin diğer giderleri | 3.500 TL/ay (bakım, amortisman, telefon, ekipman) | [T]; kaynaklarda toplam 5.000–9.000 TL (yakıt dahil) [D] |
| Çalışma | 8 sa × 26 gün = 208 sa/ay | [T] |
| Net asgari ücret 2026 | 28.075,50 TL → 144 TL/sa (195 sa) | [O] ikincil kaynaklar, aritmetik doğrulandı |
| Asgari ücretlinin işverene maliyeti 2026 | 40.214 TL (imalat dışı, 2 puan indirimli) | [O] |
| Hızla değişken maliyeti | 4 TL/paket (ödeme, SMS, sigorta payı, altyapı) | [T] |

**A) Kuryenin saatlik kazancı** (brüt / yakıt ve gider sonrası net; Bağ-Kur ve vergi **öncesi**)

| Paket başı ücret ↓ · Verim → | 2,0 paket/sa | 2,5 paket/sa | 3,0 paket/sa |
|---|---|---|---|
| 60 TL | 120 / 82 | 150 / 107 | 180 / 131 |
| 70 TL | 140 / 102 | 175 / 132 | 210 / 161 |
| 80 TL | 160 / 122 | 200 / 157 | 240 / 191 |
| 90 TL | 180 / 142 | 225 / 182 | 270 / 221 |

Karşılaştırma: net asgari ücretin saatlik karşılığı 144 TL. Esnaf kuryenin Bağ-Kur primi ve vergisi bu net rakamdan ayrıca düşer (genç girişimci istisnası ilk yıl Bağ-Kur'u ve 3 yıl gelir vergisini belirli tutara kadar karşılar [O]).

**Sonuç:** Kurye için adil bir ücret, **saatte 2,5 paketin altında** ve paket başı 75 TL'nin altında mümkün değil. Basında geçen "ayda 100 bin TL'nin üstü" kurye gelirleri günde 12–15 saat çalışmayı varsayıyor [D]. Hızla'nın kurye vaadi saat başı makul bir kazanç olmalı; bu da yoğunluk ve toplu teslimatla (aynı işletmeden iki sipariş, aynı yöne iki teslimat) verimi artırmaya bağlı.

**B) Hızla'nın katkısı** (fiyat − kurye ücreti − değişken maliyet, TL/paket)

| Fiyat ↓ · Ortalama kurye ücreti → | 70 TL | 75 TL | 80 TL |
|---|---|---|---|
| 95 TL | 21 | 16 | 11 |
| **105 TL** | 31 | **26** | 21 |
| 115 TL | 41 | 36 | 31 |

**C) Saatlik garanti maliyeti** (garantili slotta kuryeye saatte asgari 170 TL; paket başı ortalama 75 TL)

| Gerçekleşen verim | Hızla'nın tamamladığı tutar |
|---|---|
| 1,5 paket/sa | 58 TL/sa (paket başı 38 TL) |
| 2,0 paket/sa | 20 TL/sa (paket başı 10 TL) |
| ≥ 2,27 paket/sa | 0 |

Garantinin ikinci bir işlevi var: Hızla slotu gereğinden fazla kuryeye açarsa (kapasite planlaması kötüyse) bedelini kendisi öder. Rakip modelde bu maliyet kuryeye kalıyor (boş slot = sıfır gelir). Bu, adalet iddiasını finansal bir disipline bağlar.

**D) İşletmenin başabaş sepeti** (platform kuryesi farkı sepetin %20'si varsayımıyla: başabaş = fiyat / 0,20)

| Hızla fiyatı | Başabaş sepet | 400 TL sepette | 500 TL | 600 TL | 700 TL |
|---|---|---|---|---|---|
| 95 TL | 475 TL | %12 pahalı | %3 ucuz | %13 ucuz | %20 ucuz |
| **105 TL** | **525 TL** | %20 pahalı | %3 pahalı | %8 ucuz | %16 ucuz |
| 115 TL | 575 TL | %27 pahalı | %9 pahalı | %3 ucuz | %11 ucuz |

(Karşılaştırma: platform kuryesiyle %32 komisyon ↔ kendi kuryesiyle %12 komisyon + Hızla fiyatı; komisyon oranları [D].)

**E) İşletmenin kendi bordrolu kuryesine göre:** Bordrolu bir kuryenin aylık toplam maliyeti ~55,6 bin TL [H]. Tek işletmenin kuryesi boş saatleri dolduramadığı için saatte 1,5–2 paket verimde paket başı maliyet **143–190 TL** [H]; Hızla'nın 105 TL'si bunun belirgin altında. Paylaşımlı kurye havuzunun asıl ekonomik gerekçesi budur ve sepet tutarına bağlı değildir.

**Okuma:** Hızla'nın satış argümanı iki ayaklıdır: (1) **platform kuryesine göre** yüksek sepetli işletmelerde tasarruf; (2) **kendi kuryesine göre** her sepette tasarruf. İkincisi daha güçlü ve daha az bilinen argümandır; satış konuşması buradan başlamalı.

---

## 7. Pazara giriş

### 7.1 Pilot bölge ve müşteri

- **Bölge:** İstanbul'da iki komşu, yoğun, yüksek sepetli ilçe (ör. Kadıköy + Ataşehir ya da Beşiktaş + Şişli) [T]. Seçim ölçütleri: restoran yoğunluğu, ortalama sepet, kısa mesafeler (toplu teslimat fırsatı), kurye bulunabilirliği.
- **İlk müşteri profili:** 3+ şubeli zincir; ortalama sepet ≥550 TL (burger, pizza, et, suşi, aile menüleri); günde şube başına 30+ platform siparişi; bugün kendi kuryesiyle zorlanan ya da platform kuryesine yüksek komisyon ödeyen.
- **Satış kanalı:** doğrudan zincir satışları; TÜRES gibi derneklerle iş birliği (TÜRES'in doğrudan sipariş kampanyası teslimat kapasitesine ihtiyaç duyar [T]); POS entegratörleriyle (Simpra, SambaPOS) iş ortaklığı.
- **Teklif:** ilk 4 hafta, işletmenin teslimatlarının bir kısmı (ör. akşam yoğun saati) Hızla'ya; işletme panelinde **karşılaştırma kutusu** ile tasarrufun her ay gösterilmesi.

### 7.2 Kurye edinimi

- Hedef: pilot için 25–30 aktif kurye (günde 500 teslimat, saatte 2,5 paket ve 8 saatlik ortalama gün varsayımıyla 25 kurye).
- Mesaj: kabulden önce görünen kazanç, yarışsız slot, ödenen bekleme, garantili saatlik kazanç. Çok platformlu çalışan kuryelere "Hızla slotlarını diğer işlerinin arasına koy".
- Uygunluk: SRC KURYE, ehliyet, ruhsat, adli sicil, reflektif yelek + U-NET (yasal zorunluluklar, §2.3).
- **Kurye temsilcisi:** pilotun ilk haftasından itibaren kuryelerin seçtiği bir temsilci, kural değişikliklerinde önceden görüş verir. Maliyeti düşük; şikâyet listesindeki "karar süreçlerine katılım" talebine doğrudan cevap.

### 7.3 Pilot bütçesi (aylık, sabit giderler) [T]

| Kalem | TL/ay |
|---|---|
| Operasyon/dispatch (2 kişi) | 124.000 |
| Kurye destek ve başvuru (1 kişi) | 52.000 |
| Mesai içi kaza sigortası (25 kurye × 1.500) | 37.500 |
| Ekipman amortismanı (çanta, yelek) | 12.000 |
| Altyapı (sunucu, SMS, harita) | 15.000 |
| Ofis ve diğer | 30.000 |
| Hukuk ve mali müşavirlik | 25.000 |
| **Toplam** | **~296.000** |

Kurucu ve yazılım ekibi maaşları bu tabloda yok.

**Aylık sonuç (fiyat 105 TL, kurye ücreti 75 TL, değişken 4 TL, garanti tamamlaması ortalama 2,5 TL/paket):**

| Günlük teslimat | Gelir | Kurye ödemeleri | Katkı | Sabit gider | Sonuç |
|---|---|---|---|---|---|
| 350 | 1,10 M | 0,79 M | 247 bin | 296 bin | **−49 bin** |
| 500 | 1,58 M | 1,13 M | 352 bin | 296 bin | **+57 bin** |
| 750 | 2,36 M | 1,69 M | 529 bin | 296 bin | **+233 bin** |

**Başabaş: günde ~420 teslimat** [H].

**İşletme sermayesi:** Kurye haftalık ödenir. İşletme 45 günde öderse günde 500 teslimatta ~1,7 M TL finansman gerekir; işletme haftalık faturalanır ve 14 günde öderse ~0,5 M TL [H]. **Haftalık faturalama ve kısa vade sözleşmenin parçası olmalı.**

---

## 8. Ürün yol haritası

Mimari Plan'daki fazlarla hizalı. Pilotun gerektirdiği en dar küme önce.

| Aşama | Süre | İçerik | Pilotla ilişkisi |
|---|---|---|---|
| **MVP** | Mimari F−1…F7e (~8–10 hafta) | Kurye başvurusu ve belge onayı; işletme paneli (elle teslimat isteği, canlı takip, "Hazır" butonu); dispatch (en yakın uygun kurye + teklif zaman aşımı); slot talep penceresi + dağıtım + takas; kazanç dökümü; operasyon canlı ekranı ve istisna kuyruğu | Pilot bununla başlar; platform siparişi işletme tarafından tek dokunuşla girilir |
| **V1** | +6 hafta | Finans (fiyat kuralları, hakediş dönemi, işletme faturası, defter); ilk platform entegrasyonu (Yemeksepeti, erişim onayı gelirse); son müşteri takip bağlantısı; toplu teslimat (batch) | Pilotun 2. ayı |
| **V2** | +8 hafta | Diğer platform adaptörleri; talep tahmini ve otomatik slot kapasitesi; adalet paneli; kurye e-arşiv fatura otomasyonu; filo işletmecisi (`fleet`) kiracılığı | Pilot sonrası ölçek ve SaaS doğrulaması |

---

## 9. Riskler

| Risk | Olasılık | Etki | Azaltma |
|---|---|---|---|
| Platformlar "kendi kuryesi" koşullarını değiştirir ya da vale fiyatını düşürür | Orta–Yüksek | Yüksek | Satış argümanını kendi kuryesine göre tasarrufa (§6.3-E) dayandır; doğrudan sipariş kanallarına (TÜRES vb.) teslimat sağla |
| Platform API erişimi verilmez ya da değişir | Orta–Yüksek | Orta | Elle giriş her zaman çalışır; adaptör deseni; resmî yollar dışına çıkma |
| Verim saatte 2,5 paketin altında kalır | Orta | Yüksek | Dar ve yoğun bölge; batching; işletme "Hazır" sinyali ile zamanlama; pilot karar kapısı 1 |
| Kurye arzı yetersiz / eylem | Orta | Orta | Adil model, kurye temsilcisi, garantili saatlik kazanç; çok platformlu kuryelere esneklik |
| Esnaf kurye modelinde muvazaa / işçi sayılma | Orta | Yüksek | Hukuk görüşü (karar kapısı 5); kuryenin teklifi geçme ve slot seçme özgürlüğü; çok platformlu çalışma serbestisi; gerekiyorsa bordrolu çekirdek + esnaf havuzu |
| BTK yetkisinin gerekmesi | Düşük–Orta | Yüksek | Pilottan önce yazılı görüş |
| Asgari ücret ve yakıt artışı | Yüksek | Orta | Fiyata yakıt ve ücret endeksi maddesi; kurye tarifesinde yakıt endeksi |
| Tahsilat riski | Orta | Orta | Haftalık faturalama, kısa vade, depozito |
| Yerel yazılım rakipleri kurye arzını da eklerse | Düşük–Orta | Orta | Operasyon verisi ve kurye güveni kolay kopyalanmaz; hız |
| KVKK ihlali | Düşük | Yüksek | Konum yalnızca çevrimiçiyken; saklama ve imha politikası; veri işleme sözleşmesi |
| Bugünkü kod tabanındaki güvenlik açıkları (rol yetkilendirmesi yok, IDOR) | **Kesin** (bugün var) | Yüksek | Mimari Plan F−1, pilottan önce |

---

## 10. Hukuki ve uyum kontrol listesi (pilot öncesi)

- [ ] **BTK:** Hızla'nın faaliyeti için posta hizmeti yetkilendirmesi gerekiyor mu (yazılı görüş).
- [ ] **Ulaştırma:** kurye işletmeciliği yetki belgesi (P1/P2), Kurye Faaliyet Belgesi, U-NET kaydı.
- [ ] **İş hukuku:** esnaf kurye sözleşmesi, slot/teklif kurallarının bağımlılık göstergesi sayılıp sayılmayacağı; bordrolu çekirdek ihtiyacı.
- [ ] **Sigorta:** ticari kullanım trafik sigortası kuryede; Hızla adına mesai içi kişisel kaza ve sorumluluk sigortası.
- [ ] **Vergi:** işletmeye hizmet faturası; esnaf kuryeden alınacak belge türü (e-arşiv); KDV tevkifatı tartışması.
- [ ] **KVKK:** aydınlatma metinleri (kurye, işletme kullanıcısı, son müşteri), veri işleme sözleşmesi şablonu, saklama-imha politikası, VERBİS eşiği.
- [ ] **Platform sözleşmeleri:** işletmenin platform sözleşmesinin üçüncü taraf kuryeye izin verip vermediği.
- [ ] **SRC KURYE:** tüm kuryelerde belge kontrolü (15 Mayıs 2026'dan beri denetimde aranıyor).

---

## 11. Karar kapıları ve KPI'lar

Pilotun 12. haftasında aşağıdakilerin hepsi sağlanırsa ikinci bölgeye geçilir:

| # | Kapı | Eşik |
|---|---|---|
| 1 | Verim | Saatte ≥ 2,5 paket (bordrolu kurye kullanılıyorsa ≥ 3,0) |
| 2 | Katkı | Paket başı ≥ 20 TL; sabit gider sonrası aylık sonuç ≥ 0 |
| 3 | Fiyat kabulü | En az 10 işletme 95–115 TL aralığında sözleşme imzalamış |
| 4 | Kurye | 4 haftalık kurye elde tutma ≥ %70; kurye net saatlik kazancı ≥ 160 TL (yakıt ve gider sonrası) |
| 5 | Hukuk | BTK ve iş hukuku yazılı görüşleri olumlu ya da çözüm yolu net |
| 6 | Entegrasyon / SaaS | Bir platformdan resmî API erişimi **ya da** 5 filo işletmecisinden yazılım lisansı için niyet beyanı |

**İzlenecek KPI'lar:** ortalama atama süresi; işletmede ortalama kurye bekleme süresi; teslim süresi ve sözün tutulma oranı; iptal oranı (nedenine göre); kurye saatlik net kazancı; slot doluluk ve no-show oranı; slot Gini katsayısı; takas başarı oranı; kurye NPS; işletme NPS; işletme başına aylık tasarruf.

---

## 12. Sonuç

Hızla'nın iş fikri, Türkiye'deki teslimat pazarında gerçek ve büyüyen iki gerilimin tam ortasında duruyor: **işletmelerin platform kuryesine ödediği yüksek bedel** ve **kuryelerin mevcut slot ve puan sistemlerine duyduğu güvensizlik**. Her iki gerilim de belgelenmiş, kamuoyunda tartışılıyor ve düzenleyiciler işletmelerin yanında hareket ediyor.

Fikrin zayıf noktası birim ekonomidir: adil kurye ücreti, işletmenin ödemeye razı olacağı fiyat ve Hızla'nın marjı arasında dar bir alan var. Bu alanı genişletecek tek şey **yoğunluk ve akıllı dağıtımdır**: aynı kuryeyi birden fazla işletme arasında paylaştırmak, siparişleri birleştirmek, kuryeyi işletmeye yemek hazır olduğunda göndermek. Bunlar tam olarak Hızla'nın yazılımının yapacağı işler. Bu yüzden önerilen yol, yazılımı kendi operasyonunda kanıtlamak ve karar kapılarını sırayla geçmektir.

Teknik açıdan mevcut kod tabanı iyi bir başlangıç ama pilot için hazır değil: rol yetkilendirmesi yok, teslimat döngüsü uçtan uca tamamlanmıyor, işletme ve slot alanları hiç yok (Mimari Plan §1.1). Mimari plan bu boşlukları fazlara bölüyor; MVP için gereken süre yaklaşık 8–10 hafta.

---

## 13. Doğrulama listesi (karar öncesi tamamlanmalı)

1. Platform komisyon oranları (Yemeksepeti, Trendyol Yemek, GetirYemek, Migros Yemek) — resmi sözleşme ya da 3–5 işletmenin ekstresiyle.
2. Bölgesel paket servis firmalarının paket başı ve aylık kurye kiralama fiyatları (İstanbul, Ankara, İzmir) — doğrudan teklif isteyerek.
3. Getir, Trendyol Yemek ve Migros Yemek API erişim koşulları; Yemeksepeti API'sinde kurye bilgisi (ad, telefon, konum) iletimi.
4. BTK yetkilendirmesi ve Yargıtay'ın esnaf kurye kararları — hukuk bürosu.
5. Yemeksepeti Express slot bırakma kuralları ve seviye eşikleri — kurye görüşmeleri.
6. Ortalama yemek sepeti 2026 (platform ya da araştırma şirketi verisi).
7. Müşteri şikâyet istatistikleri (Şikâyetvar, mağaza puanları).
8. Fairwork Türkiye platform puanları.
9. Yerel rakiplerin (SepetTakip, Loji Team, Hemen Yolda, Adisyo, Simpra) gerçek özellik matrisi — demo hesaplarıyla.
10. Bağ-Kur 2026 prim oranı ve esnaf kurye için genç girişimci istisnasının güncel tutarı.

Bu oturumda web sayfası gövdeleri açılamadığı için yukarıdaki maddelerin çoğu arama özetleriyle sınırlı kaldı. Tarayıcı erişimi olan bir oturumda ya da insan araştırmacıyla 2–3 günde tamamlanabilir.

---

## Ek A. Seçili kaynaklar

Tam kaynakça: `docs/research/research-01-market-competitors.md` §12, `research-02-courier.md` §9, `research-03-feasibility.md` §14.

- Hızlı ticaret hacmi 2025: dunya.com/gundem/motokuryeli-hizli-ticarette-rekor-buyume-…-825135 ; istanbulticaretgazetesi.com/hizli-ticaret-hacmi-rekor-seviyeye-ulasti-…
- Uber–Trendyol Go: bloomberg.com/news/articles/2025-05-06/uber-to-buy-700-million-stake-in-turkish-delivery-app-trendyol
- Uber–Getir: aa.com.tr/tr/ekonomi/uber-getirin-yemek-teslimati-isini-335-milyon-dolara-satin-alacak-/3825028 ; webrazzi.com/2026/06/19/rekabet-kurulu-uberin-getirin-…
- Uber–Delivery Hero ve SSW: investor.uber.com (16 Temmuz 2026 duyurusu) ; paulweiss.com/insights/client-news/ssw-partners-to-acquire-delivery-hero-operations-…
- Genelge 2026/1: ticaret.gov.tr/haberler/elektronik-ticarette-yemek-siparis-hizmetlerine-yonelik-yeni-duzenleme
- Rekabet – Yemeksepeti kurye soruşturması: bloomberght.com/rekabet-kurumu-yemek-sepeti-ne-sorusturma-acti-2349915 ; cnbce.com/is-dunyasi/rekabet-kurumu-yemek-sepeti-icin-kurye-sorusturmasinda-gerekceli-kararini-acikladi-h25376
- TÜRES: ekonomim.com/ekonomi/restoranlar-online-platformlara-karsi-yuzde-20-indirim-karari-aldi-…-858436
- Yemeksepeti slot sistemi: yemeksepetiexpress.com/s-s-s/ ; haber.sol.org.tr/haber/yemeksepeti-kuryeleri-calisamiyor-vardiya-secimi-yapamiyorlar-puanlari-dusuyor-390681
- Kurye eylemleri Ocak 2026: birgun.net/haber/yemeksepeti-kuryeleri-ulke-genelinde-is-birakti-…-685302 ; bianet.org/haber/yemeksepeti-zam-acikladi-…-315865
- Karayolu Taşıma Yönetmeliği 2025: uab.gov.tr/haberler/karayolu-tasima-yoenetmeliginde-degisiklik/
- SRC KURYE: resmigazete.gov.tr/eskiler/2026/01/20260129-3.htm
- Yemeksepeti komisyon 2026: varisdijital.com/blog/yemeksepeti-komisyon-oranlari-2026 ; siparisustasi.com/blog/yemeksepeti-komisyon-orani
- Esnaf kurye tarifeleri 2026: ntv.com.tr/ntvpara/galeri-motokuryeler-ayda-100-bin-liranin-ustunde-kazaniyorlardi-…-1705489
- Asgari ücret maliyeti 2026: harbiyehukuk.com/asgari-ucret-ve-isverene-maliyeti/
- Yemeksepeti entegrasyon belgeleri: integration.yemeksepeti.com ; developer.yemeksepeti.com
