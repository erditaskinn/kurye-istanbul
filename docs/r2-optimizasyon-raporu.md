# R2 — Kayıt ve rota hesabı optimizasyonu

Tamamlandı. Sürüm0.19.0-r2 / code19; ekonomi6 ve kayıt şeması7 korundu. Görseller ve denge katsayıları değişmedi.

## Değişiklikler

main.gd normal oyun akışında tamamlanan teslimat olan her karede kayıt yazmak yerine mevcut30sn kontrol noktasını kullanır. Satın alma, şirket kimliği, ilçe seçimi, prestige, ayarlar ve Android duraklatma/dönüş kayıtları korunur. Normal pencere kapatma bildirimi de kayıt alır.

Ek bulgu: _back_to_menu oyunu durduruyor fakat geçişte kayıt almıyordu. Bellekte ilerletilmiş süreyi eski last_saved_at üzerinden dönüşte tekrar sayma riski vardı. Menüye ilk geçişte anlık kayıt eklendi. Zaten menüdeyken tekrar çağrı, henüz hesaplanmamış yokluk süresinin üstüne kayıt yazmaz.

Rota mesafesi yönlü başlangıç/bitiş koordinatı anahtarıyla mevcut yol grafiğinde önbelleğe alınır. Grafik yeniden kurulunca önbellek temizlenir; böylece ilçe değişimi/eski kayıt yükleme/topoloji yeniden kuruluşu eski mesafeyi kullanmaz. Yalnız geometrik mesafe saklanır; hizmet, prim, hız profili ve itibar değiştikçe fiyat/süre yine güncel kurallarla hesaplanır. Aynı sipariş için _calculate_payout ve _order_quote tekrarı da bu önbellekten yararlanır. _market_profile içindeki ayrı ilçe ortalaması önbelleği korunur. Önbellek oyuncu kaydına yazılmaz.

## Önce/sonra ölçümü

Godot4.6.3, Windows/i3-1005G1, headless; aynı süreçte donmuş0.18 kaynakla güncel sürüm karşılaştırıldı. Her profil/tohum4242 için3dört-saat tekrarı; başlatma, grafik çizimi ve disk yazma süresi bu simülasyon zamanlarına dahil değil. Android performans sonucu değildir.

| Profil | Önce4saat hesabı | Sonra4saat hesabı | 5dk kayıt isteği önce→sonra |
|---|---:|---:|---:|
| Yeni şirket/Şile |75,0–75,8ms|22,0–25,1ms|23→10|
| Beyoğlu/1yaya |60,1–80,9ms|37,3–45,9ms|15→10|
| Beyoğlu/20çalışan |1048,6–1065,8ms|373,2–380,0ms|134→10|

Gelişmiş profilde medyan simülasyon süresi yaklaşık%64azaldı; rutin kayıt isteği yaklaşık%92,5azaldı. Bunlar tüm cihazlar için garanti değildir. Alım veya kritik geçiş yapılan5dk’da kayıt sayısı10’u aşabilir; bu tasarım gereğidir.30sn döngüsü kare zamanına bağlı olarak eşikte küçük sapma yapabilir.

## Doğrulama

-7ilçenin8×8alım/bırakma çiftinde448tam iş teklifi eski sürümle eşleşti.
-Her ilçede hizmet/konfor alımı sonrası önbellek fiyat veya hızı dondurmadı; grafik yeniden kurulduğunda mesafe önbelleği temizlendi.
-Üç profilde3’er4saat koşusunda kasa, toplam/tur cirosu, sipariş kuyruğu/aktif iş durumu ve RNG eski sürümle eşleşti.
-30FPS/5dk normal _process akışı da aynı kazanç/sipariş durumunu üretti; yalnız kayıt istekleri azaldı.
-Satın alma, ilçe, menüye dönüş, duraklatma ve kapatma bildirimi kayıt istiyor.
-Gerçek SaveStore kullanılarak satın alımdan hemen sonra yeniden açılışta kasa/filo/işler korundu; menü ve pause son iş durumunu diske yazdı; sıfır-süre resume çift ödeme yapmadı.
-Kontrol noktaları arasındaki15sn bellekte ilerleme kaydedilmeden nesne kapatılarak OS-kill benzetimi yapıldı. Eski disk kaydından yokluk süresi yeniden oynatıldığında referans kazanç/sipariş/RNG durumuyla eşleşti. Gerçek Android süreç öldürme/elektrik kesintisi deneyi değildir.
-Mevcut5kabul betiği geçti: company_model, company_layout, number_format, save_store, isometric_projection. SaveStore testi bozuk ana kayıttan yedek kurtarmayı, company_model eski ekonomi geçişi ve çevrim dışı/saat eşliğini kapsar. Dosya sistemi atomikliği yeniden yazılmadı.

Ani işletim sistemi kapatmasında normal pause bildirimi gelmeyebilir. Son başarılı kayıttan itibaren süre yeniden hesaplanır; saniye yuvarlama ve4saat tavanı hâlâ mevcut kurallardır. Her koşulda sıfır kayıp garantisi verilmez. Telefonun mevcut kaydı/test parası değiştirilmedi; bu aşamada telefon kurulumu veya gerçek cihaz performans testi yapılmadı.

## Kanıt ve tekrar üretme

tools/run_r2.ps1 izole APPDATA ve hata/log kontrolü kullanır. tools/measure_r2.gd karşılaştırma ve gerçek kayıt testlerini yürütür. tools/r2_baseline_probe.gd eski kaynak için yalnız test amaçlı kayıt izolasyonudur. build/r2/results.json ve verification.log nihai sonuçlardır, failures=[]olarak tamamlandı.

Donmuş eski kaynak build/r2/baseline-main-0.18.gd dosyasıdır; SHA256:915f0854398d54e981fc87e64cf4cbc141cc3d0ed5aeb731c492eb53cdc89b13. Runner bu hash'i doğrular. Bu kaynak çalışma zamanı veya APK'ya dahil edilmez; tekrar karşılaştırma için saklanır. Arşiv kaynak kayıpsa güncel main.gd ile üstüne sahte taban oluşturulmaz.

R2 tamamlandı; R3 başlamadı. Kullanıcı kontrolü için DUR. Sıradaki R3 tüm yatırım kartlarının gerçek katkı/geri ödeme ve kuyruk gecikmesi açıklamalarıdır. Yeni ekonomi katsayısı veya prestige koşulu değişikliği R4'e aittir.
