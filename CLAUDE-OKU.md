# İstanbul Kurye — incelemeye buradan başla

Güncel kaynak: R7.2 (30 Ekim 2026). Godot 4.6.3, GDScript, Android portre, Compatibility renderer. APK sürümü kaynak durumunu göstermeyebilir: son üretilmiş APK R6'dır; R7.2 henüz APK olarak üretilmedi. Kaynakta ekonomi7 / kayıt şeması9 vardır.

## İnceleme isteği

Bu projeyi profesyonel bir mobil idle oyun olarak incele. Önce bu dosyayı, docs/sirket-modeli-v3.md, docs/r7-ileri-oyun-tasarimi.md ve docs/r7-2-uygulama.md dosyalarını oku; ardından scripts/main.gd, company_ui.gd, economy.gd, specialization.gd, save_store.gd ve teslimat motorunu incele. Bulguları önem sırasıyla, dosya/satır ve somut oyuncu etkisiyle raporla. Doğrulanmış hata, denge hipotezi ve tasarım önerisini ayır. Test edemediğin davranışı doğrulanmış sayma. Önce inceleme raporu ver, kodu değiştirme.

## Korunacak kararlar

- Oyun idle: şirket kurulur, isim ve dokuz logodan biri seçilir; yaya/bisiklet/motor/araba filoları otomatik teslimat yapar.
- İstanbul haritası kullanıcı kararıyla sabittir. Hareketli kuryeleri geri getirmeyi gereksinim sayma.
- Dört alt sekme, mevcut piksel sanat dili, Türkçe ve ₺ desteği korunur.
- Kabul edilmiş işlerin ücret/hız profilleri sonradan değişmez. Çevrim dışı ilerleme olay motoruyla, dört saat tavanla çalışır.
- Yeni tur hedefi650K; eski mevcut tur220K korunabilir. Her itibar +25 yüzde puan ücret bonusudur.
- R7.2 uzmanlık modelleri uygulanmıştır; katsayıları adaydır. R7.3 çoklu tur denge, özel ikonlar ve fiziksel cihaz doğrulaması henüz tamamlanmadı.
- Yeni para birimi, klan, gacha, reklam ve mağaza yayını mevcut kapsam değildir.

## Çalıştırma ve sınırlar

project.godot dosyasını Godot4.6.3 ile aç. Oyun sanatı assets/ içinde dahildir; önceki hafif Claude ZIP'inin eksik sanat sorunu bu depoda geçerli değildir. PowerShell'de tools/test_company.ps1 -GodotPath <Godot konsol yolu> güncel10 kabul betiğini izole APPDATA ile çalıştırır. Yerel Android SDK/JDK ve imza anahtarı depoya dahil değildir; Android dışa aktarımı makine kurulumu gerektirir.

build/ ölçüm çıktıları, donmuş eski kaynak karşılaştırma fixture'ları ve ekran yakalamaları dahil değildir. tools/run_r2.ps1, run_r4.ps1, run_r6.ps1 gibi tarihsel karşılaştırmalar bunlar olmadan çalışmaz; güncel10 betiklik kabul paketinden ayrıdır. tests/archive/ tarihsel kuralları temsil eder, güncel kabul kapısı değildir. docs/gelistirme-plani.md kronolojiktir: en üstteki güncel kontrol noktasını esas al.

Gerçek telefon FPS/RAM, fiziksel ses/titreşim ve insan oyuncu dengesi tamamlanmış gibi değerlendirilmemelidir. Otomatik test başarısı retention veya eğlence kanıtı değildir.
