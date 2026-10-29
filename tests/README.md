# Güncel kabul kapsamı — R6

Şirket modeli ekonomi7/şema8 için tek güncel koşu:

    powershell -ExecutionPolicy Bypass -File tools/test_company.ps1

Her betik ayrı geçici APPDATA kullanır; gerçek oyuncu kaydına yazılmaz. Çıkış kodu ve SCRIPT ERROR/ERROR çıktısı birlikte denetlenir.

| Betik | Davranış |
|---|---|
| company_model | Kuruluş,9logo, ücretsiz gerçek yaya,4rol, kilitli işler, kayıt,prestige,çevrimdışı ve eski geçiş |
| company_layout |7harita,44pxkonumlar, iki telefon oranı, altbar ve portre sınırları |
| investment_preview |7ilçede56gerçek alım, fiyat/kapasite/gelir eşliği, sıfırkatkı,kuyruk ve metin/kaydırma |
| economy_v7 | Prim/operasyon kilitleri, rol/ilçe uzmanlıkları, eski hız koruması ve prestige sınırı |
| game_feedback | Birleştirme, seslimit/mute/background/offline, ekonomi/RNG, tercihlerin kalıcılığı |
| transition_regressions | Geri tuşu ve modal sırası, canlı rehber,4saattavan, saatgeriyealış,pause/resume, başarısız/iptaledilmiş işlemler |
| number_format | K/M/B/T, eşikler, yuvarlama, tam değer |
| save_store | Atomik kayıt, eski kayıt ve bozuk ana dosyadan yedek kurtarma |
| isometric_projection | Kayıt/kamera uyumluluğu için kalan projeksiyon matematiği |

Toplam9betik; betik sayısı tekil assertion sayısı değildir. failing_save_store.gd SceneTree testi değil, başarısız prestige kaydı enjekte eden ortak yardımcıdır.

## Tarihsel testler

17önceki kişisel kurye/A1–A9betiği tests/archive içindedir. Eski araç/5teslimat kapısı/hareketli harita/arayüz varsayımları güncel sözleşme değildir; hepsinin yeni sürümde geçmesini beklemeyin. tools/test_delivery_flow.sh vb.eski wrapperlar arşiv yollarına işaret eder; güncel kapı yerine çalıştırılmaz. Eski tools/measure_a8.gd/capture_a*.gd araçları da tarihsel modele aittir.

## Donmuş kaynak karşılaştırmaları

tools/run_r6.ps1 altıprofili (yeni/gelişmiş/ekonomi0,2,5,6) donmuş0.22ile yükleme+4saat simülasyonda ve10pikselgörünüm çiftinde karşılaştırır. build/r6/baseline ve hash manifesti gerekir; eksikse yeni kaynakla eski taban üretilmez. ÖncekiR4donmuş0.20göç kanıtı ayrıca build/r4 ve tools/run_r4.ps1 içindedir.

Bu testler gerçek AndroidOS-kill/elektrik kesintisi, fiziksel titreşim, duyulan ses seviyesi veya telefonFPS/PSS sonucu değildir. Cihaz kontrolleri ayrıca yapılır.
