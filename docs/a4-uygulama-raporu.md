# A4 — İlk 10 dakika ve aşamalı rehber
28 Ekim 2026. Uygulama tamamlandı; oyuncunun yardım almadan anlayabilmesi için kullanıcı denemesi bekleniyor.

## Ekran akışı
Alt bölümdeki rehber düğmesi, mevcut yakın hedefi gösterir. İlk kullanımda “NASIL OYNANIR?” çağrısı bulunur. Dokununca mevcut lacivert/kehribar tema içinde tek kısa kart açılır. Kart kapanabilir ve yeniden açılabilir; üretim sürer. Zorunlu satın alma, bekleme sayacı veya öğretici ödülü yoktur.

Adımlar süreye göre değil gerçek ilerlemeye göre seçilir:
1. İlk teslimattan önce: otomatik teslimat, otomatik ödeme, bilgi amaçlı harita ve 4 saat çevrim dışı tavanı.
2. İlk yatırım öncesi: araç/hizmet farkı, başlangıç fiyatı ve tahmini katkı karşılaştırması.
3. İlk yatırım sonrası: yeni işe etkisi, aktif işin korunması ve ilk 5 teslimatta ekip açılışı.
4. Ekip açık fakat çalışan yok: ilk yaya 150 ₺, otomatik iş paylaşımı ve alternatif yatırımlar.
5. Çalışan alındığında: taşıma/talep darboğazı ve birikmiş kuyruğun erimesi.

Hizmet veya ekip önceliği de kabul edilir; oyuncu sırf öğretici için bisiklet almaya zorlanmaz. Kartta yakın adımla beraber sıradaki ilçenin gerçek tur cirosu eşiği bulunur. Araç alımı yeni işlerin hızlandığını, hizmet alımı yeni ücret çarpanını bildirir; yatırım kartlarının süre/ücret/katkı değerleri mevcut ekonomiyle güncellenir. Bildirimler kısa süreli rehber satırında gösterilir; aynı düğme rehberi açmaya devam eder.

## Kayıt ve etkileşim
`guide_seen` ek alanı rehberin açıldığını saklar. Adım, kayıttaki gerçek teslimat/araç/hizmet/ekip durumundan türetilir; ayrı ilerleme sayacı bozulması oluşturmaz. Eski kayıtta alan yoksa ilk kullanım çağrısı gösterilmez; oyuncu rehberi yine açabilir. Yeniden açılış kartı kendiliğinden açmaz. Onaylı tam sıfırlama rehberi de başlangıca döndürür. Prestige'de rehber okundu bilgisi korunur; adım yeni tur durumunu izler. Ekonomi veya kayıt şema sürümünün değişmesi gerekmedi; yeni alan geriye uyumlu ve isteğe bağlıdır.

Kart alanı harita dokunmalarını tüketir. Ekip, ilçe veya ayarlar açıldığında rehber kapanır; paneller üst üste kalmaz. Kısa/uzun ekranlarda mevcut harita ve alt yatırım bölümü korunur.

## İlk 10 dakika ölçümü
`tools/measure_a4.gd`: 7, 42, 99, 2026, 4242 tohumları × üç yatırım sırası = 15 kontrollü 600 sn koşu. Yarım saniyelik simülasyon; oyuncu hedef alımı karşılayınca hemen satın alır, yalnızca ilk üç yatırımı yapar. İlk kurucu işi başlangıçta aynı olduğundan ilk teslimatın 9,5 sn çıkması bağımsız 15 örnek kanıtı değildir. Sonraki siparişler tohuma göre değişir.

| Yol | İlk yatırım | Ekip yönetimi | İlk çalışan | 10 dk ciro |
|---|---|---|---|---|
| Araç → hizmet → yaya | 67,5–112,5 sn | 109–187 sn | 311,5–424 sn | 625–681 ₺ |
| Hizmet → yaya → araç | 67,5–112,5 sn | 113–200 sn | 232,5–326,5 sn | 683–723 ₺ |
| Yaya → hizmet → araç | 138–200 sn | 113–200 sn | 138–200 sn | 661–675 ₺ |

Bunlar okuma/karar verme gecikmesi içermeyen simülasyon aralıklarıdır; gerçek oyuncu süreleri veya tutunma metrikleri değildir. A3 ekonomi katsayıları değiştirilmedi. İlk otomasyon baştan vardır; ekip otomasyonu yukarıdaki ilk çalışan anında eklenir. İlçe geçişi/prestige bu 10 dakika örneğiyle dengelenmiş sayılmaz.

## Kontroller
Altı ilgili test geçti: onboarding, map_camera, progression_ui, menu_reset, simulation_clock, strategic_economy. Konsoldaki SCRIPT ERROR/ERROR satırları başarısızlık sayıldı. Testler geçici APPDATA ile çalıştırıldı; gerçek oyuncu kaydına dokunulmadı.

Yeni onboarding testi: durum geçişleri, rehber açıkken üretim, hizmet öncelikli ilerleme, yakın/uzak gerçek hedef, panel içi dokunma engeli, yeniden açmanın ödül üretmemesi, panel çakışmasının önlenmesi, kayıt/yeniden başlama ve sıfırlama. Diğer testler mevcut ekonomi, göç, harita yerleşimi ve açık/kapalı ortak hesabı korudu.

`tools/capture_a4.gd` ile a4-start/intro/choice/bottleneck/tall önizlemeleri üretildi. Choice, bottleneck ve tall ekranları gözle incelendi; kısa ve uzun ekranda metinler ve düğmeler sığıyor. Gerçek Android cihaz ve yardım almadan oyuncu anlama testi henüz yapılmadı.

## Kullanıcı kontrolü ve sıradaki aşama
Oyunda alt rehber düğmesine dokun; araç ve hizmet farkının anlaşılmasını, rehber açıkken ilerlemeyi ve ilk çalışan sonrası darboğaz açıklamasını kontrol et. Anlatımın yeterliliği bu denemeden sonra değerlendirilecek. A4 sonunda dur. Kullanıcı devam derse A5: dönüş özetinde gerçek katkı, darboğaz ve 2–3 uygun yatırım. A6 ilçe/albüm, A7 prestige, A8 bütünleşik denge, A9 gerçek Android kontrolü henüz bekliyor.
