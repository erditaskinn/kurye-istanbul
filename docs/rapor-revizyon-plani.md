# 0.18 dış inceleme sonrası revizyon planı

Güncel durum (30 Ekim): R7.2 kaynak uygulaması ve 10 betik tamamlandı; docs/r7-2-uygulama.md. R7.3 denge/görsel/cihaz doğrulaması bekliyor; APK hâlâ R6. Aşağıdaki aşama sonuçları tarihsel sıradadır.

Durum: Planlama ve kod karşılaştırması tamamlandı; uygulama başlamadı. Girdi docs/claude-inceleme-raporu-0.18.txt içindeki kullanıcı tarafından paylaşılan rapordur. Rapor Godot çalıştırmadan, eksik sanat paketinden ve kısmi kod okumasından çıkarılmıştır. Özgün rapor bulguları otomatik gereksinim değildir. Bu dosya mevcut şirket/idle/sabit harita sözleşmesini korur.

## Doğrulananlar ve rapora düzeltmeler

- main.gd _process: 30sn zamanlayıcıya ek olarak pozitif teslimat geliri olan her simülasyon adımında _save_game çağrısı var. Bu her tekil teslimat başına zorunlu ayrı yazma değil, teslimat olan kare başına yazmadır; gereksiz I/O riski gerçektir. Kaydı kaldırmak tek başına güvenli çözüm sayılmaz: kritik işlemler ve Android yaşam döngüsü korunmalı, geri yükleme/çevrim dışı eşitliği doğrulanmalı.
- dispatch.missed kaydediliyor, ana arayüzde gösterilmiyor. Bu kaçan talep adedidir; kesin kayıp kasa tutarı değildir. Karşılanmayan işler için mesafe/ücret teklifi üretilmediğinden kesin kayıp TL uydurulmayacak. Ceza/kayıp korkusu yerine kapasite fırsatı olarak gösterilecek.
- _order_quote, kuyruğa kabul anında ücret ve hız profilini kilitliyor; _assign eski profil ile süre oluşturuyor. İşe atanma anıyla karıştırılmamalı. İş sözleşmesini bozacak geriye dönük yeniden fiyatlama yapılmayacak. Bekleyen işlerin neden eski koşulda sürdüğü açık anlatılacak; davranış değişikliği ayrı ekonomi/kayıt kararıdır.
- _rebirth_ready aktif son ilçeyi ve220K tur cirosunu birlikte istiyor. Tasarım tercihi olarak uygulanmış; daha yüksek ilçenin her filoda daha fazla gelir sağlaması garanti değil. Açılmış son ilçe koşulu gibi alternatifler ölçüm sonrası revize edilecek.
- _market_profile ilçe bazında ortalama mesafe ve ücret dağılımını zaten önbelleğe alıyor. Buna rağmen _order_quote/_calculate_payout rota mesafesini yeniden hesaplıyor. Tamamen önbelleksiz denmeyecek; sipariş çifti mesafe/teklif önbelleği eksik.
- Eski kişisel kurye çizimleri ve gizlenen kontroller var. Fakat legacy_dispatch ve sürüm geçişleri göç için gerekli olabilir. Görünmeyen her eski fonksiyon silinmeyecek.
- Hareketli kurye olmaması kullanıcının açık sabit harita kararıdır. Raporun hareketli kurye önerisi kabul edilmedi. Hafif teslimat vurguları ve isteğe bağlı ses/titreşim değerlendirilebilir; harita üstüne sürekli hareketli kurye geri getirilmeyecek.
- Font/HUD0.18 için Türkçe ve₺ desteği ve iki ekran oranı zaten doğrulandı. Görselleri tekrar tümden değiştirmek bu rapordan çıkmıyor.
- Yeni ekonomi dengesinin onaylanmadığı doğru. 89dk ilk tur/40dk beşinci tur, araç ve konforun değersizliği gibi sonuçlar yalnız dış akışkan model hipotezidir; gerçek olay simülasyonu olmadan kesin sonuç sayılmaz. Başlangıç geri ödeme tahminleri yaklaşık, kilitli kuyruk/yuvarlama/talep geçişleri yüzünden gerçek süre farklıdır.
- Çevrim dışı olay eşitliği ve4saat tavanı otomatik testlidir.0.18'in gerçek cihazda ağır4saat dönüş maliyeti ölçülmüş değildir. Test yokluğu ile mekanik yokluğu ayrılacak.
- Mobil yayın/release/AAB hazırlığı eksikliği mevcut test aşamasında engelleyici hata değildir. Yayın ayrıca yetkilendirilmeden mağaza işlemi yapılmaz. Çoklu prestige bonusu var; ayrı ileri oyun sistemleri henüz sınırlıdır.

## Revizyon sırası

Her R aşaması sonunda sonuç, test/ekran kanıtı ve gerekiyorsa APK sunulacak; kullanıcı kontrolü için durulacak. Yeni aşama otomatik başlamayacak. İlk iş R1; sayısal denge değişikliği ölçümden önce yapılmayacak.

### R1 — Güncel modelin gerçek ölçümü
Godot olay motoruyla deterministik yeni koşular; yeni kayıt, 1./3./5. tur; hizmet ağırlıklı, filo ağırlıklı, dengeli ve verime göre yatırım politikaları. Yedi ilçede talep/kapasite, gerçek gelir, boşa kalan filo, iş kuyruğu, dışarıda kalan talep, her yatırımın gerçek marjinal etkisi ve ilk itibar süresi kaydedilir. Sıfır katkıda geri ödeme sonsuz/etkisiz olarak tanımlanır. Çevrim dışı4saat için gerçek beklemek gerekmeyen izole kayıt ile CPU/zaman/bellek profili alınır; telefondaki ölçüm ayrıca yapılır. Mevcut1T test parası ve gerçek kayıtlar kullanılmaz/değiştirilmez. Politikalar tüm oyuncuları temsil etmez; sonuçlar dağılım ve sınırlılıklarıyla raporlanır.
Kabul: yeniden üretilebilir ölçüm aracı, başlangıç ve ilerlemiş kayıt sonuçları, sıfır katkı/yeni ilçe/prestige kenar durumları. Rapor tahminleri doğrulandı/yanlış/henüz belirsiz olarak ayrılır.

### R2 — Kayıt ve çevrim dışı performans
R1 taban ölçümünden sonra teslimat olan her karede diske yazma yerine sınırlı otomatik kayıt; satın alma/kimlik/ilçe/prestige ve Android duraklatma/kapatma kritik kayıtları korunur. Rota mesafesi ilçe+alım+bırakma anahtarıyla önbelleğe alınır; ücret/hız önbelleğe yanlışlıkla sabitlenmez. RNG akışı, göç ve kazanç aynı kalmalı. Ağır dönüş çok uzunsa aynı olay sonuçlarını koruyan parçalı işlem değerlendirilir; yaklaşık kazanç kestirmesine hemen geçilmez.
Kabul: kayıt yazma sayısı ve4saat dönüş süresi önce/sonra; açık/kapalı eşitlik; yarım kayıt/yedek, satın alma sonrası zorla kapatma ve geri dönüşte çift ödeme testleri. İşletim sisteminin ani öldürmesi ile normal duraklatma ayrılır; sıfır kayıp garanti edilmez.

### R3 — Yatırım kararları ve dürüst açıklamalar
Tüm filo/hizmet/prim/konfor/operasyon kartlarında mevcut→sonraki etki, talep/kapasiteye bağlı tahmini marjinal ₺/sn ve yaklaşık geri ödeme. Sıfır katkıda sayısal süre yerine 'Mevcut talep karşılanıyor' açıklaması. Hizmette gerçek toplam çarpan ve bir sonraki seviyenin mevcut gelire göre artışı gösterilir; +25 yüzde puan baz etkisiyle +%25 mevcut gelir karıştırılmaz. İş profili kuyruğa kabul anında kilitleniyor ifadesi ve etki gecikmesi açıklanır. Kaçan talep zaman aralığıyla gösterilir; kesin kayıp TL veya baskıcı kırmızı uyarı yok.
Kabul: her kartın karşılaştırması aynı simülasyon kurallarıyla tutarlı; büyük sayılar ve uzun Türkçe metinler iki telefon oranında sığar; yeni oyuncu düşük getirinin nedenini anlayabilir.

### R4 — Ölçüme göre ekonomi ve ilerleme revizyonu
R1 verileriyle erken/orta/geç oyun kararları düzenlenir. İlk10dk, ilk ilçe ve ilk itibar hedefleri kullanıcıyla somutlaştırılır; evrensel doğru süre varsayılmaz. Hizmet/prim ile konfor/operasyonun birbirini tekrar eden rollerine ayrı amaç veya aşamalı açılma tasarlanır. Araba/diğer roller her durumda en iyi olmak zorunda değil; kullanışlı oldukları ölçülebilir durum olmalı. Yüksek ilçe daha güçlü talep sunarken yetersiz filoda daha kötü olabilir; karşılaştırma bunu söylemeli. Prestige'i sadece o an Beyoğlu'nda durmaya bağlamak yerine son ilçe açılmış+tur hedefi alternatifi önerilir. Kabul edilmiş işlerin değerleri korunur; gerekiyorsa sürümlü ekonomi göçü hazırlanır.
Kabul: birden fazla makul yatırım yolu, anlaşılır yakın/uzak hedef, boşa alım uyarısı; yeni ve eski kayıt testleri; itibar sonrası5turda hedef kaybının ölçümü.

### R5 — Sabit haritada ölçülü canlılık
Harita sabit kalır. Teslimat gerçekleşince birleştirilmiş kısa +₺/paket vurgusu, satın alma ve ilçe açılışında anlaşılır geri bildirim. İsteğe bağlı kısık ses ve titreşim, ayrı kapatma ayarları; çoklu teslimatta üst üste efekt/telefon titremesi yok. Çevrim dışı binlerce teslimat için olay başına efekt oynatılmaz. FPS/RAM kontrolü yapılır. Oyuncunun sürekli tıklamasını gerektiren mekanik yok.
Kabul: görsel taslak önce kullanıcı onayı; okunaklı efektler, düşük cihazda30FPS hedefiyle ölçüm, sessiz/titreşimsiz tercih korunur.

### R6 — Kontrollü kod sadeleştirme ve kapsamlı güncel testler
Önce davranış testleri; ardından HUD/şirket akışı, ekonomi/teklif, kayıt-göç ve harita sunumu küçük modüllere ayrılır. Kullanılmayan çizimler ve gizlenerek taşınan kontroller çağrı bağımlılığı doğrulandıktan sonra kaldırılır. Eski göç motoru gerekli olduğu sürece tutulur. Tarihsel testler arşivlenir; güncel kabul kapısı Android geri/duraklatma, dönüş/ilk kurulum, tüm yatırımlar, ilçe/prestige, kayıt sürümleri ve saat kenar durumlarını kapsar. 'Beş test betiği' beş tek assertion anlamına gelmez; gerçek kapsam listelenir.
Kabul: refaktör öncesi/sonrası deterministik kayıt ve simülasyon eşitliği; gerçek telefon temel akış kontrolü. Tek seferlik büyük main.gd yeniden yazımı yapılmaz.

### R7 — İleri oyun ve yayın hazırlığı (ayrı kapsam)
Önce birkaç tur boyunca temel döngü onaylanır. Sonra ilçe uzmanlığı veya kalıcı araştırma gibi bir anlamlı yeni karar sistemi tasarlanır; yalnız sayısal çarpan ekleme hedef değil. Klan/gacha/sezon bileti öncelik değil. Yayın zamanı release imzası, AAB, cihaz yelpazesi, kesintiler ve mağaza gereksinimleri ayrıca doğrulanır. Bu aşama otomatik yayın/hesap işlemi yetkisi vermez.

## Şimdilik yapılmayacaklar
Hareketli kurye haritasına dönüş; ölçmeden tüm katsayıları değiştirme; kaçan siparişi kasadan para kaybı gibi gösterme; doğrulanmadan89dk sonucuna göre prestige eşiği koyma; göç kodunu topluca silme; reklam/bildirim/mağaza yayını başlatma.

## R1 sonucu — tamamlandı
İlk uygulanan aşama R1 ölçümüdür; rapor docs/r1-olcum-raporu.md.45tur ve performans/kayıt tabanı tamamlandı, nihai hata listesi boş. Oyun katsayıları ve runtime kodu değişmedi. R2 henüz başlamadı; kullanıcı kontrolü bekleniyor. R1 bulguları sonraki uygulamaları yönlendirir, ilk tur için91–98dk otomatik tasarım hedefi değildir.

## R2 sonucu — tamamlandı
Kayıt/rota optimizasyonu ve önce-sonra doğrulaması tamamlandı; docs/r2-optimizasyon-raporu.md. Ekonomi/görseller/şema aynı. R3 henüz başlamadı; kullanıcı kontrolü bekleniyor.

## R3 sonucu — tamamlandı
Yatırım kartları, kuyruk/karşılanamayan talep ve katkı/geri ödeme açıklamaları tamamlandı; docs/r3-yatirim-kartlari.md.6kabul betiği geçti. Fiyatlar ve ekonomi aynı. R4 henüz başlamadı; kullanıcı kontrolü bekleniyor.

## R4 sonucu — tamamlandı
İlk ölçümlü ekonomi/ilerleme revizyonu tamamlandı. Kullanıcı ilk itibar için1,5–2saat tercihini verdi; nihai yeni tur hedefi650K, normal politikalar105–115dk. Eski mevcut220Khedef ve kazanılmış hız korunur.55tur+7kabul betiği+donmuş0.20kaynak göç denetimi geçti. Güncel sözleşme docs/sirket-modeli-v3.md, rapor docs/r4-ekonomi-raporu.md. R5 henüz başlamadı; kullanıcı kontrolü bekleniyor.

## R5 ilk uygulama sonucu — tamamlandı
Sabit haritada tekil birleştirilmiş teslimat/alım/açılış bildirimi, varsayılan kapalı ses/titreşim tercihleri ve Android izni uygulandı. docs/r5-geri-bildirim.md.8kabul betiği geçti; gerçek telefon sesi/titreşimi ve FPS/PSS doğrulanmadı, kullanıcı incelemesi bekliyor. R6 başlamadı; kullanıcı kontrolü için duruldu.

## R6 sonucu — tamamlandı
Kontrollü kodtemizliği ve modül ayrımı tamamlandı; docs/r6-kod-temizligi.md.9kabulbetiği,6profil/4saateşliği ve10pikselçifti geçti. Eski kayıt göçü ve canlı rehber korundu. R7 henüz başlamadı; kullanıcı kontrolü bekleniyor.

## R7 güncel durum — R7.1 tasarım tamamlandı
Kullanıcı R7'ye geçişi istedi. Mevcut itibar, şirket çekmecesi ve ekonomi kodları incelendi; docs/r7-ileri-oyun-tasarimi.md uzmanlık tasarımı, aday katsayılar, ekran akışı, eski kayıt/atomik işlem kuralları ve kabul kapılarını içerir. İlk itibar sonrası tur başına Mahalle Ağı / Ekspres Hat / Dağıtım Merkezi veya Standart seçimi önerilir. İlk tur değişmez; yeni para birimi/harcanan itibar yoktur. Katsayılar henüz ölçülmedi, runtime/APK değişmedi. R7 tümü tamamlanmadı. Kullanıcı kontrolü için DUR; devam sonrası R7.2 uygulama ve göç/testler, ardından ayrı R7.3 çoklu tur dengesi/görsel onay/cihaz kontrolü. Yayın ayrı kapsamdır.
