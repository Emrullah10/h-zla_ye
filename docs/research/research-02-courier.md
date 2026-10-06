# Hızla — Kurye Tarafı Araştırması (research-02)

Hazırlanma tarihi: 2026-10-06 · Kapsam: Türkiye platform kuryeliği, özellikle Yemeksepeti "slot" sistemi · Dil: Türkçe

---

## 0. Okumadan önce: araştırmanın sınırları ve güven etiketleri (ÖNEMLİ)

Bu rapor, planlanan derinlikte bir saha çalışması değildir. İki teknik engel nedeniyle kapsam daraldı:

1. **WebFetch aracı bu ortamda tamamen engelliydi.** Denenen tüm alan adları (sol.org.tr, birgun.net, bianet.org, medyascope.tv, sikayetvar.com, yemeksepetiexpress.com, resmigazete.gov.tr, isigmeclisi.org, kuryehaber.com, fair.work, eur-lex.europa.eu, wikipedia vb.) `EGRESS_BLOCKED` döndü. **Hiçbir kaynak sayfasının tam metni okunamadı.**
2. **WebSearch bütçesi (oturum başına 200, ortak havuz) yaklaşık 40. aramadan sonra tükendi.** Planlanan şu konular **aranamadı**: İSİG yıllık kurye ölüm sayıları, Yargıtay muvazaa kararları, Glovo/Deliveroo/Ley Rider/AB Direktifi/Fairwork'ün ayrıntıları, Wolt/JET/DoorDash, Reddit-YouTube-Glassdoor-Indeed-Kariyer.net yorumları, Getir ve Migros kurye eylemleri.

Sonuç olarak aşağıdaki bulguların dayanağı **arama aracının döndürdüğü özet/snippet metinleridir**; özetler yapay zekâ özeti olduğu için rakam ve cümleler sayfadaki ifadeyle birebir aynı olmayabilir. Bu nedenle her kritik rakam kaynak sayfasında ayrıca teyit edilmelidir.

**Etiketler**

| Etiket | Anlamı |
|---|---|
| **[G-Y]** Güven yüksek | Birden çok bağımsız haber/sendika/resmî-kaynak snippet'ında tutarlı biçimde göründü |
| **[G-O]** Güven orta | Tek haber kaynağı snippet'ı veya kısmen tutarlı |
| **[G-D]** Güven düşük | SEO/maaş rehberi sitesi, forum, birbiriyle çelişen rakamlar |
| **[DOĞRULANMADI]** | Bu oturumda kanıt bulunamadı veya kaynak açılamadı |
| **[TAHMİN]** | Benim çıkarımım/öneri; kanıt değil |
| **[HAFIZA]** | Modelin eğitim bilgisi; bu oturumda kaynağa ulaşılamadı, URL'siz iddia olarak okunmalı |

---

## 1. Özet

Kullanıcının gözlemi doğrulandı: Yemeksepeti'nin esnaf kurye kolu (Yemeksepeti Express) **slot sistemiyle** çalışıyor ve kurye tarafında bu sistemin etrafında hem yapısal hem toplu eylem düzeyinde bir şikâyet birikimi var. Önemli olan, slotun yalnızca bir "vardiya seçme ekranı" olmadığı; **erişim hakkını (kimin ne zaman iş alabildiğini), puan/seviye sistemini ve ücret kademelerini bağlayan merkezi bir kontrol mekanizması** olduğu.

**En önemli 15 bulgu**

1. **Slotlar otomatik ve talep temelli üretiliyor.** Yemeksepeti Express SSS'sine göre sistem, çalışma bölgelerindeki paket sayısına ve güzergâha göre slotları otomatik oluşturuyor; kurye ekipmanını aldıktan sonra sürücü uygulamasından slot seçiyor. [G-O] — yemeksepetiexpress.com/s-s-s/ (snippet)
2. **Slot görünürlüğü seviyeye (batch) göre kademeli açılıyor.** Gelecek haftanın slotları **Çarşamba günü 1-2-3-7 numaralı, Perşembe günü 4-5-6 numaralı seviyelere** görünüyor. Yani "slot avı" tasarımın içinde: erken görenler iyi slotu alıyor. [G-O] — aynı SSS (snippet, 2 farklı aramada tutarlı)
3. **Yedi seviyeli puan sistemi.** Seviye; taşınan paket sayısı, çalışılan saat aralığı ve teslimat hızına göre belirleniyor; çok çalışan yükselir. [G-O] — sol.org.tr (Eskişehir haberi, snippet)
4. **Kısır döngü:** slot bulamayan kurye paket taşıyamıyor → puan/seviye kaybediyor → daha geç/az slot görüyor → daha da az iş. Eskişehir kuryeleri bunu doğrudan anlatıyor. [G-O]
5. **Slotlar aniden kaldırılabiliyor.** Eskişehir'de mevcut slotların tahminen **%60'ı** kaldırıldı, kuryeler iki hafta çalışamadı, yönetimden geri dönüş alamadı (tarih snippet'ta yok). [G-O]
6. **"Slot kapatma" bir kolektif eylem biçimi.** Ocak 2026'da yaklaşık 40 ilde "slot kapatma/kontak kapatma" eğilimi oldu; 18–20 Ocak 2026'da üç günlük iş bırakma yapıldı. Slot sistemi, kuryelerin pazarlık kaldıracı olarak da çalışıyor — ürün tasarımı bunu hesaba katmalı. [G-Y]
7. **"Zam" bonuslara bağlı olduğu için gerçek artış düşük algılanıyor.** Yemeksepeti 12 Ocak 2026'da ~%32 (haberlerde %30–47 arası farklı sunumlar) zam açıkladı; kuryeler kâğıt üzerindeki %30'un cebe %10–14 yansıdığını, Motokurye İşçileri Derneği'nin hesabına göre haftada 200 paket atan kurye için toplam gelir artışının %24,6 olduğunu, ayrıca düşük bonus kademeleri kalktığı için daha fazla paket atmak zorunda kaldıklarını söylüyor. [G-O]
8. **Algoritmik hız baskısı** kuryelerin ana şikâyeti: Motokurye İşçileri Derneği Başkanı Seyhun Kavut: "Bu baskının nedeni tamamen algoritma. Siparişi mümkün olan en kısa sürede teslim etmemiz dayatılıyor." [G-O] — birgun.net
9. **Talepler somut:** şeffaf ve sabit paket ücreti, erişilebilir/adil bonus, "yapay zekâ hesabı" yerine gerçek maliyete dayalı mesafe ücreti, olumsuz havada ücretli izin, tam İSG, kurye temsilcilerinin karar süreçlerine katılımı (Ocak 2026); Ekim 2025'te ek olarak 6 km üstü siparişi kabul etmeme, ağır yükün motorla taşınmaması, çalışma saati sınırı, kaza halinde sosyal destek ve paket ücretinin 42 TL olması. [G-O]
10. **Ödeme haftalık ve e-fatura karşılığı** (Yemeksepeti Express, BiMasraf uygulaması üzerinden); yani esnaf kurye muhasebe/fatura yükünü de taşıyor. [G-O]
11. **Rakipler farklı:** Trendyol Go (Uber Eats ortaklığı) esnaf/serbest model, slot zorunluluğu yok [G-D]; Getir'de hem esnaf hem maaşlı model [G-D]; Vigo'da seçilebilir 8/10/12 saatlik vardiya ve sağlık sigortası [G-D]; TheKurye'de açık artırma, slot yok [G-D]. 13'ten fazla kurye platformu var → kurye çoklu platform kullanabiliyor.
12. **Mevzuat sertleşiyor:** Karayolu Taşıma Yönetmeliği (RG 15 Mayıs 2025) "kurye işletmeciliği", 30 kg/300 dm³ kurye gönderisi sınırı, P1/P2 yetki belgesi, Kurye Faaliyet Belgesi, "KURYE" yazılı reflektif yelek + U-NET numarası getirdi [G-Y]; 29 Ocak 2026 (RG 33152) ile **SRC KURYE** belgesi tanımlandı, denetimde aranması **15 Mayıs 2026**'dan itibaren [G-O].
13. **BTK boyutu:** 8 Mart 2025 Resmî Gazete ile dijital platformlardaki hızlı teslimat posta sektörüne dahil edildi; haberlere göre platformlar kurye çalışma saatlerini BTK'ya bildirmek zorunda. Hızla'nın giriş/çıkış ve slot kayıtları bu yüzden regülasyon verisi niteliği taşıyabilir. [G-O] (ayrıntı [DOĞRULANMADI])
14. **Vergi:** Kuryelere özel bir GVK muafiyeti/basit usul düzenlemesi **bulunamadı**. Genel kurallar geçerli: genç girişimci istisnası (29 yaş altı, ilk 3 yıl; 2025 için 330.000 TL), Bağ-Kur 4/b, KDV %20, e-arşiv fatura. Kurumsal platformlar fiilen gerçek usul + KDV'li fatura istiyor. [G-D/G-O]
15. **Uluslararası zemin kayıyor** [HAFIZA, doğrulanmadı]: AB Platform Çalışması Direktifi (2024/2831) için aktarım tarihi **2 Aralık 2026** (yaklaşık iki ay sonra); İspanya Ley Rider (2021) ve Glovo'nun 2025'te İspanya'da çalışan statüsüne geçişi; algoritmik yönetime şeffaflık/insan incelemesi zorunluluğu. Türkiye AB üyesi değil ama Delivery Hero (Yemeksepeti sahibi) ve Uber gibi küresel şirketlerin global politikaları bu yöne evriliyor. Hızla'nın "açıklanabilir slot/puan" tasarımı bu yüzden stratejik olarak doğru.

---

## 2. Platform bazlı kurye modelleri karşılaştırma tablosu

> Not: Aşağıdaki kazanç rakamlarının çoğu SEO/maaş rehberi sitelerinden ve birbiriyle çelişir; **brüt ciro ≠ net gelir** (yakıt, bakım, Bağ-Kur, vergi, muhasebe düşülmeden). Resmî platform tarifesi hiçbir yerde birincil kaynaktan görülemedi.

| Platform | İstihdam modeli | Slot / vardiya | Ödeme modeli | Ekipman | Tipik kazanç (2025–26, TL) | Kaynak |
|---|---|---|---|---|---|---|
| **Yemeksepeti Express** (Delivery Hero) | Ağırlıklı **esnaf kurye** (şahıs şirketi + fatura). 2022'de bordrolu işçilerin esnaf modele zorlandığı, sendikalı işçilere dava açıldığı iddia edildi [G-O]. Bordrolu çekirdek bugün için [DOĞRULANMADI]. | **Slot sistemi:** otomatik üretilen slotlar; seviye (1–7) bazlı kademeli görünürlük (Çar: 1-2-3-7, Per: 4-5-6); bölgeye göre kapasite. Slot devretme/bırakma kuralları ve cezaları [DOĞRULANMADI]. | Haftalık ödeme, e-fatura (BiMasraf). Ücret bileşenleri (haber ve SEO snippet'larından): saatlik taban (zaman dilimine göre), mesafe kademesi, çoklu sipariş ücreti, 6 km üstü tekli sipariş desteği, günlük/haftalık bonus kademeleri, Pazar 17:00–23:59 ek, bayram/resmî tatil ek [G-D/G-O]. | Ekipman (çanta/kıyafet) teslimi var; motor ve yakıt kuryede [G-D]. Yelek "KURYE" + U-NET zorunlu (mevzuat) | Basın: ortalama brüt ~100–118 bin TL iddiası (Ocak 2026, "%47 zam" haberleri; platform atfı kesin değil) [G-D]; SEO siteleri: 45–75 bin TL aylık (8 saat vs 12–14 saat) [G-D]. Paket başı: SEO'larda 25–45 TL (İstanbul'da 65–92 TL diyen de var) — tutarsız [G-D] | yemeksepetiexpress.com/s-s-s/ ; bianet.org/haber/…-315865 ; birgun.net/…-685302 ; halktv.com.tr/ekonomi/kuryelere-yuzde-47-zam-997495h ; eleman.net (Yemeksepeti kuryesi ne kadar kazanıyor) |
| **Trendyol Go (Uber Eats ortaklığı)** | **Esnaf/serbest** kurye: kendi adına hesap, kendi gün-saatini seçer [G-D]. Uber, Trendyol GO'nun %85'ini 700 milyon USD'ye aldı (Mayıs 2025); ~19.000 kurye, 90.000+ işletme [G-O] | Slot zorunluluğu yok [G-D]; bir SEO kaynağı "ateşli saatler (18–22) haftalık 20 saat" şartı iddia ediyor [DOĞRULANMADI] | Paket + km; 2026 İstanbul tarifesinde ortalama +%31 artış; çoklu sipariş min 27 TL, yoğun zaman 41,5 TL [G-D] | Motor/yakıt kuryede [G-D] | 2026 SEO: paket başı 25–45 TL [G-D] | webrazzi.com/2025/05/06/uber-trendyol-go-nun-cogunluk-hissesini-satin-aliyor/ ; srckurye.com.tr/trendyol-go-kurye/ ; eleman.net (Trendyol Go kuryesi) |
| **Getir** | **İki model:** esnaf kurye ve maaşlı (bordrolu) kurye [G-D]. Bordrolu modelde motor şirketten [G-D]. Geçiş/eritme süreci ve tarihçesi [DOĞRULANMADI] | Esnaf modelde kendi saatini belirler [G-D]; maaşlı modelde vardiya | Esnaf: 35–80 bin TL; maaşlı: 22–35 bin TL (aylık) iddiası [G-D] | Maaşlı: motor/ekipman şirkette; esnaf: kendi motoru | bkz. sol | srckurye.com.tr/getir-kurye/ ; heryerofis.com/blog/getir-kurye-maaslari-2026-… |
| **Migros Hemen / Migros Yemek** | Taşeron/vardiyalı model izlenimi; "bordrolu 3PL" yapısı **doğrulanamadı** [DOĞRULANMADI] | Vardiyalı, günlük 8–10 saat, haftalık izin [G-D] | Maaş + paket primi + yoğun saat bonusu [G-D] | Şirket/3PL ekipmanı [DOĞRULANMADI] | 33.000 (en düşük) – 47–55 bin (ortalama) – 70 bin'e kadar (prim) [G-D] | eleman.net/is-rehberi/maaslar-ve-ucretler/migros-hemen-kurye-maaslari-h21354 |
| **Vigo** | Maaşlı/sigortalı izlenimi [DOĞRULANMADI] | Seçilebilir 8/10/12 saatlik vardiya [G-D] | Sağlık sigortası dahil [G-D] | [DOĞRULANMADI] | [DOĞRULANMADI] | srckurye.com.tr/kurye-platformlari/ ; vigovigo.com/blog/src-kurye-donemi-basladi/ |
| **TheKurye** | Esnaf [G-D] | **Açık artırma**, slot yok [G-D] | Teklif usulü [G-D] | Kuryede | [DOĞRULANMADI] | srckurye.com.tr/kurye-platformlari/ |
| **Banabi / Scotty ve diğerleri** | Banabi depo ve kuryeleri Ocak 2026 eylemlerinde Yemeksepeti ile birlikte anıldı [G-O]; model [DOĞRULANMADI] | — | — | — | — | cumhuriyet.com.tr (Yemeksepeti ve Banabi, Ocak 2022 haberi); birgun.net/…-685263 |

**Akademik/eleştirel zemin:** İstanbul'da Getir, Trendyol ve Yemeksepeti'nde çalışan esnaf kuryelerin yaşanmış deneyimlerini inceleyen bir tez (Koç Üniv. araştırma hub'ı) ve Birikim'de "Platform Kapitalizminin Tekerlerine Çomak Sokan Kuryeler ve Esnaf Kurye İdeolojisinin Alaşağı Edilişi" (Ergin Bulut, Adem Yeşilyurt) yazısı var — içerik okunamadı, başlıkları yön göstericidir. [G-O]

---

## 3. Slot sistemi derinlemesine (Yemeksepeti Express)

### 3.1 Doğrulanan çalışma mantığı

| Öğe | Bulgu | Güven | Kaynak |
|---|---|---|---|
| Slot üretimi | Sistem, bölgedeki paket sayısına ve güzergâha göre otomatik üretir | G-O | yemeksepetiexpress.com/s-s-s/ |
| Slot seçimi | Ekipman teslimi sonrası kurye sürücü uygulamasından çalışacağı slotları seçer | G-O | yemeksepetiexpress.com/kurye-olmak/ , SSS |
| Kademeli açılış | Gelecek haftanın slotları Çarşamba (seviye 1-2-3-7) ve Perşembe (seviye 4-5-6) günü görünür | G-O | SSS (iki ayrı aramada tutarlı) |
| Seviye (batch) | 7 seviye; paket sayısı, çalışılan saat aralığı, teslimat hızı; çok çalışan yükselir | G-O | sol.org.tr/…-390681 |
| Puan etkisi | Paket taşıyamayan (slot bulamayan) kurye puan kaybeder, bu da iş almayı zorlaştırır | G-O | sol.org.tr/…-390681 |
| Performans etkisi | Düşük performanslı kurye daha az göreve yönlendirilir, sistem dışına çıkarılma riski | G-D | yandex yaozet özeti (kaynak zayıf) |
| Slot kaldırma | Eskişehir'de slotların ~%60'ı kaldırıldı, 2 hafta çalışılamadı, iletişim kurulamadı | G-O | sol.org.tr/…-390681 |
| Destek erişimi | Bursa Görükle merkezinde e-posta/telefonla muhatap bulunamadığı şikâyeti | G-D | sikayetvar.com (slot seçemiyorum başlığı altında) |
| Slot devri | Ekşi Sözlük'te: "Yemeksepeti canı istediğin zaman çalışabileceğin tek kurye sistemi; slot seçsen bile başkasına verebiliyorsun" (özet/çeviri) | G-D | eksisozluk.com/yemeksepeti-express--7541047 |
| Slot görünmemesi | "Slot gözükmüyor" konusu; çözüm olarak ofise gidip bölge ataması aldırma önerisi | G-D | technopat.net/sosyal/konu/yemeksepeti-slot-goezuekmueyor.3541304/ |
| Ödeme | Haftalık, BiMasraf üzerinden e-fatura karşılığı, IBAN'a | G-O | SSS (snippet) |

### 3.2 Kullanıcının sorduğu ama doğrulanamayan noktalar

| Soru | Durum |
|---|---|
| Slot bırakmanın cezası (puan düşümü, süre kuralı) | **[DOĞRULANMADI]** — resmî kural bulunamadı. Kurye forumlarında/Ekşi'de var olduğu varsayılan kurallar okunamadı. Tek ipucu: slotun başkasına devredilebildiği yönünde bir Ekşi özeti. |
| Gece yarısı slot avı | **[DOĞRULANMADI]** — resmî SSS "Çarşamba/Perşembe" diyor, saat bilgisi snippet'ta yok. Kurye topluluk anlatımlarında "gece yarısı/sabah erken" kalkıp slot kovalama beklenir ama kanıt bulunamadı. [TAHMİN] |
| Performans puanına göre erken açılma | **Kısmen doğrulandı:** seviye numarasına göre Çar/Per ayrımı var; seviyelerin hangi puan aralığına denk geldiği ve hangi grubun neden erken görüp görmediği [DOĞRULANMADI]. |
| Slot kapasitesi nasıl daraltılıyor | Sebep resmî olarak açıklanmamış; kuryeler "kapasite kısıtı + puan düşüşü" olarak yaşıyor. [DOĞRULANMADI] |

### 3.3 Slot etrafındaki şikâyet temaları (kanıt + sıklık tahmini)

1. **Slot bulamama / slotun silinmesi** (Eskişehir, "slot gözükmüyor" forumu) — şiddet yüksek, çünkü gelir sıfıra düşüyor.
2. **Puan/seviye sistemi opak ve geri beslemeli** (Şikâyetvar'da "Yemeksepeti Kurye Puanlama Sistemi Hakkında Şikayetler" başlığı mevcut; içerik okunamadı).
3. **Bonus kademeleriyle birleşme:** slot → paket sayısı → bonus kademesi. Alt kademeler kalkınca slot bulamayan kurye bonus da kaçırıyor (MKİD hesabı, Ocak 2026).
4. **Destek yok / iletişim yok.**
5. **Eşitsizlik algısı:** "Bazılarına erken açılıyor" yapısı (Çar-Per ayrımı).
6. **Kolektif hak arama aracı olarak slot kapatma.**

### 3.4 Slot kapatma / kontak kapatma olayları (zaman çizelgesi)

| Tarih | Olay | Kaynak |
|---|---|---|
| Ocak–Mart 2022 | 26+ gün süren Yemeksepeti eylemleri; 5.500 TL net maaş, iş güvencesi talebi; %17 zam teklifi ve esnaf modele zorlama protestosu; Nakliyat-İş (Gn. Bşk. Ali Rıza Küçükosmanoğlu) 1 Mart çağrısı | cumhuriyet.com.tr/…-1911282 ; evrensel.net/haber/455956 ; medyascope.tv/2022/02/01/… |
| 2025 (tarih doğrulanmadı) | "Uyumluluk/mobbing kuralları" protestosu: şirket esnaf olmak istemeyen çalışanlara mobbing, sendikalı çalışanlara dava iddiası | evrensel.net/haber/527768 ; bianet.org/yazi/…-299481 |
| 2025 (tarih doğrulanmadı) | Eskişehir slot silinmesi | sol.org.tr/…-390681 |
| 12 Ekim 2025 | Denizli toplantısı: 6 km üstü sipariş istemiyoruz, ağır yük motorla taşınmasın, paket ücreti yeniden yapılsın, çalışma saati sınırı, kaza halinde sosyal destek | kuryehaber.com/2025/10/… |
| Ekim 2025 | İstanbul Şişli genel merkez önünde eylem; talepler arasında paket ücretinin 42 TL olması | cumhuriyet.com.tr/ekonomi/…-2446638 ; bianet.org/yazi/moto-kuryelerin-ekim-isyani-312946 |
| 12 Ocak 2026 | Yemeksepeti zam duyurusu (%32; basında %30–47) | bianet.org/haber/…-315865 |
| 18–20 Ocak 2026 | 3 günlük ülke çapında kontak/slot kapatma, ~40 il | birgun.net/…-685302 ; politikam.com ; sendika.org/2026/01/… |
| Şubat 2026 | Motokurye İşçileri Derneği başkanı Seyhun Kavut: mücadele sürüyor | elyazmalari.com/2026/02/03/… |
| Temmuz 2026 | Kavut: yakıt istasyonunda kuryelere ayrımcı tavır (Bahçeşehir, Shell) | elyazmalari.com/2026/07/20/benzin-degil-onur-meselesi/ |
| Ağustos 2026 | Kavut: "Uber Eats Türkiye'de büyümüyor, pazarı topluyor" (içerik okunamadı) | elyazmalari.com/2026/08/29/… |

---

## 4. Türkiye mevzuatı

| Konu | Bulgu | Güven | Kaynak |
|---|---|---|---|
| **Karayolu Taşıma Yönetmeliği değişikliği (RG 15 Mayıs 2025)** | "Dağıtım işletmeciliği" → "kurye işletmeciliği". **Kurye gönderisi:** tek parçada ≤30 kg ve/veya ≤300 dm³. **P1 ve P2** yetki belgeleri. Şoför dışı teslimat yapan kuryeler için **Kurye Faaliyet Belgesi**. Reflektif yelekte "KURYE" ibaresi + firma **U-NET** numarası zorunlu. | G-Y | alomaliye.com/2025/05/15/…; erdem-erdem.av.tr/…; uab.gov.tr/haberler/karayolu-tasima-yoenetmeliginde-degisiklik/ |
| **SRC KURYE belgesi (RG 29 Ocak 2026, sayı 33152)** | Mesleki Yeterlilik Eğitimi Yönetmeliği değişikliği; SRC KURYE yalnızca motosiklet/moped kurye taşımacılığında geçerli; temiz adli sicil, koruyucu ekipman, kurye listesi tutma yükümlülükleri. **Denetimde aranması 15 Mayıs 2026'dan** (1 yıllık geçiş). Haberlerde: 25 saat MEB eğitimi + 40 soruluk sınav; ceza kuryeye 4.392 TL, işletmeye 10.666 TL (yalnız SEO/haber snippet'ı). | G-O (tarih/RG no), G-D (eğitim/ceza) | resmigazete.gov.tr/eskiler/2026/01/20260129-3.htm (açılamadı); und.org.tr/medya-detay/duyurular/…-29-01-2026; srckurye.com.tr; ekoturk.com |
| **Platform kuryeleri** | Trendyol/Getir/Yemeksepeti vb. platformlarda çalışan sürücüler de SRC KURYE almak zorunda | G-O | vigovigo.com/blog/src-kurye-donemi-basladi/ ; srckurye.com.tr/trendyol-getir-src-sarti/ |
| **BTK / Posta Hizmetleri (RG 8 Mart 2025)** | Dijital platformlarda sunulan hızlı teslimat posta sektörüne alındı; "platforma bağlı posta hizmeti" tanımı ve yetkilendirme; haberlere göre kurye çalışma saatlerinin BTK'ya bildirimi. Kurye sendikaları/İSİG: düzenlemede platformlar var, kuryeler yok. | G-O | iscihaber.net/…/145846 ; karar.com/…/1940062 ; isigmeclisi.org/21226-platformlar-yonetmelikte-kuryeler-yok-deniz-ipek |
| **Karayolları Trafik Yönetmeliği değişikliği (RG 4 Kasım 2025, 33067)** | Yayınlandığı doğrulandı; kurye/motosiklet hükümleri **okunamadı** | G-O (tarih), [DOĞRULANMADI] (içerik) | alomaliye.com/2025/11/04/… |
| **Esnaf kurye statüsü** | Şahıs şirketi; Bağ-Kur 4/b sigortalısı, primi kendi öder; platforma e-arşiv/e-fatura keser; gider: yakıt, bakım, kask, sigorta, telefon, muhasebe | G-O | workawayofis.com ; bayraktarburak.com/esnaf-kurye ; ankaramuhasebecim.com |
| **Vergi: kuryeye özel GVK muafiyeti?** | **Bulunamadı.** Genel kurallar: ticari kazanç (GVK md. 37), pratikte gerçek usul (kurumsal firmalar KDV'li fatura ister), KDV %20. Basit usul istisnası genel mevzuatta var ama platform ilişkisinde fiilen kullanılmıyor. 2026'dan itibaren büyükşehir ilçelerinde basit usulden çıkış düzenlemesi haberi var ([DOĞRULANMADI] — kurye etkisi). | G-D | alomaliye.com/2025/11/19/esnaf-moto-kuryelerin-vergisel-yukumlulukleri/ ; yguder.org.tr/… |
| **Genç girişimci istisnası** | 29 yaşını doldurmamış, ilk kez mükellef: 3 yıl boyunca belirli tutara kadar gelir vergisi istisnası (2025 için 330.000 TL; 2022 haberinde 75.000 TL); Bağ-Kur primi 1 yıl Hazine tarafından | G-O | mehmetpektas.com.tr/blog/esnaf-kurye-ne-kadar-vergi-oder ; hurriyet.com.tr/yazarlar/ahmet-karabiyik/moto-kuryeye-vergi-de-yok-bag-kur-primi-de-yok-42068861 |
| **KDV tevkifatı** | Kurye taşımacılığında tevkifat tartışmalı (işgücü temini/taşıma sözleşmesi); 1.000 TL altı işlemde tevkifat yok kuralı | G-D | muhasebenews.com ; muhasebetr.com |
| **e-fatura/e-arşiv** | Mükellef olunca e-arşiv fatura/e-defter yükümlülüğü; 12.11.2024 tarihli TÜRMOB duyurusu (e-fatura/e-arşiv uygulamasına dahil olma) — içerik okunamadı | G-D | turmob.org.tr/ekutuphane/Read/1f08a2d9-… |
| **İş kazası/ölüm istatistiği** | İSİG yazısından aktarılan: 22.545 kaza (motosiklet/kurye, toplamın %18,2'si) ve 76 kurye ölümü — **yıl net değil** [DOĞRULANMADI]. İSİG yıllık raporları aranamadı. | G-D | isigmeclisi.org/21226-… ; kuryehaber.com/2025/03/platformlar-yonetmelikte-kuryeler-yok/ |
| **Muvazaa / işçi sayılma / Yargıtay** | **Aranamadı** [DOĞRULANMADI]. Argüman çerçevesi: "kuryeler tüccar plasiyer değil bağımlı işçi" (Kurye Haber, 2022); sendikaların "esnaf kurye sistemi kölelik" söylemi. | — | kuryehaber.com/2022/03/kuryeler-tuccar-plasiyer-degil-bagimli-isci/ |
| **Örgütlenme** | Motokurye İşçileri Derneği (Seyhun Kavut), Nakliyat-İş, Tümtis, Turizm-Eğlence-Hizmet İşçileri Sendikası (Ocak 2026'da 40 il eylemini anlatan başkan), Kurye Hakları (kuryehaklari.org), Kurye Haber. | G-O | birgun.net/…-685302 ; medyascope.tv (2022) ; kuryehaklari.org |

**Ürüne yansıması (mevzuat):** (a) Onboarding'de SRC KURYE + Kurye Faaliyet Belgesi + ehliyet/sicil doğrulama alanları; (b) gönderi ağırlığı/hacmi alanı ve 30 kg/300 dm³ uyarısı; (c) çalışma/slot kayıtlarının dışa aktarılabilir olması (BTK bildirimi ihtimali); (d) reflektif yelek/U-NET kontrol listesi; (e) kurye adına otomatik e-arşiv fatura/hakediş belgesi. Hukuki doğrulama gerekir. [TAHMİN]

---

## 5. Uluslararası referanslar

> **Uyarı:** Bu bölümdeki bilgiler bu oturumda arama bütçesi bittiği için **doğrulanamadı**; modelin eğitim bilgisine dayanır ([HAFIZA]). Rakamlar ve tarihler yayından önce kaynağından teyit edilmelidir. Fairwork için tek doğrulanan, `fair.work/en/ratings/turkey/` adlı bir Türkiye sayfasının arama sonuçlarında göründüğüdür; **içerik açılamadı, hiçbir puan aktarılmıyor.**

| Konu | Bilinen / hatırlanan | Hızla için ders | Doğrulama durumu |
|---|---|---|---|
| **Glovo — slot + "excellence score"** | Kuryeler müşteri puanı, yoğun saatte çalışma, hız gibi metriklerden hesaplanan skorla slot rezervasyonunda öncelik alıyordu; ilk seçenler iyi slotu alır, skor düşünce slot kaybedilir. İtalya Garante, Foodinho'ya algoritmik yönetim nedeniyle para cezası verdi (2021'de ~2,6 milyon €; 2024'te daha yüksek) | Skor-slot bağı hem hukuki hem itibar riski; açıklanabilirlik şart | [HAFIZA] [DOĞRULANMADI] |
| **Glovo İspanya** | Ley Rider sonrası yasal baskı; 2025 ortasında kuryeleri çalışan statüsüne geçirme kararı | Slot+ceza+puan = kontrol göstergesi; çalışan sayılma riski | [HAFIZA] [DOĞRULANMADI] |
| **İspanya Ley Rider (RDL 9/2021)** | Teslimat kuryeleri için çalışan karinesi; algoritma parametrelerinin işçi temsilcilerine açıklanması | Algoritma şeffaflığı kural olabilir | [HAFIZA] [DOĞRULANMADI] |
| **AB Platform Çalışması Direktifi (AB) 2024/2831** | Karine mekanizması, algoritmik yönetimde şeffaflık/insan gözetimi/insan incelemesi, bazı kişisel veri işlemlerinin yasağı; **aktarım son tarihi 2 Aralık 2026** | "Gerekçeli karar + insan incelemesi + itiraz" ürün özelliği olmalı | [HAFIZA] — resmî metin: https://eur-lex.europa.eu/eli/dir/2024/2831/oj (açılamadı) |
| **Deliveroo — "free login"** | Slot rezervasyonundan uzaklaşıp kuryenin istediği an giriş yaptığı model; İngiltere Yüksek Mahkemesi (Kasım 2023) kuryelerin toplu pazarlık bakımından "worker" olmadığına karar verdi | Slotsuz esneklik rekabeti: serbest giriş esnekliği, slot ise garanti sunmalı | [HAFIZA] [DOĞRULANMADI] |
| **DoorDash — Dash Now vs Scheduled Dash** | Anında giriş (Dash Now) ve önceden rezervasyon (Scheduled) birlikte; ücret şeffaflığı özellikleri; ABD'de bazı şehirlerde (NYC, Seattle) asgari ücret düzenlemeleri | Hibrit model: serbest giriş + garantili slot | [HAFIZA] [DOĞRULANMADI] |
| **Uber Eats** | Serbest giriş; ücret/teklif ekranında şeffaflık | — | [HAFIZA] [DOĞRULANMADI] |
| **Wolt** | Bazı ülkelerde kurye serbest giriş, bazılarında planlı | — | [DOĞRULANMADI] |
| **Just Eat Takeaway Scoober** | Birçok ülkede bordrolu kurye; 2025'te Almanya'da kendi filosundan alt yüklenici modeline geçiş haberleri | Bordrolu model maliyetli; sürdürülebilir olmayabilir | [HAFIZA] [DOĞRULANMADI] |
| **Fairwork** | 5 ilke: adil ücret, adil koşullar, adil sözleşme, adil yönetim, adil temsil. Türkiye sayfası var, puanlar okunamadı | Hızla için "Fairwork ilkelerine göre self-audit" bir pazarlama/etik avantajı olabilir | İlkeler [G-O] (sakarya.edu.tr PDF snippet); Türkiye puanları [DOĞRULANMADI] |

---

## 6. Kuryelerin acı noktaları ve ürün çözümleri

"Kanıt" sütunu: **K** = bu oturumda kaynaklı kanıt, **T** = [TAHMİN] (sektör genel bilgisi/çıkarım; bu oturumda kanıtı bulunamadı). Şiddet/sıklık değerlendirmesi benim **[TAHMİN]**'imdir, anket verisi değildir.

| # | Acı noktası | Şiddet / sıklık [TAHMİN] | Kanıt | Hızla ürün çözümü |
|---|---|---|---|---|
| 1 | **Slot bulamama ve slotların aniden silinmesi** (gelir sıfırlanır) | Çok yüksek / yaygın | K: sol.org.tr/…-390681 (Eskişehir %60); technopat.net | Yayınlanmış slot ≥72 saat önce kaldırılamaz; zorunlu azaltmada "en son alan ilk çıkar" + tazminat veya öncelikli yeniden atama; kurye uygulamasında bölge kapasite panosu |
| 2 | **Seviye/batch'e göre kademeli açılış → eşitsiz erişim, "slot avı"** | Yüksek / yaygın | K: SSS (Çar/Per) | Anlık yarış yerine **talep toplama penceresi + adil tahsis** (bölüm 8); her kurye için asgari haftalık slot hakkı |
| 3 | **Puan–slot–bonus kısır döngüsü** (slot yok → paket yok → puan düşer) | Çok yüksek | K: sol.org.tr | Puanı slot erişiminden ayır; "kötü performans" yerine "iş bulamama" kaynaklı düşüşü hesaba katma; iyileşme yolu ("ne yaparsam geri gelirim") ekranı |
| 4 | **Puan düşüşü açıklanmıyor / itiraz yok** | Yüksek | K: Şikâyetvar başlıkları (kurye/puan); T | Puan kırılımı (hangi sipariş, hangi olay), itiraz butonu, 72 saatte insan incelemesi, gerekçeli yazılı sonuç |
| 5 | **Slot bırakma cezası / bırakamama korkusu** (hastalık, kaza, araç arızası) | Yüksek | T (resmî kural bulunamadı) + K: Ekşi'de devir bilgisi | Mazeretli bırakma (hasta, kaza, hava), takas pazarı, kademeli ve yazılı bırakma kuralları, ceza yerine "güvenilirlik göstergesi" |
| 6 | **Gece yarısı/erken saat slot avı, yorgunluk** | Orta–yüksek | T | Slot açılışı sabit bir "talep penceresi"nin sonunda otomatik tahsis (kullanıcı uyurken de adil), bildirim |
| 7 | **"Zam" bonuslara bağlı; gerçek artış düşük, düşük bonus kademeleri kalktı** | Çok yüksek | K: bianet 315865; birgun 685302 | **Kazanç şeffaflığı:** sipariş başına net kazanç dökümü (taban + km + bonus), "bu hafta X pakette Y TL" kademe simülatörü, tarife değişikliklerinde önce-sonra karşılaştırma |
| 8 | **Paket başı ücret öngörülemez; "yapay zekâ ile hesaplanan" mesafe ücreti** | Çok yüksek | K: Ocak 2026 talepleri (sabit paket ücreti, gerçek maliyet) | Sipariş teklifinde **kabul öncesi net kazanç** gösterimi, açık tarife kartı, hesaplama kuralı herkese açık |
| 9 | **Uzun mesafe (6 km+), ağır yük (30 kg), hastane içi teslim** | Yüksek | K: Denizli 12 Ekim 2025; mevzuat 30 kg sınırı | Mesafe/ağırlık eşiğinde otomatik ek ücret, kuryeye "reddet" hakkı (cezasız), ağırlık/hacim bildirimi |
| 10 | **Algoritmik hız baskısı → trafik kazası riski** | Çok yüksek (hayat riski) | K: Kavut (birgun 685302); İSİG istatistik (yıl belirsiz) | Güvenli ETA tamponu; hız-ödül ilişkisini kaldır; geç teslimde puan düşüşü yok (restoran/hava kaynaklıysa); "riskli teslim" bayrağı |
| 11 | **Kaza ve ölüm; sigorta yok** | Çok yüksek | K: İSİG (76 ölüm, yıl belirsiz); Denizli talebi (kaza sosyal desteği) | Mesai içi kaza/tedavi sigortası (slot/oturum başına), acil durum butonu + konum paylaşımı, olay sonrası ödeme sürekliliği |
| 12 | **Olumsuz hava (yağmur/kar/rüzgâr)** | Yüksek | K: Ocak 2026 talebi (ücretli izin) | Hava modu: otomatik ek ücret ve "cezasız slot bırakma/iptal" |
| 13 | **Restoranda bekleme** (ücretsiz zaman kaybı) | Yüksek | T (kanıt bulunamadı) | Giriş-hazır-alım zaman damgalı bekleme sayacı; X dakikadan sonra bekleme ücreti; restoran hazır-süre skoru ve işletme panelinde uyarı |
| 14 | **Müşteri/restoran iptali (yoldayken)** | Orta–yüksek | K: Şikâyetvar iptal başlıkları (içerik okunamadı); T | İptal ücreti (en az taban ücret + km), iptal nedeni kayıt altında, kurye puanına etkisi yok |
| 15 | **Fatura/vergi/Bağ-Kur yükü, e-fatura (BiMasraf vb.)** | Orta | K: SSS | Kurye adına otomatik hakediş + e-arşiv fatura (onaylı entegratör), vergi ve prim tahmin aracı, haftalık/anlık erken ödeme opsiyonu |
| 16 | **Yakıt ve bakım maliyeti, istasyonda ayrımcılık** | Yüksek | K: Kavut Temmuz 2026; Ocak 2026 "gerçek maliyet" talebi | Yakıt maliyet endeksi → mesafe ücretine otomatik yansıma; istasyon/bakım indirim ortakları; "net saatlik kazanç" göstergesi |
| 17 | **Ekipman ve belgeler (çanta, kask, yelek, SRC KURYE, U-NET)** | Orta | K: mevzuat; SSS ekipman teslimi | Belge doğrulama + eğitim yönlendirmesi, ekipman/leasing katalogu, belge bitiş uyarısı |
| 18 | **Destek erişilemezliği, yanıtsızlık** | Yüksek | K: sol.org.tr/…-390681; şikayetvar | Uygulama içi canlı destek, SLA (ör. 24 saat), taleplerin durum takibi, kurye temsilcisi kanalı |
| 19 | **Hesap/slot kısıtlama veya kapatma (açıklamasız)** | Yüksek | T; K: "sistem dışına çıkarılma riski" (G-D) | Gerekçeli karar + insan incelemesi + itiraz süresi; önceden uyarı kademeleri |
| 20 | **Mobbing / "uyumluluk kuralları", sendikal baskı** | Orta–yüksek | K: evrensel 527768; bianet 299481 | Kurallar açık ve versiyonlu; değişiklikten önce kurye temsilcisi geri bildirimi; kanallar |
| 21 | **Mola/ihtiyaç noktaları, saygısızlık** | Orta | K: Kavut Temmuz 2026; T | Mola modu (cezasız duraklatma), kurye dostu nokta haritası (tuvalet, su, şarj), mağaza/site kapısı sorunları için işletme panelinde "kurye girişi" bilgisi |

---

## 7. Slot sistemi tasarım önerisi (Hızla)

Aşağıdakiler **öneridir [TAHMİN]**; sayısal eşikler pilot verisiyle ayarlanmalıdır.

### 7.1 Tasarım ilkeleri

1. **Slot = karşılıklı taahhüt.** Kurye çalışma sözü verir; platform da sipariş hacmi/taban gelir sözü verir. Tek taraflı ceza yok.
2. **Açıklanabilirlik.** Her kurye "bu slotu neden alamadım / neden bu seviyedeyim" sorusuna uygulamada cevap bulur.
3. **Güvenliği ödüllendirmeme.** Hız metriği slot önceliğine **girmez** (kaza riski); güvenilirlik (no-show, takas) ve süreklilik girer.
4. **Esneklik korunur.** Hibrit model: garantili slot + serbest giriş (fazla kapasite varsa).
5. **Hukuki denge.** Aşırı sıkı slot + ceza + öncelik = kontrol göstergesi; çalışan sayılma riskini artırabilir. (Hukuki görüş gerekir.) [TAHMİN]

### 7.2 Kural seti

| Konu | Öneri |
|---|---|
| **Slot türleri** | (a) **Garantili slot:** rezerve, taban saatlik ücret; (b) **Esnek giriş:** serbest giriş, kapasite doluysa kuyruğa; (c) **Teşvikli/surge slot:** sabit ek TL/paket; (d) **Yedek (standby) slot:** çağrılırsa ek ücret |
| **Açılış takvimi** | Haftalık planlı yayın (ör. Pazartesi). Yayından sonra **24–36 saatlik "talep toplama penceresi"**; pencerede sıra önemsiz. Sonra otomatik tahsis (aşağıda). Gece avı ve yarış ortadan kalkar |
| **Tahsis mantığı** | Ağırlıklı adil dağıtım: (1) **asgari hak** (ör. aktif kuryeye haftada ≥X saat), (2) kalan kapasite: önce **süreklilik/güvenilirlik**, sonra **geçen hafta isteyip alamayan** kuryelere telafi ağırlığı, (3) yeni kurye kotası (ör. %10–20), (4) bölge uyumu. Kural açık yazılı |
| **Öncelik skoru bileşenleri** | Güvenilirlik (no-show/geç bırakma), son 4 haftada aktiflik, kıdem; **hız yok**. Skor kuryeye bileşenleriyle gösterilir |
| **Bırakma penceresi** | >48 saat: serbest, cezasız. 48–12 saat: **takasa açılır**; devralan bulunursa ceza yok. <12 saat: mazeret türü seçilir (hastalık, kaza, araç arızası, hava, acil) — mazeretliyse cezasız. Mazeretsiz tekrarlarda kademeli uyarı → geçici öncelik düşüşü (puanla karıştırılmaz) |
| **Takas pazarı** | Kurye-kurye slot devri; devralan uygunluk (belge, bölge) otomatik kontrol; platform onay beklemez; geçmiş takas performansı gösterilir |
| **No-show yönetimi** | Başlangıçtan 15 dk tolerans, giriş yapmazsa slot yedek listeye döner; "yoldayım" bildirimi toleransı uzatır; arıza/kaza durumunda tek tuş mazeret |
| **Talep tahmini** | Tarihsel sipariş + hava + etkinlik/tatil + restoran kampanyası ile 7 günlük tahmin; kapasite hedefi tahmin P75–P90'a göre; her 24 saatte güncelleme; kuryeye doluluk göstergesi (düşük/orta/yüksek) |
| **Bölge bazlı kapasite** | Mikro bölge (ör. 1–2 km kümeler) başına slot kapasitesi; bölge değişimi talebi; çok bölgeli slot seçeneği |
| **Kapasite azaltma** | Yayınlanmış slot < 72 saat kalmışsa kaldırılamaz; zorunluysa **tazminat** (ör. 1 saatlik taban ücret) + öncelikli yeniden yerleşim |
| **Surge/teşvikli slot** | Talep > kapasite öngörülürse otomatik teşvik; teşvik gerekçesi ve tutarı slot kartında; teşvik, taban ücretin yerine değil üzerine |
| **Şeffaflık** | "Slot neden alınamadı?" ekranı; öncelik skoru bileşenleri; haftalık kazanç projeksiyonu; tarife değişiminde önce/sonra karşılaştırma |
| **Adalet izleme (admin paneli)** | Kuryeler arası slot dağılımı eşitsizliği (ör. Gini), ilk 10 dakikada dolan slot oranı, yeni kurye erişim oranı, takas başarı oranı, mazeretsiz bırakma oranı |
| **Raporlama** | Slot/giriş/çıkış kayıtları dışa aktarılabilir (BTK/denetim olasılığı); kurye kendi kayıtlarını indirebilir |

### 7.3 Rakiplerin hatalarından dersler

| Rakip hatası (kanıt/tahmin) | Hızla'da kaçınma |
|---|---|
| Kademeli, seviyeye bağlı erken açılış (Yemeksepeti: Çar/Per) | Yarış yok; talep toplama + adil tahsis |
| Slotların bildirimsiz silinmesi (Eskişehir %60) | Silme kuralı ve tazminat |
| Puan düşünce slot kaybı, slot yok → puan düşer (Yemeksepeti) | Puan ile slot erişimini ayır |
| Bonusa bağlı "zam" (Ocak 2026) | Taban + bonus ayrımı; her değişiklik gösterilir |
| İletişim yok (Eskişehir, Bursa) | SLA'lı destek ve temsilci kanalı |
| Skor tabanlı slot önceliği ve opaklık (Glovo, [HAFIZA]) | Açıklanabilir skor, hız dışı kriterler |
| Slotsuz serbest girişte kapasite belirsizliği [TAHMİN] | Hibrit: garantili + serbest giriş |

### 7.4 Pilot ölçütleri [TAHMİN]

Slot doluluk oranı; kurye başına haftalık net kazanç/saat; mazeretsiz bırakma oranı; takas başarı oranı; işletme tarafında teslimat süresi/SLA; kurye NPS; destek yanıt süresi; kurye retansiyonu (4 hafta).

---

## 8. Doğrudan alıntılar (anonim/kaynaklı)

> **Dürüstlük notu:** Sayfa metinleri okunamadığı için aşağıdakiler çoğunlukla **haber başlıkları, slogan veya snippet'ta Türkçe geçen ifade**dir. İngilizce özetten geri çevrilenler "[çeviri]" ile işaretlendi. Kurye forumu (Reddit/Ekşi/Şikâyetvar) içinden birebir yorum alınamadı.

| # | Alıntı | Kimden / nerede | Tür |
|---|---|---|---|
| 1 | "Canımızı hiçe sayan bizler değil sistemdir" | Yemeksepeti kuryeleri, BirGün, Ocak 2026 — birgun.net/…-685263 | Başlık/alıntı |
| 2 | "Bu baskının nedeni tamamen algoritma. Siparişi mümkün olan en kısa sürede teslim etmemiz dayatılıyor." | Seyhun Kavut (Motokurye İşçileri Derneği Başkanı), BirGün, Ocak 2026 — birgun.net/…-685302 | Doğrudan |
| 3 | "Bu zam değil sefalet ücretine makyaj" | Yemeksepeti kuryeleri, sol.org.tr, Ocak 2026 — …-405769 | Başlık |
| 4 | "Sistemin bel kemiği biziz" | sendika.org, Ocak 2026 — sendika.org/2026/01/…-740943 | Başlık |
| 5 | "Sistem canımızı yok sayıyor" | BirGün, Ocak 2026 — …-685302 | Başlık |
| 6 | Zammın "sahada hiçbir karşılığı yok" (kâğıtta %30, maaşa %10–14) | Kuryeler, bianet/sol, Ocak 2026 | Özet (parafraz) |
| 7 | "Sefalet ücretini kabul etmiyoruz" | Yemeksepeti ve Banabi kuryeleri, Cumhuriyet, **Ocak 2022** — cumhuriyet.com.tr/…-1904682 | Başlık (2022) |
| 8 | "Robot değil, insanız" | Ankara eylemi, Medyascope, **Şubat 2022** | Başlık (2022) |
| 9 | "Esnaf kurye sistemi tam bir kölelik sistemidir" | Tümtis Genel Başkanı Öztürk, Medyascope, **2022** | Başlık (2022) |
| 10 | "Taleplerimiz karşılanmazsa kontak kapatacağız" | Evrensel, **Şubat 2022** — evrensel.net/haber/455956 | Başlık (2022) |
| 11 | "Motokuryeler tek yumruk!" | sol.org.tr/…-395002 | Slogan/başlık |
| 12 | "Taleplerimizi karşılayın!" | sol.org.tr/…-362077 | Başlık |
| 13 | "Vardiya seçimi yapamıyorlar, puanları düşüyor" | Eskişehir kuryeleri, sol.org.tr/…-390681 | Başlık |
| 14 | Kuryeler paket taşıyamadıkları için puan kaybettiklerini ve iş alamadıklarını söylüyor | Eskişehir, sol.org.tr/…-390681 | Özet (parafraz) |
| 15 | "Üzerimde sipariş var. Normalde rahatsız etmezdim ama yakıt almam gerekiyor." | Bahçeşehir'de benzinlikte bir kurye, aktaran Seyhun Kavut — elyazmalari.com/2026/07/20/benzin-degil-onur-meselesi/ | [çeviri] |
| 16 | "Motor kuryeler köle değildir" | Pankart, Ocak–Şubat 2022 — cumhuriyet.com.tr/…-1911282 | [çeviri] |
| 17 | "Yemeksepeti şu an canı istediğin zaman çalışabileceğin tek kurye sistemi; slot seçsen bile başkasına verebiliyorsun" | Ekşi Sözlük yorumcusu — eksisozluk.com/yemeksepeti-express--7541047 | [çeviri/özet] |
| 18 | Slot gözükmüyor; ofise gidip bölge atamasını aldırmanız öneriliyor | Technopat forum — technopat.net/sosyal/konu/yemeksepeti-slot-goezuekmueyor.3541304/ | Özet |

---

## 9. Kaynakça

> Aşağıdaki tüm URL'ler **arama sonuçlarında göründü; WebFetch engeli nedeniyle içerikleri açılamadı**. Dayanak snippet'tır. Tarihler URL'den veya snippet'tan alınmıştır; tarih belirtilmeyenlerin yılı doğrulanmamıştır.

**Yemeksepeti — slot, seviye, ödeme**
- https://yemeksepetiexpress.com/s-s-s/ (SSS: slot üretimi, Çar/Per seviye açılışı, BiMasraf ödemesi)
- https://yemeksepetiexpress.com/kurye-olmak/
- https://apps.apple.com/tr/app/yemeksepeti-express-kurye/id1667283557?l=tr (uygulama adı: Yemeksepeti Express Kurye)
- https://haber.sol.org.tr/haber/yemeksepeti-kuryeleri-calisamiyor-vardiya-secimi-yapamiyorlar-puanlari-dusuyor-390681
- https://www.sikayetvar.com/yemeksepeti/yemeksepeti-sorun-slot-secemiyorum
- https://www.sikayetvar.com/yemeksepeti/kurye/puan
- https://www.sikayetvar.com/yemeksepeti/kurye/maas
- https://www.sikayetvar.com/yemeksepeti/kurye/esnaf
- https://www.technopat.net/sosyal/konu/yemeksepeti-slot-goezuekmueyor.3541304/
- https://eksisozluk.com/yemeksepeti-express--7541047
- https://www.eksiduyuru.com/duyuru/744601/yemeksepeti-puanlama-sistemiyle-alakali

**Eylemler, talepler, sendikalar**
- https://www.birgun.net/haber/yemeksepeti-kuryeleri-ulke-genelinde-is-birakti-sistem-canimizi-yok-sayiyor-685302
- https://www.birgun.net/haber/yemeksepeti-kuryeleri-sefalet-zammina-karsi-is-birakti-canlarimizi-hice-sayan-biz-degil-sistem-685263
- https://bianet.org/haber/yemeksepeti-zam-acikladi-kuryeler-hakediste-artisi-goremedi-kontaklar-kapandi-315865
- https://haber.sol.org.tr/haber/kontak-kapatan-yemeksepeti-kuryeleri-bu-zam-degil-sefalet-ucretine-makyaj-405769
- https://haber.sol.org.tr/haber/yemeksepeti-kuryeleri-birakti-405458
- https://sendika.org/2026/01/yemeksepeti-kuryeleri-sefalet-dayatmasina-karsi-kontak-kapatti-sistemin-bel-kemigi-biziz-740943
- https://www.politikam.com/son-dakika-kuryeler-kontak-kapatti-18-20-ocak-2026-kurye-boykotu-hangi-firmalari-kapsiyor
- https://www.aydinlik.com.tr/haber/kuryelerden-uc-gunluk-kontak-kapatma-eylemi-563476
- https://www.elyazmalari.com/2026/02/03/yemeksepeti-kuryelerinin-mucadelesi-devam-ediyor/
- https://www.elyazmalari.com/2026/07/20/benzin-degil-onur-meselesi/
- https://www.elyazmalari.com/2026/08/29/uber-eats-turkiyede-buyumuyor-pazari-topluyor/
- https://kuryehaber.com/2025/10/eylem-gibi-toplantı-yemeksepeti-kuryeleri-sorunlarini-masaya-yatirdi/
- https://www.cumhuriyet.com.tr/ekonomi/istanbul-da-yemeksepeti-kuryeleri-haklari-icin-ayaklandi-2446638
- https://bianet.org/yazi/moto-kuryelerin-ekim-isyani-312946
- https://www.evrensel.net/haber/527768/yemeksepeti-kuryeleri-eylemde-uyumluluk-kurallarini-geri-cekin
- https://bianet.org/yazi/yemeksepeti-nde-mobbing-kurallari-na-karsi-kuryelerin-tepkisi-buyuyor-299481
- https://haber.sol.org.tr/haber/kontak-kapatmaya-hazirlanan-yemeksepeti-iscileri-kararli-motokuryeler-tek-yumruk-395002
- https://haber.sol.org.tr/haber/yemeksepeti-kuryeleri-mucadeleye-hazirlaniyor-taleplerimizi-karsilayin-362077
- 2022 bağlamı: https://www.cumhuriyet.com.tr/turkiye/yemeksepeti-kuryeleri-verilen-sozler-tutulmazsa-1-martta-kontak-kapatacak-1911282 ; https://www.evrensel.net/haber/455956/yemeksepeti-kuryelerinin-eylemleri-26-gununde-taleplerimiz-karsilanmazsa-kontak-kapatacagiz ; https://medyascope.tv/2022/02/01/yemeksepeti-calisanlarini-esnaf-kurye-olmaya-zorluyor-tumtis-genel-baskani-ozturk-esnaf-kurye-sistemi-tam-bir-kolelik-sistemidir/ ; https://medyascope.tv/2022/02/04/yemeksepeti-kuryeleri-ankarada-eylem-yapti-robot-degil-insaniz/ ; https://www.cumhuriyet.com.tr/turkiye/yemeksepeti-kuryeleri-izmirde-kontak-kapatti-sefalet-ucretini-kabul-etmiyoruz-1904682
- https://kuryehaber.com/2022/03/kuryeler-tuccar-plasiyer-degil-bagimli-isci/
- https://birikimdergisi.com/guncel/10914/platform-kapitalizminin-tekerlerine-comak-sokan-kuryeler-ve-esnaf-kurye-ideolojisinin-alasagi-edilisi
- https://research.hub.ku.edu.tr/entities/publication/692ed745-96fd-4636-b00d-cd97568e8abb/full (esnaf-kurye tezi)
- https://kuryehaklari.org/platform-ekonomisi-ve-dijital-calismanin-gelecegi-calistayinda-kurye-talepleri-gundeme-geldi/

**Ücret/kazanç (düşük güven, SEO)**
- https://www.halktv.com.tr/ekonomi/kuryelere-yuzde-47-zam-997495h ; https://www.haberx.com/esnaf-kuryelere-yuzde-47-zam-paket-basi-ve-saatlik-ucretler-guncellendi/ ; https://www.superhaber.com/aylik-100-bin-tlnin-ustunde-kazaniyorlardi-esnaf-kuryelerin-aylik-brut-maasina-yuzde-47lik-rekor-zam-geldi-galeri-562528
- https://www.eleman.net/is-rehberi/maaslar-ve-ucretler/yemeksepeti-kuryesi-ne-kadar-kazaniyor-2024-yeni-ucretler-h2667
- https://malipilot.com/blog/esnaf-kurye-paket-basi-ucret-2026.html
- https://heryerofis.com/blog/yemeksepeti-kurye-maaslari-2026-paket-basina-kazanc-ve-giderler
- https://heryerofis.com/blog/getir-kurye-maaslari-2026-motorlu-kurye-kazanci-ve-calisma-sartlari
- https://meslekmaas.com/kurye-maaslari/
- https://srckurye.com.tr/kurye-platformlari/ ; https://srckurye.com.tr/getir-kurye/ ; https://srckurye.com.tr/trendyol-go-kurye/ ; https://srckurye.com.tr/esnaf-kurye-nedir/
- https://www.eleman.net/is-rehberi/guncel/trendyol-go-kuryesi-ne-kadar-kazaniyor-2024-yeni-ucretler-h2092
- https://www.eleman.net/is-rehberi/maaslar-ve-ucretler/migros-hemen-kurye-maaslari-h21354
- https://yandex.com.tr/yaozet/services/yemeksepeti-kurye-calisma-kosullari-ve-kazanclari-id3-5KAWN44q

**Trendyol Go / Uber**
- https://webrazzi.com/2025/05/06/uber-trendyol-go-nun-cogunluk-hissesini-satin-aliyor/
- https://medyascope.tv/2025/05/06/uber-trendyol-goyu-satin-aldi/
- https://www.marketingturkiye.com.tr/haberler/uber-trendyol-goyu-satin-aldi/
- https://kpmg.com/tr/tr/home/insights/2025/05/gida-ve-icecek-sektoru-strateji-bulteni.html

**Mevzuat**
- https://www.alomaliye.com/2025/05/15/karayolu-tasima-yonetmeliginde-degisiklik-15-05-2025/
- https://www.erdem-erdem.av.tr/bilgi-bankasi/kurye-ve-tasimacilik-faaliyetlerine-iliskin-mevzuatta-yapilan-onemli-degisiklikler
- https://www.uab.gov.tr/haberler/karayolu-tasima-yoenetmeliginde-degisiklik/
- https://umutakpinar.com/15-mayis-2025-tarihli-karayolu-tasima-yonetmeligi-degisiklikleri/
- https://www.resmigazete.gov.tr/eskiler/2026/01/20260129-3.htm
- https://www.und.org.tr/medya-detay/duyurular/karayolu-tasimacilik-faaliyetleri-mesleki-yeterlilik-egitimi-yonetmeliginde-degisiklik-yapilmasina-dair-yonetmelik-29-01-2026
- https://vigovigo.com/blog/src-kurye-donemi-basladi/
- https://www.ekoturk.com/haberler/moto-kuryeler-icin-son-2-gun-src-belgesi-olmayan-kuryelere-yuksek-ceza-geliyor/
- https://www.alomaliye.com/2025/11/04/karayollari-trafik-yonetmeliginde-degisiklik-04-11-2025/
- https://www.iscihaber.net/gundem/dijital-kurye-hizmetleri-posta-sektorune-dahil-edildi/145846
- https://www.karar.com/guncel-haberler/kuryeler-icin-yeni-donem-basladi-btk-zorunlulugu-geldi-1940062
- https://www.isigmeclisi.org/21226-platformlar- ; https://kuryehaber.com/2025/03/platformlar-yonetmelikte-kuryeler-yok/

**Vergi / Bağ-Kur / e-fatura**
- https://www.alomaliye.com/2025/11/19/esnaf-moto-kuryelerin-vergisel-yukumlulukleri/
- https://www.hurriyet.com.tr/yazarlar/ahmet-karabiyik/moto-kuryeye-vergi-de-yok-bag-kur-primi-de-yok-42068861
- https://www.mehmetpektas.com.tr/blog/esnaf-kurye-ne-kadar-vergi-oder
- https://www.yguder.org.tr/mevzuat-ve-vergi/basit-usul-esnaf-icin-gelir-vergisi-muafiyeti-devam-ediyor-2026-yilinda-defter-tutma-hadleri-kira-sinirlari-ve-beyanname-vermeme-avantaji-126h
- https://www.turmob.org.tr/arsiv/mbs/resmigazete/-2025_basit_usul.pdf
- https://www.turmob.org.tr/ekutuphane/Read/1f08a2d9-db4b-46a6-af71-c8af1408e7c9
- https://www.workawayofis.com/blog/kuryeler-icin-sahis-sirketi-esnaf-kurye-modeli/ ; https://www.bayraktarburak.com/esnaf-kurye ; https://www.ankaramuhasebecim.com/esnaf-kurye-vergi-rehberi/
- https://www.muhasebenews.com/kurye-hizmetleri-kdv-tevkifatina-tabi-midir/

**Uluslararası / Fairwork**
- https://fair.work/en/ratings/turkey/ (arama sonucunda göründü, içerik açılamadı)
- https://fair.work/wp-content/uploads/sites/17/2025/05/Fairwork-Cloudwork-Report-2025-FINAL.pdf (sonuçlarda göründü)
- https://ceko.sakarya.edu.tr/sites/ceko.sakarya.edu.tr/file/Dijital_Emek_Platformlarindaki_Calisma_Kosullarini_Degerlendirmeye_Yonelik_Sistematik_Bir_Cerceve_Fairwork_Ilkeleri_____Prof._Dr_._Ekrem_ERDOGAN__Ars_._Gor_._Meryem_KAYTAN_1.pdf (Fairwork ilkeleri, Türkçe)
- https://eur-lex.europa.eu/eli/dir/2024/2831/oj (resmî metin; açılamadı)

---

## 10. Eksikler ve devam araştırma listesi

Öncelik sırasıyla (WebSearch/WebFetch erişimi geri geldiğinde):

1. **Yemeksepeti Express SSS ve destek merkezi** (yemeksepetiexpress.com/s-s-s/ ve destek.yemeksepetiexpress.com): slot bırakma kuralı, ceza, seviye eşikleri, gece açılış saati, bonus tablosu — bu rapordaki en büyük boşluk.
2. **Kurye yorumları (birebir):** Ekşi Sözlük "yemeksepeti kuryelerinin eylem yapması" (özellikle sayfa 6), "yemeksepeti express", Şikâyetvar kurye başlıkları, Reddit r/Turkey/r/KurYe benzeri, YouTube "Yemeksepeti slot" videoları, Kariyer.net/Indeed/Glassdoor.
3. **Fairwork Türkiye** sayfası (fair.work/en/ratings/turkey/) — platform puanları ve ilke bazlı gerekçeler.
4. **İSİG Meclisi** 2024 ve 2025 yıllık iş cinayetleri raporlarında kurye sayıları; 2026 ilk 6 ay.
5. **Yargıtay kararları:** kurye/muvazaa/asıl-alt işveren, "esnaf kurye" sözleşmesinin bağımlı işçilik çıkarımı.
6. **Karayolları Trafik Yönetmeliği 4 Kasım 2025** değişikliğinin kurye/motosiklet hükümleri; kask/ekipman zorunlulukları.
7. **BTK Posta Hizmetleri Yönetmeliği 8 Mart 2025** metninin tam hali: platform yükümlülükleri ve kurye çalışma saati bildirimi.
8. **Getir, Trendyol Go, Migros Yemek** için kendi resmî kurye başvuru/SSS sayfaları ve eylem haberleri.
9. **Uluslararası:** Glovo excellence score kaynakları (Garante kararları), Deliveroo free login duyuruları, DoorDash Scheduled Dash, AB Direktifi aktarım takvimi (Almanya, İspanya, Fransa taslakları), İspanya Ley Rider, JET/Lieferando değişikliği, Wolt kurye modeli.
10. **Vergi:** 2026 basit usul değişikliğinin kuryeye etkisi, genç girişimci 2026 limiti, e-arşiv zorunluluk eşikleri; bir SMMM ile doğrulama.
