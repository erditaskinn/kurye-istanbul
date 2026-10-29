# A9 — Android APK ve gerçek cihaz kontrolü
28 Ekim 2026. Windows derlemesi ve ilk gerçek cihaz kontrolü tamamlandı. Kullanıcının serbest oyun denemesi bekleniyor; mağaza yayını yapılmadı.

## Teslim edilen APK
- Dosya: `build/istanbul-kurye-a9-test.apk`
- Boyut: 59.726.024 bayt, yaklaşık 56,96 MiB.
- Sürüm: 0.12.0-a9, versionCode 12.
- Paket: com.erditaskinn.istanbulkurye.a9test.
- Telefon etiketi: İstanbul Kurye Test.
- Mimari: yalnız arm64-v8a; minimum Android API 24, hedef API 36.
- SHA-256: 06c4d24a65d800f3166b325765147f7fb1c69d68bbda35027598a4b32c89bbd6.
- APK imzası ve 16 KiB ZIP hizalama kontrolü geçti.

Telefonda mevcut com.erditaskinn.istanbulkurye / 0.11.0 sürümü bulundu. Eski imza anahtarı bilgisayarda olmadığı için asıl uygulama kaldırılmadı veya üzerine farklı imza kurulmaya çalışılmadı. Ayrı test paketi kuruldu. Eski APK ve kayıt önce `build/device-backup/` altında yedeklendi. Eski kayıt yalnız test uygulamasına kopyalandı. Test sonunda asıl oyunun kayıt dosyası, başlangıç yedeğiyle SHA-256 olarak birebir aynıydı.

Bu APK debug imzalı test paketidir. Mevcut mağaza/üretim paketinin imza anahtarı yerine geçmez. Yayın imzası ve mağazaya yükleme ayrı iştir. Test uygulamasında yapılan yatırımlar asıl eski uygulamaya yazılmaz.

## Windows araçları
Android SDK zaten C:/Users/erdit/AppData/Local/Android/Sdk altında kuruluydu. SDK yeniden indirilmedi. Java 17 yolu ve Godot Android şablonu eksikti. Resmî Temurin OpenJDK 17.0.20.1+1 ZIP'i SHA-256 kontrolüyle `.tools/java/` altına açıldı. Resmî Godot 4.6.3 şablon arşivinden yalnız android_debug.apk ve version.txt HTTP aralık isteğiyle alındı; ZIP üyesinin CRC kontrolü geçti. Tüm 1,26 GB şablon paketi indirilmedi. İndirilen Java arşivi ve derleme profili dahil .tools yaklaşık 604 MiB'dir; D: üzerindedir.

`.tools/build-profile` Godot ayarlarını, `.tools/android-user/debug.keystore` test imzasını tutar. Kullanıcının gerçek Godot ayar dosyası değiştirilmedi. ADB için telefonun önceden izin verdiği kullanıcı anahtarı kullanılır. Yeni derleme imzası kaynak paketine eklenmez; .tools/.gdignore ve .gitignore ile dışarıda tutulur.

Tekrar derleme:

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_android.ps1
```

Varsayılan preset Android A9 Test'tir. Godot/SDK/Java yolları parametreyle değiştirilebilir. Betik kaynakları içe aktarır, APK üretir, konsol hatalarını kontrol eder, imza/hizalama/badging/hash sonuçlarını build/android altında yazar. Eski Linux betiği ayrı ortam içindir; bu bilgisayarda Windows betiği kullanılır.

Kaynaklar: [Godot 4.6 Android dışa aktarma belgesi](https://docs.godotengine.org/en/4.6/tutorials/export/exporting_for_android.html), [resmî Godot 4.6.3 paketleri](https://github.com/godotengine/godot-builds/releases/tag/4.6.3-stable), [Temurin 17 Windows paketi](https://github.com/adoptium/temurin17-binaries/releases/tag/jdk-17.0.20.1%2B1). JDK SHA-256: e53a79c3c3d86865bd7e787903884331068e71321714ffd44f145785affc7cb0.

## Bu aşamada düzeltilenler
1. Gerçek Android duraklamasında application_suspended koruması eklendi. Arka plandayken _process para/süre üretmez; dönüşte ortak çevrim dışı motoru bir kez hesaplar.
2. Android geri tuşu öncelikle açık onay/özet/rehber/ayar/albüm/ilçe/ekip/bilgi panelini kapatır. Ana oyundan menüye döner; menüden çıkarken kayıt yapılır. İstenmeden sıfırlama veya itibar onayı vermez.
3. Mobilde Engine.max_fps=30 uygulanır. Sabit haritalı idle görünüm için gereksiz yüksek çizim hızı sınırlandı; gerçek pil tüketimi yüzdesi ölçülmedi.
4. Albümün gerçek dokunmatik kaydırmasında sorun bulundu: içerik Control'ü dokunmayı ScrollContainer'a geçirmiyordu. MOUSE_FILTER_PASS ile düzeltildi. Son APK'da ADB'nin gerçek dokunma sürüklemesiyle alt kartlara kaydırıldığı ekran görüntüsünde doğrulandı.
5. Eski kayıt açıklaması oyunun lacivert/kehribar temasına uyarlandı. APK'dan docs/tests/tools/teslimat/.tools ve diğer geliştirme klasörleri çıkarıldı. APK ZIP kontrolünde bu klasörlerden dosya bulunmadı; gerekli sile.json ve arm64 kütüphaneleri mevcut.

Ekonomi sürümü 5 ve kayıt şeması 6 bu aşamada değişmedi.

## Gerçek cihazda yapılan kontrol
Cihaz: Samsung Galaxy A50 / SM-A505F, Android 11 API 30, 1080×2340, arm64, Mali-G72 OpenGL ES 3.2. Test için emülatör kurulmadı.

| Kontrol | Gözlenen sonuç |
|---|---|
| Kurulum ve açılış | Ayrı test paketi kuruldu, menü ve harita açıldı |
| Eski gerçek kayıt | 115 ₺ korunup eski yaya çevrim dışı tarifesiyle 4 saat için 1.200 ₺ eklendi; kasa 1.315 ₺, şema 6/ekonomi 5 |
| Göçte ilerleme | Şile etkin kaldı, Beykoz açıldı; başlangıç sermayesi veya şirket iadesi yanlışlıkla tekrar verilmedi |
| Kabul edilmiş eski iş | Eski 54 ₺ teklif sonraki teslimatta korundu; yeni işler yeni ekonomiyi kullanıyor |
| Dokunma | Araç/hizmet alımı ve yaya işe alımı kayda doğru işlendi |
| İlçe/keşif | Beykoz etkinleştirme ve ikinci kartpostal görüldü |
| Albüm sürükleme | Son APK'da üst kartlardan Beşiktaş/Şişli/Beyoğlu tarafına gerçek dokunmayla kaydı |
| Geri tuşu | Özet/ekip/albüm/ilçe/itibar önizlemesi oyun kapanmadan geri alındı |
| İtibar | Kilitli önizleme açıldı ve iptal edildi; gerçek oyuncu için itibar harcanmadı/reset yapılmadı |
| Arka plan | Aynı süreç 123 sn arka planda kaldı; kaydın baytları değişmedi |
| Dönüş kazancı | 146 ₺ kurucu + 156 ₺ ekip = 302 ₺; kasa 1.383 → 1.685 ₺ |
| Bağımsız tekrar hesap | Aynı cihaz kaydı ve 123 sn, bilgisayarda replay_android.gd ile yine tam 302 ₺ verdi |
| Ekran kilidi | Telefon kilitlenip uyandırıldı; kullanıcı kilidi kendi açtı. Kasa, araç/hizmet/ekip ve kayıt korundu |
| Soğuk başlangıç | Güncelleme sonrasında veri silmeden yeniden açıldı, ilerleme korundu |
| Hata günlüğü | Kontrol edilen son oyun süreçlerinde SCRIPT ERROR/ERROR/FATAL EXCEPTION bulunmadı |

Çizim yüzeyinin son 60 örneğinde medyan aralık 33,40 ms, yaklaşık 29,9 FPS idi. Bir ölçümde toplam PSS 304.872 KiB, son ölçümde 300.815 KiB; yaklaşık 294–298 MiB. Son RSS 364.772 KiB. Bu kısa örnekler hedef cihazda çalışmayı gösterir; uzun pil/ısınma testi veya bütün Android cihazlar için garanti değildir.

Güncellemenin bir açılışında Android başlatıcı bekledi. Test uygulaması verisi silinmeden force-stop sonrası soğuk başlatıldı ve açıldı; engine hata kaydı görülmedi. Bu nedenle bütün cihazlarda ve her güncellemede sabit açılış süresi iddiası yapılmaz. USB/ADB yeniden yetkilendirmesi gerektiğinde eski kullanıcı anahtarına dönüldü; kullanıcının eski oyun anahtarı veya verisi silinmedi.

Gerçek telefonda dört saat beklenmedi. 4 saat sınırı, eski gerçek kaydın göç hesabı ve masaüstü ortak motor testleriyle kontrol edildi. Fiziksel güç kesintisi/depolama arızası ve uzun süreli ısı/pil ölçümü yapılmadı.

## Otomatik kontroller ve kanıtlar
18 test betiği geçti: android_lifecycle, balance_metrics, prestige, district_choice, district_progression, simulation_clock, strategic_economy, return_choices, onboarding, offline_summary, delivery_status, delivery_flow, staff_progression, map_camera, menu_reset, save_store, isometric_projection, progression_ui. Her betik geçici APPDATA ile gerçek bilgisayar kaydından ayrıldı; SCRIPT ERROR/ERROR satırları hata sayıldı.

`tests/android_lifecycle.gd` yeni duraklama korumasını, aynı ayrılığın tekrar ödenmemesini, geri tuşu panel sırasını, reset/itibar iptalini ve menüye kayıtlı dönüşü doğrular. Gerçek cihazın 123 sn hesabı `tools/replay_android.gd` ile ayrıca eşlendi.

`tools/device_check.py` yalnız izin verilen iki kurye paketi üzerinde kayıt/log denetimi yapar; ekran görüntüsü almadan önce oyunun odakta olduğunu kontrol eder. Cihazdaki kişisel uygulamalara erişen bir test akışı yoktur. Günlük ve ekran kanıtları build/device-check, APK imza/align sonuçları build/android altındadır. Son özet build/device-check/a9-summary.json içindedir.

Önemli görüntüler: a9-main.png, a9-real-return.png, a9-district.png, a9-final-album-scrolled.png, a9-background-return.png, a9-after-unlock.png, a9-final-playable.png. Ekranlar gözle incelendi; A50'nin portre alanında metin/paneller sığıyor. Kullanıcının parmakla rahat kullanım değerlendirmesi ayrıca bekleniyor.

## Son durum / kullanıcıya devir
Son test APK'sı telefonda “İstanbul Kurye Test” olarak kurulu. Eski “İstanbul Kurye” aynen duruyor. Son kontrolden sonra test oyunu oynanabilir ekranda bırakıldı; kullanıcı telefonu kullanabilir, USB'yi çıkarabilir. A9 sonunda DUR.

A1–A9 teknik uygulama zinciri tamamlandı; A4/A8 küçük kullanıcı anlama/eğlence denemesi otomatik testlerle kapanmış sayılmaz. Sıradaki iş kullanıcının serbest oyun geri bildirimi, ardından bildirilen sorunlara göre rötuştur. Mağaza yayını, gerçek yayın anahtarı, çoklu cihaz testi veya yeni sistem ekleme kendiliğinden başlatılmayacak.
