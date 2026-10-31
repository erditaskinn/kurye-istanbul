# 0.30 — Okunaklı kartlar ve gerçek telefon kontrolü

Kullanıcının beş maddesi uygulandı. Sayısal ekonomi/şema11 değişmedi; sürüm0.30.0-readable-cards/code30.

1. Güvenli alan kök ölçeklemesi korunur; metin boyutu scale.x ile telafi edilir. Temel gövde/fiyat alt sınırı14mantıksalpiksel kalır; 0.9ölçekte16puan seçilerek14.4etkin boyut sağlanır. Bu ekran pikseli/Androiddp eşitliği veya tüm cihazlarda aynı fizikselboyut iddiası değildir. Yazıyı sıkıştırmak yerine yatırım kartı176→280yükseklik, fiyat düğmesi124→376genişlik/48yükseklik; dikeykart aralığı292. Diğer kontrollerin açıklama alanları ve scroll minimumları uyarlandı.

2. Gövde/metinler enaz14; fiyat15, kartbaşlığı18. Dar görünümde metin minimumu ayrıca testlenir. İlk ekran sipariş açıklaması üç satır yerine iki satırdır; büyük metnin kartın altına gizlenmesi önlendi.

3. ₺yetersizse fiyatın yanında eksik miktar yazılır. Pasif fiyat/metin e0d6bdile daha açık gösterilir; tıklama hâlâ engellenir. Motivasyonun eksik yıldız metni aynı kontrastı kullanır. Tam genişlik düğme metin için alan açar.

4. HUDcaption51→55, sayılar72→76; sayı varsayılanı18, Türkçe/₺yedekfont korunur. Üç kutu telefon ekranında gözle incelendi. Büyük sayılarda kısaltma ve minimum font sınırı sürer.

5. Fiziksel SM-A505F/Android11/1080×2340 cihaz bağlıyken APK güncellendi. Önce build/device-backup/before-readable-cards-* kaydı alındı; ilk kurulum sonrası hashaynen doğrulandı. Son küçük düzeltme de aynıpaket/imzayla install-rbaşarılı. TelefonversionCode30doğrulandı.

## Gerçek cihaz kontrolleri

ADBile yalnız oyun odaktayken ekran yakalandı; WindowsComputerUseçalıştı iddiası yoktur. Oyun menüsü, dönüş özeti, normal harita, Filo, Şirket, isim alanı ve Androidklavyesi kontrol edildi. İsim veya logo değiştirilmedi, satın alma/ödülalma/ilçedeğişimi yapılmadı. Doğalidle/çevrimdışıkazanç ilerledi; bu nedenle oynanışsonrası kayıtbaşlangıçhash'inin aynıolması beklenmez.

Gerçek testte iki ek kusur bulundu ve düzeltildi: yatırım/motivasyon/başarımkart panelleri dokunmatikkaydırmayı ScrollContainer'a geçirecek şekilde PASS; ilkilçeipucu görünürken teslimatbildirimi çizilmez. Son cihaz ekranında kart üzerinden touchscreen-swipe sonrası Yaya kartından Bisiklet/Motor'a ilerleme doğrulandı. Kaydırma altbarın üzerine taşmadı.

Klavye açıldığında isim alanı görünür; logo ve kaydet alanı klavyenin arkasında kalır, klavyenin gerçek Tamam tuşu ile klavye kapanır ve tüm forma dönülür. FizikselEnterenjeksiyonu aynı IMEeylemi değildir; bunu ayrıca testsonucu gibi saymadık. Her Androidklavyesi/çentik/çok kısaviewport doğrulanmadı. Bu test 20–30dk bağımsızeğlencetesti değildir.

Kanıtlar build/device-0.30/: start,continued,map,fleet,company,keyboard,ime-done,after-keyboard-back,final-fleet-before/after PNG; runtime.log. Kullanıcının gerçek testşirketini içeren bu görüntüler bu aşamada GitHub'a yüklenmedi. runtime.log0oyunhatası; imza/hizalama geçti.

## Test kapısı

İlk yerleşim koşusunda14betik temiz geçti. Son paneller/PASS ve ipucu-bildirim düzeltmesinden sonra davranışkontrolleri geçiyor; aralıklı unlock.wavkapanışkaynağı uyarısı game_feedback sonunda strictkapıyı yine durdurdu. Bu sorun filtrelenmedi veya çözüldü denmedi. Kapısonrasındaki transition_regressions/number_format/save_store/isometric_projection ayrı temiz tamamlandı. Yeni efektifminimumfont/fiyatgenişliği/eksiktutar assertionları mobile_polish'te geçti.

0.30telefonda yüklü ve Filo ekranında kullanıcı kontrolüne hazır. USB çıkarılabilir. GitHub güncellenmedi; son uzak sürüm0.29. Kullanıcı incelemesi için DUR. Kalan ayrıiş: aralıklı masaüstü seskapanışıuyarısı, cihaz çeşitliliği ve insanoyuncu geribildirimi.
