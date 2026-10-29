# R6 — Kontrollü kod temizliği ve kabul kapsamı

Tamamlandı:0.23.0-r6/code23. Ekonomi7/şema8,1,5–2saat ilk-itibar hedefi,650K yeni tur/korunan220Keski tur, görseller, ses tercihleri ve gerçek oyun döngüsü aynı. Bu aşama yeni içerik veya denge değişikliği değildir.

## Yapılanlar

-Çağrı denetiminde mevcut runtime dışından çağrılmadığı doğrulanan27eski hareketli harita/kurye/izometrik çizim fonksiyonu kaldırıldı. Kaynakların önceki hali build/r6/baseline altında korunur. Eski sanat varlıkları silinmedi.
-Artık yalnız oluşturulup gizlenen kişisel kurye araç/hizmet/ekip düğmeleri, eski şirket paneli, durum/progress etiketleri ve zoom/odak kontrolleri oluşturulmuyor. Kullanılmayan çizim tamponları ve bazı eski preload'lar kaldırıldı.
-scripts/hud_presenter.gd üst barın kurulum/güncelleme/çizimini; scripts/static_map_view.gd sabit harita kırpma/konum projeksiyonu/işaretçi çizimini üstlendi. Önceden ayrılmış CompanyUI, GameFeedback, Economy, Dispatch ve SaveStore korunur. Ana dosya2913→1967satır(boş satırlar dahil); yaklaşık%32,5azalma. Bu aktarımın bir kısmı yeni modüllere taşımadır, tamamı kaldırılmış kod değildir.
-17tarihsel kişisel-kurye/A1–A9testi tests/archive içine kaynak ve UID dosyalarıyla taşındı. İlgili beş eski shell wrapper arşiv yoluna güncellendi; bunlar güncel kabul koşusu değildir. Paylaşılan failing_save_store yardımcısı güncel başarısız işlem testinde kullanıldığı için tests/altında kaldı.
-İlk üst-bar prototipindeki kullanılmayan header_style.gd ve UID metin olarak docs/archive içine alındı; çalışma zamanı dışındadır.

## Özellikle korunanlar

Eski çizimin kullanılmaması, eski kayıt motorunun gereksiz olduğu anlamına gelmez. legacy_dispatch.gd, eski katsayılar, kayıt sürüm geçişleri, kamera/araç gibi kayıt uyumluluğu alanları ve eski işlerin ücret/hızları korunur. Kayıt/göç koordinasyonu sırf satır sayısını azaltmak için yeniden yazılmadı. Ana dosya hâlâ oyun koordinatörüdür; tamamı küçük dosyalara bölündü iddiası yok.

Rehberin gizli ana düğmesi artık kullanılmıyordu; ancak dönüş ekranının üçüncü önerisi rehberi açabiliyor. Bu çağrı tespit edilerek rehber paneli/içeriği/geri davranışı ve guide_seen kaydı korundu. Güncel şirket yönetimi rehberi halen erişilir. Eski kişisel kurye rehber adımları kaldırıldı; kullanıcı kaydı yüklenirken ekonomi7'ye geçiş UI kurulmadan önce tamamlanır.

## Kabul testleri

tools/test_company.ps1 güncel9betiği geçti: company_model, company_layout, investment_preview, economy_v7, game_feedback, transition_regressions, number_format, save_store, isometric_projection. Her biri ayrı geçici APPDATA kullanır, çıkış kodu ile SCRIPT ERROR/ERROR logları birlikte kontrol edilir.

Yeni transition_regressions şunları doğrular:
-Android geri sırası: yatırım çekmecesi, ayarlar, albüm→ilçe seçimi, ilçe ekranı ve canlı rehber.
-8saat yokluğun4saatlik gerçek simülasyonla aynı kazanç/RNG'yi vermesi ve dönüş ekranının alttaki çekmeceyi kapatması.
-Saat geriye alındığında negatif/çift ödeme olmaması; mevcut ileri zaman damgası kuralı korunur, saat manipülasyonu tamamen çözülmüş sayılmaz.
-Duraklatmada oyun işleminin durması ve sıfır süre dönüşte tekrar kazanç olmaması.
-Depolama başarısızlığı enjekte edilen prestige'nin hiçbir ilerleme/kimlik/iş değişikliği yapmaması; reset ve prestige onayından geri dönmenin işlem yapmaması. Bu fiziksel elektrik kesintisi/Android OS-kill deneyi değildir.

## Önce/sonra eşliği

0.22runtime scriptleri ve giriş sahnesi build/r6/baseline içinde donduruldu; yalnız yerel script bağımlılıkları bu donmuş kopyalara yönlendirildi. original-sha256.json yönlendirme öncesi hash'leri, frozen-sha256.json kullanılan kopyaları kaydeder. tools/run_r6.ps1 bunların hash'ini kontrol eder; güncel kaynakla sahte eski taban oluşturulmaz.

tools/verify_r6.gd altı profil karşılaştırdı: yeni şirket, gelişmiş şirket, ekonomi0/2/5/6eski kayıtlar. Eski şema numaraları ham JSON yazılarak korunur; test kaydı okunmadan önce güncel write_record ile yükseltilmez. Yükleme/göç sonrası ve4saat simülasyon sonrası _save_data içerikleri eşleşti. Kasa, filo, bütün yükseltmeler, RNG, aktif/bekleyen işler, tur hedefleri, hız alt sınırı, tercihler ve ekonomik olay zamanları dahil edildi. Sadece sistemin gerçek duvar saatine bağlı last_saved_at ve olay unix_seconds alanları karşılaştırmadan çıkarıldı. Dosyalar gerçek telefon kaydı değil, aynı eski runtime ile kurulmuş test profilleridir.

Her profilde başlangıç düğümü183→144oldu:39daha az düğüm. Bu ölçüm telefon RAM/PSS/FPS veya APK boyutu kazancı olarak sunulmaz; kullanılmayan kaynak sanat dosyaları halen proje içinde korunur.

tools/capture_r6_compare.gd aynı kurulumla eski/yeni sürümün harita, şirket çekmecesi, ayarlar, rehber ve dönüş ekranını480×800/1040oranlarında yakaladı.10görünüm çiftinin ham RGBA SHA256'ları eşleşti; piksel farkı0. Ekranlar build/r6/screens, sonuçlar pixel-results.json içindedir. state-results.json ve removal-audit.json durum ve kaldırma denetimini içerir. Nihai hata listeleri boştur. Yeni ekranlar ayrıca gözle kontrol edilir.

## Sınırlar ve devir

Telefon kurulumu veya gerçek cihaz performans/ses/titreşim testi yapılmadı. Telefonun kaydı ve test parası değiştirilmedi. R5’in fiziksel ses/titreşim kontrolü hâlâ bekliyor. APK aynı test paketi/imzasıyla güncellendi; görsel veya denge farkı beklenmez. Kullanıcı kontrolü için DUR.

Sıradaki R7, itibar sonrası kalıcı hedefler/ileri oyun tasarımıdır. Yeni canlı sistem veya mağaza yayını otomatik başlamaz. İlerideki modülerleştirme bu eşlik testleri korunarak yapılmalıdır; tek seferlik ana dosya yeniden yazımı önerilmez.
