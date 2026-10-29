# A3 — Stratejik yatırımlar ve darboğaz
28 Ekim 2026. Çalışma klasörü: D:/ChatGPT/kurye-istanbul. A3 tamamlandı; kullanıcı kontrolü bekleniyor.

## Oynanabilir sonuç
Kurucu baştan otomatik çalışır. Araç yalnızca taşıma hızını, hizmet sipariş ücretini, ekip paralel kapasiteyi artırır. Oyuncu rota çizmez veya para toplamak için dokunmaz. Yedi mevcut piksel harita korunur.

Yeni oyunun kasası 60 ₺, cirosu sıfırdır. Araç bedelleri bisiklet 100, motor 800, hızlı motor 2.500 ₺. Hizmet bedeli ceil(100 × 1,55^seviye); ilk değerler 100, 155, 241 ₺. Hizmet ücret çarpanı 1 + 0,25 × seviye; üst sınır 50. Çalışan bedeli ceil(rol tabanı × 1,6^aynı roldeki sayı); tabanlar yaya 150, bisikletli 300, motorlu 900, araba 2.400 ₺. İlk yaya fiyatları 150, 240, 384 ₺.

Ekip yönetimi ilk 5 tamamlanan teslimatta ücretsiz açılır. Bu asgari önkoşul, üç yatırım yolunu denemek için A4'ten A3'e alındı. A4 öğretici ve ilk 10 dakika düzenlemesi henüz yapılmadı.

## Sipariş ve kapasite modeli
Her ilçedeki geçerli dükkân-ev çiftlerinin ortalama yol mesafesi hesaplanır. İş mesafesi gerçek oyun yolu / ilçe ortalaması × 300 olarak normalize edilir; görsel harita gerçek ölçekli navigasyon haritası değildir. Başlangıç rol hızları 10 / 12,5 / 20 / 25; ortalama başlangıç yaya işi 30 sn, bisiklet işi 24 sn. İlçe trafiği süreyi çarpar. Alım aşaması toplam sürenin %30'udur; eski 20 sn sabit bekleme yeni işlere uygulanmaz.

Temel ücret round(12 + 8 × yol / ortalama yol). Hizmet ve mevcut kalıcı/ilçe gelir çarpanları uygulanıp ücret sipariş kabulünde kilitlenir. Araç ücret bonusu vermez. İşe atanmış süre yükseltmeyle geriye dönük değişmez. Eski kabul edilmiş işler kendi fiyat/hız profillerini korur.

Dakikalık ilçe talebi 3 / 5 / 7 / 10 / 14 / 20 / 28. Kapasite, kurucu ve açık ekip slotlarının ortalama servis hızları toplamıdır. Yaklaşık sürekli gelir = min(talep, kapasite) × ortalama kilitlenecek ücret. Her yatırımın mevcut duruma göre farkı gösterilir. Başlangıçta kapasite 2 iş/dk, talep 3 iş/dk. Talep tamamen karşılandığında ek araç/çalışanın sürekli katkısı sıfırdır. Bekleyen kuyruk varsa ayrı “Kuyruk eriyor” durumu görünür; bu geçici kazanç sürekli gelir gibi sunulmaz.

Bunlar tasarım önerimiz ve ilk denge katsayılarıdır; araştırmadaki oyunların doğrulanmış formülleri değildir. Rastgele rota, kuyruk ve eski işlerin bitişleri nedeniyle anlık gelir tahminden sapar.

## Kontrollü 10 dakika karşılaştırması
Aynı 4242 tohumu, yarım saniyelik adımlar, yalnızca listedeki ilk üç alım. Gerçek oyuncu testi veya en iyi strateji kanıtı değildir.

| Yol | Alım anları (sn) | Ciro | Son kasa | Kurucu/ekip teslimatı |
|---|---|---|---|---|
| Araç → hizmet → yaya | 76,5 / 184,5 / 311,5 | 665 ₺ | 375 ₺ | 23 / 6 |
| Hizmet → yaya → araç | 76,5 / 232,5 / 286,0 | 692 ₺ | 402 ₺ | 20 / 9 |
| Yaya → hizmet → araç | 147,5 / 218,5 / 326,5 | 661 ₺ | 371 ₺ | 17 / 12 |

Üç yol da kendi ilk yatırımlarına ulaşır. Kasa, başlangıç 60 ₺ ve toplam 350 ₺ yatırım nedeniyle cirodan 290 ₺ düşüktür. Bu örnek sonraki ilçelerin/prestige temposunun dengelendiği anlamına gelmez.

## Kayıt geçişi
Kayıt şeması 3, ekonomi sürümü 2. Hizmet seviyesi ve okunmamış geçiş açıklaması saklanır. Eski kayıtların ayrılık süresi önce kendi eski talep/ücret/hız hesabıyla kapatılır. Ardından yeni ekonomi açılır. Eski kayıtta şirket açık ise kaldırılan şirket kapısı için 9.000 ₺ bir kere kasaya iade edilir; toplam veya tur cirosuna eklenmez. Mevcut kasa, araç, ekip ve kalıcı ilerleme korunur. Eski kayda yeni oyun başlangıç parası ayrıca verilmez. Yeni sürümle yeniden açılış tekrar iade üretmez. Gerçek oyuncu kaydıyla deney yapılmadı.

## Doğrulama
12 farklı test betiği geçti: strategic_economy, simulation_clock, delivery_status, map_camera, delivery_flow, staff_progression, progression_ui, offline_summary, district_progression, menu_reset, save_store, isometric_projection. Konsoldaki SCRIPT ERROR / ERROR çıktıları başarısızlık sayıldı. Test ve yakalamalarda APPDATA geçici dizine yönlendirildi.

Kontroller: fiyat eğrileri ve yuvarlama, hizmet kaydı, üç strateji, iki pozitif başlangıç yatırımı, talep doygunluğunda sıfır kapasite katkısı, kuyruk eritme ayrımı, aktif iş kilitleri, açık/kapalı hesap, eski süre ve tek iade, yedek kayıt, harita dokunma alanları. A2'nin 260/378 ₺ tarihsel karşılaştırması eski talep profiliyle testte tutulur; güncel A3 gelir ölçümü değildir.

`tools/capture_a3.gd` ile kısa ve uzun ekranlar üretildi. `build/ui-check/a3-choice.png`, `a3-team.png`, `a3-tall.png` gözle incelendi: iki yatırım kartı, marjinal katkı satırları, ekip paneli ve harita yerleşimi okunabilir. Gerçek Android cihazdaki performans/dokunma testi henüz yapılmadı.

## Sonraki kontrol noktası
A3 sonunda dur. Kullanıcı devam derse A4: ilk 10 dakika deneyimi, kısa aşamalı öğretici, yakın hedefler ve görünür yatırım geri bildirimi. A5 dönüş önerileri, A6 ilçe/album, A7 prestige ve A8 kapsamlı denge ayrı aşamalardır. Mevcut ilçe eşikleri ve tur başına %10 prestige bonusu bu aşamada korunur.
