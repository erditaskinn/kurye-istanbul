# R4 — İlk ölçümlü ekonomi/ilerleme revizyonu

Tamamlandı:0.21.0-r4/code21; ekonomi7/şema8. Güncel sözleşme docs/sirket-modeli-v3.md. Görsel haritalar, idle otomasyon ve çevrim dışı4saat sınırı aynı.

## Neden bu değişiklikler?
R1'de45turun hiçbirinde araba alınmadı, aktif Beyoğlu prestige şartı örnek filoyu düşük gelire zorluyordu. Konfor/operasyon bütün rollere benzer hız çarpanı veriyordu. R4’te rol/ilçe uzmanlığı, daha erişilebilir motor/araba alımı, farklı ekipleri destekleyen hız yatırımları ve aşamalı açılış uygulandı. Hizmet/prim hâlâ ücret eksenindeki yatırımlardır; primin3çalışanda açılması bunları tümüyle farklı mekanik yapmaz.

İlk aday350Khedef ve1300₺araba ile yaklaşık120–124dkilk tur üretti, ama yine araba alınmadı; reddedildi(build/r4/candidate-a.json). İkinci aday650₺araba/500₺motor ve180₺operasyonla tüm rolleri kullandı,350Khedefte ilk tur81–90,5dkoldu(build/r4/candidate-b.json). 850Kara adayı2–3saat varsayımıyla120–130dküretti(build/r4/candidate-850k.json). Kullanıcı daha sonra ilk itibarın1,5–2saat civarında kalmasını seçti; nihai hedef650Kolarak yeniden ölçüldü. Normal politikalar105–115dküretti. Bu insan testi sonucu veya tek oturum zorunluluğu değildir. Mevcut eski tur hedefleri yükseltilmedi.

## Nihai ölçüm
tools/measure_r4.gd: öncekiR1ile aynı4puanlama politikası×2tohum×5tur=40tur, ek10dk-karar5tur ve yalnız hafif filo/motor filosu kısıtlı politikaları5’er tur: toplam55tur. Tohumlar42/4242; otomatik karar en çok3alım/pencere. Sıralama tahmini sabit gelir/verim kullanır, bütün gelir gerçek olay motorundan gelir. Normal politikalar en iyi tahmini gelirli açık ilçeyi seçer; prestige için son ilçeye zorla geçmez. Koşular ayrı APPDATA’da; rutin kayıt I/O ölçümde ayrıdır, gerçek prestige commit kullanılır.

| Yol | 1.tur | 3.tur | 5.tur | İlk tur sonu filo(yaya,bisiklet,motor,araba) |
|---|---:|---:|---:|---|
| Dengeli,2tohum | 108–115dk | 72,5–73,5dk | 55,5dk | [4,2,2,3] |
| Verim için biriktir | 105,5dk | 71,5–72dk | 54,5–55dk | [4,2,2,3] |
| Hizmet/prim ağırlığı | 105–105,5dk | 71,5–72dk | 54,5–55dk | [4,2,2,3] |
| Filo/hız ağırlığı | 105–105,5dk | 71,5–72dk | 55–55,5dk | [4,2,2,3] |
| Sadece yeni motor/araba alımı,1tohum | 107,5dk | 74,5dk | 56,5dk | [1,0,4,3] |
| Sadece yeni yaya/bisiklet alımı,1tohum | 269,5dk | 180,5dk | 137,5dk | [4,2,0,0] |
| Dengeli,10dk-karar | 170dk | 150dk | 130dk | [4,2,2,3] |

Normal8koşuda ilk10dkciro504–819₺, ilk alım1,5–3,5dk. İlk araba33,5–36dk, ilk operasyon aynı karar penceresinde alındı. Motor ağırlıklı kısıtlı örnekte ilk araba21dkveoperasyon27dk. Hepsi yapay politika örnekleridir; optimum veya gerçek oyuncu davranışı değildir.

Normal40turda120araba alındı; eskiR1'de0’dı. Konfor ve operasyon da kullanıldı. Karma ve motor ağırlıklı yol benzer sürelerde bitiyor; sadece hafif filoda kalma bilinçli kısıtı belirgin daha yavaş. Bu üçüncü yol için eşit güç/başarı iddiası yok. Otomatik puanlama politikalarının benzer son filoya yakınsaması sürüyor; stratejik çeşitlilik tamamen çözülmüş sayılmaz. Yeni uzmanlıkların faydası insan oturumlarıyla ayrıca doğrulanmalı.

3profil×3dört-saat deterministik tekrar,30sn parçalı olaylar ve gerçek offline giriş eşitliği geçti; sıfır süre dönüşünde çift ödeme yok. Masaüstü gelişmiş20çalışan profili yaklaşık0,35–0,39sn hesaplandı. Android performans sonucu değildir. Sentetik marjinal profiller ve7ilçe karşılaştırmaları JSON’dadır; doğal tur ölçümleriyle karıştırılmamalı.

## Kayıt/göç doğrulaması
build/r4/baseline içindeki donmuş0.20main/economy/dispatch/save_store dosyalarıyla gerçek eski kayıt oluşturuldu. Bağımlılıkları eski ekonomi/dispatch/store'a yönlendirilmiş isolated kopyalar yalnız ölçümdedir.10dkgerçek yokluk önce eski fonksiyonlarla hesaplandı; yeni oyunun sonucu eski runtime ile kasa/ciro/tur cirosu, kabul edilmiş işler ve RNG açısından eşleşti. Eski kimlik/filo ve220Ktur hedefi korundu. Eski hızlar[15,73;19,6625;31,46;39,325]alt sınırı olarak saklandı. Yeniden yükleme tekrar göç/ödeme yapmadı. Beşiktaş'tayken eski hedefi tamamlamış kayıt itibar kazanabildi; sonraki tur650Khedef,boşhızkoruması,1yaya ile başladı. Prestige'nin diskteki kaydı canlı başlangıç işleriyle eşleşti.

Bu, gerçek telefon kaydının değiştirilmesi değildir. Test parası ve telefon verisi kullanılmadı; cihaz kurulumu/performans testi yapılmadı. Tek başına eski kalıcı katsayıları korumak yeni alımların her durumda anlık ek gelir sağlayacağı anlamına gelmez; talep sınırı ve kilitli işler sürer.

## Kontroller ve kanıt
-Güncel7kabul betiği geçti: company_model, company_layout, investment_preview, economy_v7, number_format, save_store, isometric_projection.
-Yeni economy_v7: kilitliyken ödeme alınmaması, prim/operasyon açılması, kırsalda motor/yoğun ilçede araba karşılaştırması, dört role konfor/operasyon etkileri,7ilçede eski hız alt sınırı, prestige hedef ve son-ilçe-açılış sınırları.
-Önizleme testi56gerçek alımı yeni açılış koşullarına uygun kurulmuş filoyla karşılaştırır; eski işlerin koşulları değişmez. Eski kuralların testleri yeni sözleşmeye göre kurulur; kilitli alımın geçerliymiş gibi zorlanması yapılmaz.
-Gerçek Godot görselleri build/ui-check/r4-*.png ve güncel company-*.png; kilitli kart, uzmanlıklar, araba ve prestige ekranı incelendi. Kartta kilit şartı buton üstünde de gösterilir.
-tools/run_r4.ps1 izole profil/hata kontrolüyle ölçüm ve donmuş kaynak geçiş testini çalıştırır. Ham sonuç build/balance/r4-company-v7.json, build/r4/migration-results.json ve loglar. Nihai failures=[]; R1/R2ham dosyaları değiştirilmedi.

## Sonraki iş
Kullanıcı kontrolü için DUR. R5 başlamadı: sabit haritada ölçülü teslimat/satın alma geri bildirimi ve isteğe bağlı ses/titreşim tasarımı sırada. R4 halen ilk denge adayıdır; kullanıcı süre tercihi veya gerçek oynanış geri bildirimi gelirse güncellenecek. Mağaza yayını, reklam veya yeni para birimi eklenmedi.
