# A8 — Bütünleşik ekonomi ölçümü ve ilk denge ayarı
28 Ekim 2026. Teknik çalışma tamamlandı; küçük oyuncu denemesi ve kullanıcı kontrolü bekleniyor. Android kontrolü A9'dur.

## Sonuç ve yapılan ayar
İlk ilçe eşiği 500 → 550 ₺ tur cirosuna alındı. Diğer ilçe eşikleri, fiyat eğrileri, rol hızları, +25 yüzde puan itibar ve 220.000 ₺ yeni tur eşiği korundu. Eski kazanılmış ilçe erişimi geri alınmadı. Görseller/tema değişmedi.

550 ₺ ile 15 kontrollü erken oyunda Beykoz 491,5–569,5 sn, yani 8,2–9,5 dk'da açıldı. Önceki 500 ₺ denemesi 458–546 sn, yani 7,6–9,1 dk idi. Böylece ölçülen erken örneklerin hepsi 8–15 dk hedef bandına girdi. Bu sınırlı örnek tüm oyuncular için garanti değildir. İlk araç/hizmet/çalışan fiyatları değişmedi; A3'ün üç başlangıç yolunun ilk 10 dakika gelirleri aynı kaldı.

## Uzun oyun deneyinin yöntemi
`tools/measure_a8.gd` doğrudan gerçek Main/Dispatch ekonomisini kullanır. Üç tercih denenir: geri ödeme odaklı dengeli, hizmete öncelik veren, kapasiteye öncelik veren. Pozitif katkılı araç/hizmet/dört çalışan rolü karşılaştırılır. Tercih edilen yatırım pahalıysa para biriktirilir; her ucuz alım yapılmaz. İlçe kararı mevcut filoyla daha yüksek tahmini sürekli gelir veren açık ilçeyi seçer. Yeni tur koşuluna gelince Beyoğlu etkinleştirilir. Bu, yeni tur düğmesini kendi başına kullanan gerçek oyuna eklenen otomasyon değildir; yalnızca test politikasıdır.

Üç dönüş düzeni:
- Sürekli açık: 30 sn'de bir karar, en fazla bir alım.
- 4 saatte bir dönüş: ayrılık başına 4 saat üretim, dönüşte en fazla üç alım.
- 8 saatte bir dönüş: ayrılık başına yine 4 saat üretim, dönüşte en fazla üç alım.

İki tohum (42, 4242) × üç tercih × üç düzen = ayardan önce 18, ayardan sonra 18 uzun koşu. Her koşu en fazla 96 saat duvar süresi içinde ilk ve ikinci itibar kapısını arar. İlk iki grupta oyuncu başlangıçtan hemen ayrılır; ilk yatırım ilk karar penceresinde yapılabilir. Testteki karar pencereleri gerçek oyuncu oturum sayısı değildir.

Ek olarak 4242 tohumu × üç tercih × iki seyrek dönüş = altı koşuda ilk 10 dakika 30 sn karar aralığıyla oynanıp sonra ayrılma denendi. Bu ek koşul yalnızca ilk turun ilk 10 dakikasına uygulanır; bu dosyadaki ikinci tur sayılarını bonusun adil karşılaştırması diye kullanmıyoruz. Aynı koşullu ilk/ikinci 10 dakika karşılaştırması A7 raporundadır.

Toplam 42 uzun koşu ve ayrı 15 erken oyun koşusu arşivlendi. Her iki dört/sekiz saat düzeni motorun çevrim dışı 4 saat tavanını uygular. Bu ölçüm, işletim sisteminin gerçek arka plan davranışı testi değildir; o A9'dadır. Açık/kapalı gerçek entegrasyon, mevcut offline_summary/simulation_clock testlerinde ayrıca doğrulanır.

## Ölçülen uzun oyun
Ayarlı ekonomide hemen ayrılma koşulu:

| Karar düzeni | İlk itibar: duvar süresi | Kredilendirilen üretim | İkinci turun süresi |
|---|---|---|---|
| 30 sn karar / sürekli açık | 2,00–2,03 sa | 2,00–2,03 sa | 1,61–1,62 sa |
| 4 saatte bir, en fazla 3 alım | 16 sa | 16 sa | 16 sa |
| 8 saatte bir, en fazla 3 alım | 32 sa | 16 sa | 32 sa |

İlk 10 dakika oynayıp ayrılma koşulu:

| Dönüş aralığı | İlk itibar: duvar süresi | Kredilendirilen üretim |
|---|---|---|
| 4 saat | 12 sa 10 dk | 12 sa 10 dk |
| 8 saat | 24 sa 10 dk | 12 sa 10 dk |

Bunlar yalnızca tanımlanan politikaların gözlediği ilk uygun dönüşlerdir. Özellikle 4/8 saat satırlarında eşit saatler kaba karar aralığının sonucudur; kesin ara saniyeyi veya bütün stratejilerin eşitliğini kanıtlamaz. +1 itibarın daha yüksek geliri her dönüş düzeninde gözlenen tur süresini bir tam ziyaret kısaltmak zorunda değildir.

Önce/sonra uzun oyun aralıkları aynı kaldı; küçük ilk ilçe ayarı bütün ekonomiyi bozmadı. Bazı uzun yollar küçük saniye farkları taşıyor. Tercihler sonlarda benzer filolara yaklaşıyor; derin ve birbirinden tamamen farklı son oyun yapıları kanıtlanmış değildir. Başlangıçtaki iki pozitif yatırım, sıfır katkıda kapasiteye para harcamama ve ilçeye göre karar değişimi korunur.

## Tasarım yorumu ve kalan denge riskleri
12–24 saat kredilendirilen üretim / birkaç kısa dönüşle yaklaşık 1–3 gün hedefi idle dönüş düzenleri için değerlendirilir. Sık yatırım yapan aktif oyuncuyu yapay süre kapısıyla en az 12 saat bekletmek için eşiği büyütmedik. Aktif politika yaklaşık 2 saatte bitirebilir; bu bilinçli başlangıç kararıdır ve kullanıcı denemesinde değerlendirilmelidir. İlk 10 dakika + 8 saatlik dönüş politikası yaklaşık bir günde ilk itibara gelir; hiç başlangıç yatırımı yapmadan ayrılan karşılığı yaklaşık 32 saattir.

220.000 ₺ eşiği bu sınırlı idle örneklerde kullanılabilir olduğu için korundu. Bu sonuç son denge onayı, gerçek oyuncu ortalaması, en iyi strateji ispatı veya D1/D7/D30 geri dönüş oranı değildir. Daha çok/alım yapmayan, ilçede kalmayı seçen veya günde yalnızca bir kez dönen oyuncuların süreleri farklı olabilir. Denge kör biçimde tek aktif politika çevresine kurulmadı.

Seyrek dönüşte kuyruk dolabilir ve yeni talep kabul edilmeyebilir; bu kasadaki kazanılmış parayı eksiltmez. Talep/taşıma darboğazının gerçek sonucudur. Etkinlik, reklam, günlük görev veya giriş baskısı eklenmedi. 4 saat tavanının nihai seçimi gerçek kullanıcı denemesi sonrasında hâlâ değerlendirilebilir.

## Yerel olay ölçümü
`scripts/local_metrics.gd` yalnızca cihazdaki mevcut oyun kaydına küçük bir günlük ekler. Ağ bağlantısı, harici servis, hesap, cihaz kimliği veya kişisel oyuncu bilgisi yoktur. Oyun bunları ödül/ücret hesabında kullanmaz.

İzlenenler: ziyaret, otomasyon başlangıcı, başarılı yatırımın tür/bedel/durum özeti, ekip açılışı, ilk çalışan, ilçe açılışı/seçimi, gerçek çevrim dışı dönüş ve itibar. Son 128 olay tutulur; dokuz izinli tür için toplam sayaçlar ve ilk gözlemler ayrıca saklanır. Her turun bir defalık olayları ayrı sınırlanır. Başarısız satın alma, önizleme veya tekrarlanan itibar onayı başarı olayı oluşturmaz. Anlamlı karar analizi başarılı yatırımlar ve ilçe seçimleri üzerinden yapılabilir; gerçek oturum gözlemiyle birlikte yorumlanmalıdır.

Olay zamanı Dispatch'in gerçek adım sınırından gelir; örneğin 4 saatlik tek hesaplamada ilk ekip açılışı 4. saat diye kaydedilmez. Simülasyon süresi yalnızca hesaplanan üretimi, Unix zamanı gerçek kayıt anını ifade eder. Eski kayıtlarda coverage=since_upgrade kullanılır: bilinmeyen geçmiş öğretici/teslimat olayı uydurulmaz. Güncellemede hesaplanan ayrılık olayları bu gözlemlere dahil olabilir. D1/D7/D30, reklam sonrası bırakma veya kullanıcı kohortu bu tek cihaz günlüğünden ölçülmüş sayılmaz.

Günlük kayıt/yeniden başlatmada korunur; normal yeni turda toplamlar kalır, tur bayrakları/süresi sıfırlanır. Tam oyun sıfırlaması günlüğü de temizler. İtibar olayı yeni tur adayına eklenip oyunla birlikte tek yazmada kaydedilir; başarısız yazmada sahte itibar olayı da oluşmaz.

## Göç ve doğrulama
Kayıt şeması 6, ekonomi sürümü 5. A7 ve daha eski kayıtların ayrılığı önce kendi eşik/bonus kurallarıyla kapatılır. A6/A7'nin 500 ₺ ile kazanılmış ilçe hakkı yeni 550 ₺ eşiğiyle geri alınmaz. Kasa, ciro, seçili ilçe, albüm, itibar ve kabul edilmiş işler korunur. Yeni 60 ₺ sermaye veya şirket iadesi tekrar verilmez. Değişiklik ve cihaz içi ölçüm tek seferlik açıklanır.

17 farklı test betiği geçti: balance_metrics, prestige, district_choice, district_progression, simulation_clock, strategic_economy, return_choices, onboarding, offline_summary, delivery_status, delivery_flow, staff_progression, map_camera, menu_reset, save_store, isometric_projection, progression_ui. SCRIPT ERROR/ERROR çıktıları hata sayıldı. Testler ayrı geçici APPDATA ile yapıldı; gerçek oyuncu kaydı kullanılmadı.

Yeni kontroller: 128 olay sınırı, izinli türler, ilk/toplam sayaçlar, JSON yeniden yükleme, tam olay saatiyle büyük/küçük adım eşliği, ölçümün paraya etki etmemesi, başarısız alımın sayılmaması, gerçek 4 saat kazancının olayla eşleşmesi, tekrar dönüş/önizleme/onayın sahte ödül üretmemesi, günlükte itibarın tek yazmayla taşınması, tam sıfırlama ve önceki 500 ₺ ilçe hakkının korunması.

Ham çıktılar: `build/balance/a8-baseline.json`, `a8-tuned.json`, `a8-warm-start.json`, `a8-early.txt`. Kaynak: `tools/measure_a8.gd`, `tools/measure_a4.gd`. Baseline etiketi A7 ekonomi profili 4'ü, diğerleri güncel profili kullanır. `tools/capture_a8.gd` kısa/uzun ekran örnekleri oluşturur; a8-choice ve a8-tall görselleri gözle kontrol edildi. 550 ₺ hedefi ve mevcut arayüz sığıyor. Yeni görsel varlık üretimi gerekmedi.

## Kullanıcının küçük denemesi ve devam
Otomatik testler bir insanın oyunu eğlenceli/anlaşılır bulduğunu kanıtlamaz. Kullanıcı kontrolünde şu küçük deneme bekleniyor:
1. Rehbere bakarak araç/hizmet arasından kendi kararını ver; bir sonraki hedefi açıklayabiliyor ol.
2. İlk çalışanı aldıktan sonra talep sınırlıyken ek kapasitenin neden sıfır katkı gösterdiğini kontrol et.
3. En az bir dakika ara ver; dönüş dökümü ve yatırım seçeneklerinin anlaşılır olup olmadığına bak.
4. İlçe karşılaştırmasını ve itibar önizlemesini incele; istemeden satın alma veya reset olmamalı.

A8'in teknik bölümü sonunda DUR. Kullanıcı devam derse A9: Android araçlarını kontrol et, debug APK ve gerçek cihazda dokunma/kaydırma, okunabilirlik, arka plan/kilit/yeniden açma ve düşük donanım performansı. A4/A8 küçük kullanıcı denemesinin henüz raporlanmadığını koru; D1/D7/D30 değeri uydurma. Eklenti/MCP kurulmadı.
