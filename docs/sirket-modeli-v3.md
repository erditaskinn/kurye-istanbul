# Şirket modeli V3 — ekonomi7 / 0.21.0-r4

Güncel mekanik sözleşmesi. V2'nin aşağıdaki sayısal/ilerleme maddelerini günceller; araştırmanın idle, çevrim dışı ve sabit harita ilkeleri korunur. İlk insan oynanış dengesi henüz onaylanmış değildir.

## Korunan döngü
Şirket adı2–24karakter ve9logo;60₺ ve1gerçek yaya ile ücretsiz otomasyon. Filo yaya/bisiklet/motor/araba; ayrı kişisel kurye yok. Para tamamlanan teslimatta eklenir. Tahmini gelir talep ve kapasitenin küçüğü×yuvarlanmış ortalama ücret; kabul edilmiş işlerin ücret/hız profili değişmez. Harita sabittir, konum kutuları ve7ilçe/albüm korunur. Çevrim dışı4saat tavanı,30sn rutin kayıt ve kritik işlem kayıtları sürer.

## Filo
| Rol | İlk alım | Temel etkin hız | Kullanım alanı |
|---|---:|---:|---|
| Yaya |150₺|10|Ucuz başlangıç; konfor ağırlıklı büyüme|
| Bisiklet |260₺|14|Yaya üstü hafif filo; konfordan güçlü yararlanır|
| Motor |500₺|23|Şile/Beykoz'da arabadan daha hızlı; operasyonla büyür|
| Araba |650₺|36×ilçe faktörü|Yoğun ilçelerde toplu dağıtım verimi; operasyon ağırlıklı|

Aynı rolde alım bedeli×1,6artmaya devam eder. Ücretsiz kuruluş çalışanı alım sayılmaz. Araba faktörleri Şile→Beyoğlu:[0,55;0,60;0,65;0,80;1;1,15;1,35]. Bunlar trafik simülasyonu veya gerçek km/saat değil, toplu dağıtım için normalize iş verimidir. Her çalışan motor içinde aynı anda bir işi taşır; ayrı çoklu paket/rota seçme mekaniği eklenmedi.

## Yükseltmeler
-Hizmet: eski100×1,55^seviye, ücret×(1+0,25L), en çok50; başlangıçtan açık.
-Prim: eski120×1,6^seviye, ayrı ücret×(1+0,05L), en çok20;3çalışanda açılır. Önceki kayıtta satın alınmışsa korunur.
-Konfor: eski100×1,65^seviye, en çok20; başlangıçtan açık. Seviye başına yaya/bisiklet/motor/araba hız çarpanı yüzde puanları:[6,5,2,1].
-Operasyon:180×1,6^seviye, en çok20; ilk motor veya araba ile açılır. Hız puanları:[1,2,5,6]. Önceki kayıtta satın alınmışsa korunur.

Yeni etkin hız=rol temeli×araba ilçe faktörü(varsa)×(1+konfor_rol_puanı×L)×(1+operasyon_rol_puanı×L). Konfor ve operasyon kendi içinde toplamsal seviye etkisi, birbirine çarpan olarak işler. Kartlar yaklaşık filo kapasitesi ve gerçek yuvarlama dağılımına dayalı gelir katkısını gösterir; her yatırımın sürekli gelir artırması garanti değildir. Kilitli kartta şart görünür, ödeme alınmaz. Rol/ilçe seçimi ve darboğaz sürer; karma ve motor ağırlıklı yollar ölçüldü, her yol eşit hızlı değildir.

## İlerleme ve itibar
İlçe açılış ciro eşikleri0/550/2K/6,5K/18K/50K/120K ve talep3/5/7/10/14/20/28dk aynı. İlçe açılınca oyuncu seçer; açılmış daha yüksek ilçe her filoda daha çok kazandırmak zorunda değildir.

Yeni şirket ve yeni turlarda itibar hedefi650Ktur cirosu. Son ilçe açılmış olmalı; orada çalışıyor olmak gerekmez. Her itibar kalıcı+25yüzde puan; bileşik bonus değil. Yeni tur adı/logo/albüm/itibarı korur;60₺,1yaya ve0tur içi yükseltmeyle başlar. Kullanıcı ilk itibarın1,5–2saat civarında kalmasını seçti.55tur örneğinde normal30sn karar politikaları ilk tur105–115dk;10dk karar170dk. Bu bir oturum zorunluluğu veya retention sonucu değildir.

## Eski kayıt geçişi
SaveStore şema8; ekonomi7. Önce kayıt sürümünün kendi katsayılarıyla eksik süre hesaplanır. Ekonomi6veöncesinin mevcut tur hedefi220Kkorunur; kayıtlı hedef varsa korunur. Satın alınmış eski hızlar dört rolde legacy_speed_floor olarak saklanır; mevcut turda yeni hesap bundan düşük olamaz. Seviyeler, kimlik, para, filo, RNG ve kilitli işler korunur. Hız alt sınırı yalnız mevcut tur içindir; yeni itibar turunda temizlenir, hedef650Kolur. Eski alım bedelleri iade edilmez; sayıların değişmesi yeni alımlara aittir. Mevcut kaydı korumak için downgrade önerilmez; eski sürüm yeni kayıt sürümünü yazmaya kapatır.

## Kontrol noktası
R4 ilk ölçümlü revizyon tamamlandı. R5 görsel/işitsel geri bildirim henüz başlamadı. Sadece yaya/bisiklet kısıtlı örnek269,5dkilk turla daha yavaş; otomatik skor politikaları hâlâ benzer son filolara yakınsar. Bu sınırlar insan oynanışıyla izlenecek; reklam, yeni para birimi, klan veya mağaza yayını eklenmedi.

## R5 arayüz/tercih eki —0.22
Ekonomi7/şema8 aynı; canlı teslimat/alım/açılışlar tek kısa kartla bildirilir. Ses ve titreşim varsayılan kapalıdır, Ayarlar'dan ayrı açılır; tercihler reset/prestige'de korunur. Offline/göç sırasında teslimat efektleri tekrar oynatılmaz. Ayrıntı docs/r5-geri-bildirim.md. Telefonun fiziksel ses/titreşim kontrolü bekliyor.

## R6 teknik eki —0.23
Sunum kodu hud_presenter.gd/static_map_view.gd modüllerine ayrıldı; kullanılmayan eski çizim ve gizli kişisel-kurye kontrolleri kaldırıldı. Ekonomi/kayıt sözleşmesi ve piksel görünüm değişmedi; docs/r6-kod-temizligi.md karşılaştırma kanıtını açıklar. R7 ileri oyun tasarımı henüz başlamadı.
