# Görsel iyileştirme V1 — Sayılar, piksel arayüz ve harita simgeleri
Kullanıcının A9 sonrası değerlendirmesi üzerine uygulandı. Yeni test sürümü 0.13.0-visual / code13. Bu ilk görsel revizyondur; kullanıcının estetik değerlendirmesi bekleniyor.

## Tespitler
Tam uzunluklu kasa/ciro ve maliyetler, özellikle verilen 1 trilyon test parasıyla alanları aşıyordu. Yuvarlak StyleBoxFlat butonlar haritanın piksel görünümünden ayrışıyordu. Haritadaki ince çizgili dükkân/ev SVG'leri az ayrıntılı ve birbirine çok benzer görünüyordu. Tema ve kod içinde ayrı üretilen stiller birlikte ele alınmalıydı; yalnızca bir düğmenin köşesini değiştirmek yeterli değildi.

## Uygulama
- `scripts/number_format.gd`: K=bin, M=milyon, B=milyar, T=trilyon; uç değerler için Qa/Qi. Örnekler 1.250→1,25K, 1.000.000→1M, 1.000.000.000.000→1T. Büyük gösterimler en çok iki ondalık kullanır; birim eşiğine yuvarlanınca üst birime geçer. Türkçe ondalık virgül korunur.
- Kasa, ciro, teslimat sayısı, yükseltme/işe alım fiyatı, kazanç hızı, teslimat ücreti, eksik tutar, dönüş dökümü, bölge hedefi ve itibar önizlemesindeki finansal değerler ortak gösterime bağlandı. Seviye ve küçük sayaçlar gereksiz kısaltılmaz.
- Finansal hesap ve kayıttaki tam sayılar değiştirilmedi. Kasa/ciro/teslimat bilgi balonlarında gruplanmış tam sayı, yatırım bilgi balonunda tam bedel bulunur. Alım yeterliliği kısaltılmış metinden hesaplanmaz. Ayarlara K/M/B/T açıklaması eklendi.
- `scripts/pixel_style.gd`: basamaklı köşe, koyu alt gölge, üst/yan piksel ışığı ve kabartmalı yüzey. Ortak Theme, ana HUD, harita rozetleri, paneller, butonlar ve onay pencereleri aynı stili kullanır. Normal/üzerine gelme/basılı/pasif durumları ayrıdır. İlerleme çubuklarının yuvarlak köşeleri kaldırıldı. Metin fontu okunabilirlik için korundu; düşük çözünürlüklü yeni bir yazı tipi zorlanmadı.
- `assets/ui/pixel/`: 8 dükkân ve 8 apartman varyantı; renkli tente, vitrin, kapı/pencere, çatı ve küçük ürün işaretleri. HUD için piksel para, ciro grafiği, paket ve ayar simgeleri de eklendi. Eski SVG'ler silinmedi.
- Harita rozetleri 36×36, dokunma alanları 44×44 olarak korundu; yeni simge 32×32 şeffaf alan içinde çizilir. Mevcut hedef vurgusu ve bilgi kartı işlevi korunur. Yedi büyük ilçe haritası değiştirilmedi.

Varlıklar mevcut SVG/kod sisteminde düzenlenebilir yerel piksel çizimleri olarak üretildi; yapay zekâ raster üretimi veya yeni eklenti kullanılmadı. TextureFilterNearest ve tam sayı grid çizimi korunur. Ekonomi sürümü5 / kayıt şeması6 değişmedi.

## Doğrulama
20 farklı test geçti: önceki18 betik ile number_format ve visual_polish. Yeni testler birim sınırları, üst birime yuvarlama, negatif/büyük tutar, tam değer bilgi balonu, 1T kasanın HUD'a sığması, yüksek hizmet fiyatı, gerçek satın alma matematiği ve kaydın tam değerini doğrular. Map_camera yedi ilçe ve iki ekran boyutunda dokunma alanlarını ve panel engellemeyi kontrol etti. Diğer testler ortak saat, çevrim dışı hesap, kayıt göçleri ve Android geri/arka plan akışını korudu. APPDATA testler için geçici dizinlere yönlendirildi; gerçek kayıt değiştirilmedi.

`tools/capture_polish.gd`, 480×800 ve 480×1040 ekranları 1T kasa, 45,68B ciro, 1,23M teslimat ve yüksek maliyetlerle oluşturur. `build/ui-check/polish-map.png`, polish-return.png ve polish-tall.png gözle incelendi. Ekip görünümü polish-crew.png altında. Önizleme değerleri sadece geçici test kaydındadır; kullanıcıya otomatik para/ciro eklenmedi.

## APK / devir
`build/istanbul-kurye-a9-test.apk`, aynı test paket kimliği ve aynı debug imzasıyla yeniden üretildi. Versiyon0.13.0-visual / code13; 59.759.474 bayt. SHA-256: 7f56fa1a1efbb81419edd65b44995bc2077859c0d06cf19612f37828ab9d671f. İmza ve hizalama kontrolleri geçti. Kaynak dışı geliştirme klasörleri paket dışında kalır.

Bu turda ADB'de bağlı telefon görünmediği için yeni APK telefona kurulmadı. APK, mevcut İstanbul Kurye Test uygulamasının üzerine aynı paket/imza ile güncellenebilir. Asıl İstanbul Kurye uygulaması farklı paket olarak kalır. Telefonda yeni görünümün parmakla kullanımını ve yeni piksel simgelerin okunurluğunu ayrıca kontrol etmek gerekiyor; önceki0.12 cihaz testi bu görsel sürüm için tekrar yapılmış sayılmaz.

Kullanıcı kontrolü için DUR. Sonraki adım bu önizleme üzerine görsel geri bildirim ve yeni APK'nın telefonda denenmesi; yeni ekonomi/sistem değişikliği otomatik başlatılmayacak.
