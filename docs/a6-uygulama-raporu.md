# A6 — İlçe seçimi ve İstanbul Albümü
28 Ekim 2026. Uygulama tamamlandı; kullanıcı kontrolü bekleniyor.

## Oyuncunun yeni kararı
Açılan ilçe artık otomatik etkinleşmez. Tek etkin ilçe yeni talep üretir. Oyuncu üstteki ilçe düğmesini açıp yedi ilçeyi inceler; kilitli ilçelerin karşılaştırması da görülebilir, ancak etkinleştirilemez. Mevcut filo ve hizmet seviyesiyle talep, kurucu ortalama iş süresi, ortalama sipariş ücreti ve yaklaşık sürekli gelir karşılaştırılır. Açık ilçeler arasında ücretsiz geri dönüş yapılabilir. Daha yüksek talep otomatik olarak daha yüksek gelir anlamına gelmez.

İlçe düğmesindeki +N, mevcut ilçeden ileride açılmış ilçe sayısını bildirir. Dönüş özeti açılmış ileri ilçe varsa karşılaştırmayı ilk seçenek olarak sunar; kendiliğinden geçiş yapmaz. A5'in pozitif katkılı yatırım seçenekleri kalan satırlarda devam eder.

## İlk deneme ekonomisi
Tur cirosu eşikleri tasarım belgesindeki denemeye alındı: 0 / 500 / 2.000 / 6.500 / 18.000 / 50.000 / 120.000 ₺. Prestige eşiği 220.000 ve tur başına kalıcı %10 bonus A7'ye kadar korunur.

| İlçe | Talep/dk | Ortalama iş mesafesi birimi | Trafik çarpanı | İlçe ücret çarpanı |
|---|---:|---:|---:|---:|
| Şile | 3 | 300 | 1,00 | 1,00 |
| Beykoz | 5 | 360 | 1,08 | 1,25 |
| Üsküdar | 7 | 330 | 1,16 | 1,50 |
| Kadıköy | 10 | 345 | 1,24 | 1,75 |
| Beşiktaş | 14 | 375 | 1,32 | 2,00 |
| Şişli | 20 | 420 | 1,40 | 2,25 |
| Beyoğlu | 28 | 450 | 1,48 | 2,50 |

Bunlar gerçek coğrafya, nüfus veya trafik ölçümü değil oyun tasarım katsayılarıdır. Gerçek oyun yol mesafesi / ilçedeki çiftlerin ortalaması × tablodaki mesafe kullanılır. İş süresi bu değer / rol hızı × trafik çarpanıdır; ikinci gizli trafik etkisi yoktur. Ortalama ücret, gerçek çiftlerin yuvarlanmış tekliflerinden türetilir. Şile ayrı yol ağı kullanır; diğer ilçeler görselleri ayrı olsa da ortak temel yol grafiğini kullanır. İlçe mesafe katsayıları ve talep/ücret farkları oynanış farkını üretir; yedi gerçek sokak ağı yapıldığı iddia edilmez.

Örneğin yalnız yaya kurucuda Beykoz ortalama iş süresi 38,88 sn'dir; başlangıç Şile 30 sn. Filo aynı kaldığında ücret artışı her durumda yavaşlamayı karşılamaz. Ekip eklenince artan talebin karşılanması başka sonuç verir. Önizleme geçişteki eski kuyruğu içermez; yaklaşık sürekli akışı gösterir.

## Geçişte korunacak işler
Kabul edilmiş kuyruk ve aktif iş sözlükleri geçişte değiştirilmez: özgün ilçe, yol verisi, kilitli ücret ve atanmış kalan süre korunur. Kuyruktaki eski iş atanınca kendi ilçesinin koşullarıyla çalışır. Eski ilçeden yeni talep üretilmez; mevcut işler bitene kadar karışık kuyruk geçicidir. Eski iş yeni haritada yanlış hedef olarak çizilmez.

Talep zamanlayıcısının bir sonraki siparişe doğru ilerleme oranı korunur. Aynı anda ilçeler arasında gidip gelmek yeni sipariş veya para üretmez. Yalnızca görsel konum önbelleği temizlenir; yeni işlerin görsel başlangıcı eski haritanın konumlarıyla yorumlanmaz.

## İstanbul Albümü
Şile başlangıç kartı verilir. Her ilçede ilk kez çalışmaya başlandığında bir garantili kartpostal kazanılır; yalnızca kilidin açılması kart kazandırmaz. Tekrar eden parça, gacha, para birimi veya üretim çarpanı yoktur. Yedi mevcut piksel harita büyük, kaydırılabilir kartpostal görünümünde yeniden kullanılır; yeni raster varlık üretimi gerekmedi. Kart başlıkları Şile/Deniz Feneri, Beykoz/Anadolu Hisarı, Üsküdar/Kız Kulesi, Kadıköy/Haydarpaşa, Beşiktaş/Dolmabahçe, Şişli/Atatürk Müzesi ve Beyoğlu/Galata Kulesi. Görseller stilize ilçe kolajlarıdır.

Ziyaret edilmemiş kartlar koyu ve açıklamalı görünür. Albüm yeni turda korunur; yalnızca oyuncunun onaylı tam oyun sıfırlamasında temizlenir. İlçelerin yeni tur işletme kilitleri ise tekrar tur cirosuna bağlıdır.

## Kayıt geçişi
Kayıt şeması 4, ekonomi sürümü 3. Etkin ilçe, en ileri açılmış ilçe ve kalıcı albüm ayrı kaydedilir. Eski sürümün ayrılık süresi önce eski eşikler, otomatik ilçe ilerlemesi ve eski mesafe profiliyle tamamlanır; sonra A6 etkinleşir. Ulaşılan etkin ilçe geriye alınmaz. Yeni düşük eşikler ek ilçeleri açabilir, ancak onları etkinleştirmez veya ziyaret edilmemiş albüm kartlarını vermez.

A6 öncesi otomatik ilerlemede ulaşılan ilçeye kadarki kartlar göçte korunur. Önceden en az bir tur tamamlamış oyuncunun yedi ilçeyi ziyaret ettiği bilindiğinden yedi kartı da verilir. Kasa, araç, hizmet, ekip, ciro, itibar ve eski kabul edilmiş işler korunur. A3 şirket iadesi yalnızca ekonomi 0/1 göçünde çalışır; A6'ya gelen ekonomi 2 kayda tekrar iade veya 60 ₺ kuruluş sermayesi verilmez. Tek seferlik açıklama kaydedilir.

## Doğrulama
15 farklı test betiği geçti: district_choice, district_progression, simulation_clock, strategic_economy, return_choices, onboarding, offline_summary, delivery_status, delivery_flow, staff_progression, map_camera, menu_reset, save_store, isometric_projection, progression_ui. SCRIPT ERROR/ERROR konsol satırları başarısızlık sayıldı. Her test geçici APPDATA ile yapıldı; gerçek oyuncu kaydı kullanılmadı.

Yeni kontroller: kilitli ilçeye ret, açılma/etkinleşme ayrımı, gerçek teklif ortalamalarıyla önizleme eşleşmesi, önizlemenin RNG/etkin ilçeyi değiştirmemesi, aktif/kuyruk işlerinin kilitleri, tekrar geçişte sipariş/para/kart çoğalmaması, çevrim dışı açılışın etkinleşmemesi, albüm kayıt/yeniden başlama/tam sıfırlama, yeni turda albümün kalması, ekonomi 2 geçmişinin kendi modeliyle hesaplanması ve eski tamamlanmış turların keşiflerinin korunması. JSON üzerinden geçen süreler 0,0001 sn toleransla, para tam olarak karşılaştırılır.

`tools/measure_a4.gd`, üç yatırım sırası ve beş tohumla toplam 15 adet 600 sn koşuda ilk Beykoz kilidini ölçtü; ilçe seçimi yapılmadı:

| Yol | 500 ₺ tur cirosuna ulaşma |
|---|---|
| Araç → hizmet → yaya | 486–546 sn (8,1–9,1 dk) |
| Hizmet → yaya → araç | 476,5–512,5 sn (7,9–8,5 dk) |
| Yaya → hizmet → araç | 458–491,5 sn (7,6–8,2 dk) |

İlk tasarım hedefi 8–15 dk idi; bazı kontrollü yollar 8 dakikanın biraz altına indi. Bu aşamada katsayıları tekrar ayarlayıp sonuç gizlenmedi; kapsamlı denge A8'de ele alınacak. Koşular anında satın alan sabit politikadır; gerçek oyuncu okuma/karar gecikmesi veya sonraki ilçelerin dengesi değildir.

`tools/capture_a6.gd` ile karşılaştırma, etkinleştirme, kısmi/tam albüm, albüm alt kısmı, uzun ekran ve açılmış ilçe dönüşü üretildi. Compare, album-full, album-bottom, album-tall ve return-unlocked görüntüleri gözle incelendi. Büyük kartlar kaydırma alanına sığıyor; başlıklar ve alt düğmeler okunur. Gerçek Android cihazda kaydırma/dokunma ve performans hâlâ A9 kontrolüdür.

## Kullanıcı kontrolü ve sıradaki aşama
Üstteki ilçe düğmesinden Beykoz'u incele; açıldıysa seç ve eski işlerin devam ettiğini kontrol et. Aynı ekrandan İstanbul Albümü'nü açıp kartları kaydır. A6 sonunda dur. Açık devam talebinden sonra A7: İstanbul İtibarı, önce/sonra önizleme ve yeni tur bonusu/geçişi. A4 yardımsız anlama denemesi ve gerçek Android cihaz kontrolü henüz raporlanmadı.
