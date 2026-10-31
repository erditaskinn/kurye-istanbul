# 0.31.0-phone-polish — gerçek telefon testi düzeltmeleri

31 Ekim 2026. Kaynak: `build/playtest-phone/RAPOR.md` içindeki 29 dakikalık Samsung A50 oturumu.

- Sekme düğmeleri geçişi input callback tamamlandıktan sonra gerçekleştirir. Böylece tıklanan içerik düğmesi olay işlenirken ağaçtan çıkarılmaz. Son fiziksel Şirket → Başarımlar geçişinde hata tekrarlanmadı; son oyun sürecinde SCRIPT ERROR/ERROR/FATAL EXCEPTION sayısı0.
- Etkileşimsiz tüm ilerleme çubukları mouse input'u yok sayar; sürükleme ScrollContainer'a ulaşır.
- Başarımlar açıldığında alınabilir ödüller en üsttedir, alınmışlar en sondadır. Ödül alırken satır sırası sabit kalır; tekrarlı dokunmanın başka ödüle kayması önlenir.
- HUD rakamları daha küçük başlangıç minimumuyla kurulup yukarı alındı; okunur son font boyutu korunuyor. Ayarlar paneli/metin alanı büyüdü; sıfırlama düğmesi açıklamadan ayrıldı.
- Filo ve Geliştir'in başında rol/bedel/gelir artışı karşılaştırmaları bulunur. Bunlar satın almaz: ilgili büyük karta kaydırır. Asıl satın alma düğmesi tam genişlikte kalır.
- Masrafı çıkarma süresi dakika/saniye; kurye süresi yaklaşık tam saniye gösterilir. K/M/B/T korunur.
- Haritadaki simgeler 32 yerine24 tasarım pikseli çizilir. Çerçeve yalnız seçili/hedef noktada gösterilir; dokunma alanı44 piksel kalır. Yeni resim varlığı üretilmedi; mevcut ikon sistemi düzenlendi.
- Sabit haritada kalıcı filo portre/sayı şeridi ve Hizmet/Prim seviyeleri görünür. İkon atlasının doğal boyutunun kontrolü büyütmemesi için expand_mode texture atamasından önce belirlenir. Panel açıkken şerit gizlenir.
- İlk motivasyon seviyesi3 yıldız; seviye1'den sonraki fiyatlar eski formülle devam eder (15,22,...). Her seviyenin kalıcı+20 yüzde puan etkisi,20 seviye sınırı, sonraki turda korunması ve itibar650K/+25% koşulları değişmedi. Mevcut seviye/yıldızlar yeniden yazılmaz; yeni kayıt alanı/migration yok. Daha erken bonus toplam ilerleme süresini etkileyebilir; 1,5–2 saat hedefine yönelik yeni gerçek oyuncu ölçümü henüz yapılmadı.

Doğrulama: `tools/test_company.ps1` artık15 test grubu çalıştırır. Son çalıştırmada15'i de geçti; SCRIPT ERROR/ERROR eşleşmesi yok. Yeni `tests/phone_polish.gd` deferred geçişi, hazır ödül sırasını, çubuk input'unu, satın almayan karşılaştırmayı, ilk3 yıldız yükseltmesini ve ikonların sınırlı boyutunu kapsar. APK aynı debug anahtarıyla imzalandı; imza ve16KB zip hizası doğrulandı.

Kullanıcının `com.erditaskinn.istanbulkurye.a9test` kaydı kurulumdan önce yedeklendi; ilk güncellemeden sonra bayt bayt aynı olduğu doğrulandı. Yedek: `build/phone-polish-0.31/before-install.json`. Kayıtta şirket kurulmamıştı; kullanıcı adına şirket oluşturulmadı. Fiziksel UI kontrolleri ayrı `com.erditaskinn.istanbulkurye.playtest` / MaviKurye kaydında yapıldı. Son paket kullanıcının uygulamasına güncelleme olarak yüklendi; kaldırma/sıfırlama yapılmadı.

Yerel kanıtlar: `build/phone-polish-0.31/final-tests.log`, `targeted.log`, `final-build.log`, `device/`. Telefonda filo karşılaştırmasının dördü aynı anda okunuyor; başarımlarda hazır ödül üstte ve çubuğun üzerinden sürükleme listeyi kaydırıyor. Bu kısa yama doğrulamasıdır; tekrar29 dakikalık yeni oyuncu araştırması değildir. GitHub'a gönderim yapılmadı.

Son telefon doğrulaması: 0.31.0-phone-polish / versionCode31 kurulu. `device/11-final-map.png` şeridin sınırlı portrelerini, `12-final-settings.png` açıklama boşluğunu, `16-final-achievements.png` son geçişi gösterir. `device/final-runtime.log` temiz. `final-user-save.json` ile orijinal ilerleme alanları eşit. Ayrı test uygulaması durduruldu ve kullanıcının İstanbul Kurye Test uygulaması öne getirildi.
