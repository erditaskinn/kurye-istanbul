# İstanbul Kurye — 0.23.0-r6

Mobil, portre, Godot4.6.3 idle kurye şirketi. Güncel ürün sözleşmesi docs/sirket-modeli-v3.md, araştırmanın özgün metni docs/idle-arastirma-notlari.md, aşama geçmişi docs/gelistirme-plani.md içindedir.

Oyuncu şirket adı ve9 logodan seçim yapar. Bir ücretsiz yaya ve60 ₺ ile başlar; şirketine yaya/bisiklet/motor/araba ekler. Ayrı kişisel kurye/araç ve5 teslimatlık ekip kilidi artık yoktur. Alt çubuk Geliştir / Motivasyon / Şirket / Ayarlar. Ana harita açık kalır, yatırım listeleri tek alt çekmecede açılır.

Geliştir bölümünde hizmet ve prim ücretleri, Motivasyon'da çalışma konforu, Şirket'te filo ve operasyon hızı büyür. ₺/sn tahmini ortalamadır; para teslimat bitince otomatik kasaya eklenir. Talep/kapasite gerçek darboğazdır. Kapalıyken aynı üretim en fazla4saat hesaplanır. Açılmış ilçe oyuncu seçimiyle etkinleşir; yedi ayrı piksel harita, İstanbul Albümü ve itibar korunur. K/M/B/T sadece gösterimdir; kayıt/ödemeler tam değerdir.

## Çalıştırma ve güncel doğrulama

Godot ile scenes/Main.tscn açılır. Windows'ta mevcut konsol D:/Tools/Godot/4.6.3/Godot_v4.6.3-stable_win64_console.exe.

```powershell
powershell -ExecutionPolicy Bypass -File tools/test_company.ps1
powershell -ExecutionPolicy Bypass -File tools/build_android.ps1
```

Testler geçici APPDATA ile gerçek kayıttan ayrılır. Güncel koşu şirket modeli/yerleşim, sayı biçimi, kayıt katmanı ve projeksiyonu kapsar. tests/README.md; eski kişisel kurye sözleşmelerini ayırır. Eski20 test sonucu yeni model için tam doğrulama sayılmaz.

Görüntüler tools/capture_company.gd ile geçici APPDATA kullanılarak üretilir. build/ui-check/company-*.png kuruluş, ana harita ve dört alt bölümün örnekleridir.

## Android

Güncel debug APK build/istanbul-kurye-a9-test.apk, 0.23.0-r6/code23, com.erditaskinn.istanbulkurye.a9test. Aynı debug imzasıyla İstanbul Kurye Test üzerine güncellenebilir. Eski asıl uygulama farklı pakettir. D: .tools altında Java17 ve Android debug şablonu, mevcut kullanıcı Android/Sdk altında SDK vardır. Araç ve özel debug anahtarı .gitignore/.gdignore ile dışarıda tutulur; dev/eski teslimat klasörleri APK'ya alınmaz.

Önceki0.12 sürüm SamsungA50 Android11 üzerinde test edilmişti (docs/a9-uygulama-raporu.md). 0.18 piksel HUD sürümü telefona yüklendi ve sürümü doğrulandı; uzun oynanış/performance testi sayılmaz. Yeni0.23 R6 sürümü bu tur telefona yüklenmedi. Şema8/ekonomi7 eski ayrılığı kendi modeliyle kapatıp kişisel kuryeyi filo slotuna taşır; kasa/ciro/işler korunur. Araçsız kurulum yerine ad/logo bir kez seçilir.

## Kontrol noktası

R1–R5 uygulamaları ve R6 kontrollü kod temizliği tamamlandı; docs/r1-olcum-raporu.md ve docs/r2-optimizasyon-raporu.md sonuçları açıklar. R2 rutin kaydı30sn aralığına toplar, kritik geçişleri kaydeder ve rota mesafesini önbelleğe alır. Aynı kazanç/sipariş/RNG durumu doğrulandı. Kullanıcı kontrolü bekleniyor. Yeni ekonomi katsayıları ilk hipotezdir, A8'in eski model süreleri bu modele uygulanmaz. R3 kartları mevcut→sonraki etki, yaklaşık gelir/geri ödeme, sıfır katkı ve kuyruk gecikmesini açıklar; docs/r3-yatirim-kartlari.md. R4 motor/araba fiyatlarını, rol uzmanlıklarını ve aşamalı yükseltmeleri düzenler; yeni tur hedefi650K, mevcut eski tur hedefi220Kkorunur. docs/r4-ekonomi-raporu.md55tur ve donmuş eski kayıt geçişini açıklar. R5 tek kartta birleştirilmiş teslimat/alım/açılış bildirimi ve varsayılan kapalı ses/titreşim ayarları ekler; docs/r5-geri-bildirim.md. Fiziksel telefon ses/titreşim kontrolü bekliyor. R6 üstbar/sabit harita sunumunu modüllere ayırır;27eski çizim fonksiyonu ve39başlangıçdüğümü kaldırıldı,17tarihseltest arşivlendi.9güncelbetik,6kayıtprofili/4saateşliği ve10pikselçifti geçti; docs/r6-kod-temizligi.md. Sıradaki R7 itibar sonrası kalıcı hedef tasarımıdır; kullanıcı kontrolü beklenir. Mağaza yayını, bulut, reklam veya yeni sistem kendiliğinden başlamaz.

Önceki README açıklamaları docs/README-0.13-arsiv.md altında tarihsel olarak korunur.
