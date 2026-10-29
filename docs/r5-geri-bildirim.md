# R5 — Sabit haritada ölçülü geri bildirim

Uygulama tamamlandı:0.22.0-r5/code22. Ekonomi7/şema8, fiyatlar,650K yeni tur hedefi, eski tur korumaları ve sabit harita aynı. Fiziksel Android ses/titreşim hissi ve gerçek cihaz FPS/PSS kontrolü kullanıcı incelemesinde bekliyor.

## Ekranda ne değişti?

Harita üstünde yalnız kısa süre görünen tek piksel çerçeveli kart kullanılır. Gerçek normal oyun teslimatları aynı karede birlikte sayılır; kart örneği '2 teslimat • +29₺'. Bu ikinci bir ödül değildir, zaten kasaya eklenmiş gelirin özetidir. En fazla5sn’de bir teslimat kartı çıkar; aradaki tutarlar/adetler birleştirilir. Kart1,8sn görünür,6pxyükselir ve son0,4sn solar. Kurye haritada hareket etmez. Panel ve bütün çocukları mouse-filter-ignore; dokunma alanlarını kapatmaz. Tek panel/ikon/etiket/oynatıcı yeniden kullanılır; iş başına yeni düğüm oluşturulmaz.

Başarılı satın alımda yatırım/işe alım kartı gösterilir. Hızlı çoklu alımlar aynı kartta '3 yatırım tamamlandı' gibi birleşir. İlçe açılması normal canlı simülasyon adımında algılanır; son açılan ilçe tek bildirimle söylenir. İlçe/itibar açılışı ve alımlar teslimat kartına öncelik verir. Aynı karede gelirle açılış varsa gelir özeti açılışın ardından birleştirilmiş şekilde gelebilir; sesler katmanlaşmaz.

## Ses/titreşim

Varsayılan ikisi de kapalı. Ayarlar'da ayrı44pxdüğmeler var; tercihler anında kayıt edilir. Sıfırlama ve itibar tercihi değiştirmez. Ses açıldığında kullanıcı işlemine bağlı kısa örnek oynar; kapatılınca mevcut ses de durur. Titreşim açıldığında Android'de kısa örnek çağrısı yapılır.

assets/audio altında dış kaynaksız, tools/generate_feedback_audio.py ile üretilmiş3kısa PCM16mono/22050Hzses bulunur: delivery0,134sn, purchase0,201sn, unlock0,291sn. Fade zarfları/düşük tepe seviyesi ve-16dBoynatım uygulanır; müzik veya arka plan sesi yok. Aynı anda tek AudioStreamPlayer/polyphony1; genel ses çağrıları en az0,25sn aralıklı, teslimatlar ayrıca5sn aralıklı. Gerçek telefon ses şiddeti/hoparlör algısı headless testle doğrulanamaz.

Titreşim yalnız Android'de ve tercih açıkken alım/önemli açılışlarda18msçağrıdır; teslimatta titreşim yok. En az0,35sn aralığı var. Android presetlerinde VIBRATE izni açıldı. Telefonun titreşim motoru/OSayarları sonucu etkileyebilir; fiziksel his bu tur test edilmedi. Ses/haptik sayaçları yalnız test teşhisi için geçicidir, ağ veya oyuncu olay günlüğüne gönderilmez.

## Offline ve yaşam döngüsü

Efektler _advance_simulation/_apply_offline_income içine eklenmedi. Yalnız normal _process sonucundaki gerçekten tamamlanan iş raporu ve başarılı yatırım/itibar eylemleri bildirim üretir. Açılışta/eski kayıt göçünde/4saatlik dönüşte binlerce efekt oynatılmaz. Menü, dönüş ödül ekranı, şirket kuruluşu, ayarlar, ilçe/albüm ve onay pencerelerinde teslimat görseli birikmez. Android duraklatmada bekleyen bildirim ve ses kesilir. Ayarlar'da yalnız kullanıcının ses açma örneğinin bitmesine izin verilir; eski teslimatlar kuyruğa alınmaz. Sonraki yeni teslimatlar canlı akışa normal devam eder.

## Kaynaklar ve kayıt

scripts/game_feedback.gd kozmetik katmandır; oyun parasına, siparişlere ve RNG’ye yazmaz. main.gd yalnız sonuçları iletir, ayarları bağlar. feedback_settings.sound/haptics opsiyonel kayıt alanı olarak şema8’e eklendi; eski kayıtta yoksa kapalı varsayılır. Ekonomi veya yeni şema geçişi gerekmedi. Normal satın alma kaydı ve30sn rutin kayıt davranışı aynı.

## Doğrulama

Güncel8kabul betiği geçti. Yeni tests/game_feedback.gd:
-100teslimatı tek kart, sonraki49olayı5snsonunda tek birikimli kart yaptı; düğüm sayısı sabit.
-Hızlı3alım birleşti; sessiz tercihte ses/titreşim çağrısı olmadı; ses açma örneği,0,25snkısıtı ve kapatma denetlendi.
-Hem doğrudan4saat simülasyon hem gerçek _apply_offline_income girişi teslimat efekti üretmedi.
-Arka plan/ayarlar bekleyen efektleri temizledi.
-Kozmetik kanca ayrılmış oyun ile bağlı oyunun5dk gerçek _process akışında kasa/ciro/sipariş/RNG eşleşti.
-Tercihler gerçek kayıt/yeniden açılış, prestige ve ilerleme sıfırlamasında korundu; yükleme ses/bildirim üretmedi.
-480×800/1040ayar yerleşimi,44pxayar hedefleri ve harita dokunmalarını engellememe kontrol edildi.

Diğer7betik şirket, kayıt geçişi, uzmanlıklar/itibar, yatırım tahminleri, sayı biçimi ve harita yerleşimini doğrulamaya devam eder. Ayrı gerçek Android titreşim/duyumsal ses/FPS testi yapılmadı. Android paket imzası/hizalaması ve manifest izinleri derleme sonrası kontrol edilir.

Görseller tools/capture_r5.gd ile izole profilde gerçek teslimat/satın alım kancalarından alındı: build/ui-check/r5-delivery.png, r5-purchase.png, r5-district.png, r5-settings-off.png, r5-settings-on.png, r5-settings-tall.png. İlçe açılışı örneğinde hedefe yakın test cirosu ve alım örneğinde test sermayesi kullanılır; telefon kaydı değildir. Yakalama sürecinde yalnız o Godot uygulamasının ses veri yolu sessize alındı, sistem sesine dokunulmadı. Kart ve ayarlar gözle incelendi.

R5 ilk uygulaması tamamlandı; kullanıcı görsel/ses tercihi kontrolü için DUR. Telefon kaydı/test parası değiştirilmedi; bu tur APK yüklenmedi. Sıradaki R6 kontrollü kod sadeleştirme ve güncel test kapsamını güçlendirme; başlamadı. Mağaza yayını/reklam eklenmedi.
