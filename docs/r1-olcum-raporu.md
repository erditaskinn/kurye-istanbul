# R1 — Şirket modeli gerçek simülasyon ölçümü

Durum: tamamlandı. Ekonomi6 / şema7 / oyun0.18.0. Tarih2026-10-29. Oyun katsayıları, runtime kodları, APK ve telefon kaydı bu aşamada değiştirilmedi.

## Yöntem ve sınırlar

Godot4.6.3 headless, Windows, Intel(R) Core(TM) i3-1005G1 CPU @ 1.20GHz. Gerçek main.gd/dispatch.gd üretim, satın alma, ilçe değiştirme ve prestige fonksiyonları kullanıldı. tools/r1_probe_game.gd yalnız oyuncu kayıt yüklemesini kapatır ve rutin kayıt isteklerini sayar; prestige gerçek commit yapar. Tüm yazılar tools/run_r1.ps1 ile geçici, izole APPDATA altında. Disk gecikmesi ayrı gerçek SaveStore yazmalarıyla ölçüldü.

Dört politika × iki tohum(42/4242) × beş tur =40tur; ek olarak10dakikada bir karar veren dengeli politika ile5tur: toplam45tur. Karar penceresinde en fazla3alım. Dengeli politika pozitif katkılılar arasında alınabilir en iyi geri ödemeyi seçer; verim politikası en iyi seçeneğe para biriktirir. Hizmet/prim ve filo/hız tercihleri ilgili skorları1,8 ağırlıklandırır. Bütün politikalar o an açılmış ilçelerden tahmini en yüksek gelirliyi seçer; prestige hazırken son ilçeye geçer. Bunlar oyuncu davranışı veya matematiksel optimum değildir. Erken sürelere karar aralığı kadar gözlem payı eklenir. Tohum sayısı2 olduğu için istatistiksel güven aralığı verilmez.

## İlerleme süreleri

| Politika | Karar aralığı | 1. tur | 3. tur | 5. tur |
|---|---:|---:|---:|---:|
| Dengeli/alınabilir |30sn| 93–98 dk | 64,5–65 dk | 48,5–50 dk |
| Verim için biriktir |30sn| 91,5–92 dk | 63 dk | 48,5 dk |
| Hizmet/prim tercihi |30sn| 91–93 dk | 63–63,5 dk | 48 dk |
| Filo/hız tercihi |30sn| 92 dk | 62,5–63 dk | 48,5 dk |
| Dengeli/seyrek karar |10dk| 140 dk | 120 dk | 110 dk |

İlk satın alma30sn politikalarında1,5–3,5dk; ilk10dk tur cirosu407–819₺. İlk Beykoz açılışı8,5–12dk aralığında gözlendi. Seyrek karar örneğinde ilk Beykoz20dk gözleminde açılmıştı. Bu son örnek sadece30sn yerine10dk karar aralığıdır;4saat ara veren bir oyuncu profili değildir.

**Dış raporla karşılaştırma:** İlk tur89dk tahminiyle aynı büyüklükte, fakat gerçek koşular91–98dk. Beşinci tur40dk tahmini bu politikalarla doğrulanmadı:48–50dk; seyrek karar koşusunda110dk. Bu sayılar tasarım hedefi olarak otomatik kabul edilmez.

## Yatırım çeşitliliği

45turda seçilen araba sayısı0. Buna karşılık konfor ve operasyon alındı; “hiç kullanılmıyor” iddiası bu örneklerde doğru değil. Ancak hizmet/filo ağırlıkları çoğunlukla aynı seviyelere ve filo bileşimine yakınsıyor. Dolayısıyla farklı menü başlıkları henüz güçlü strateji farkı yaratmıyor. Bu sonuç arabanın bütün oyuncular için gereksiz olduğunu kanıtlamaz; seçici politikaların bu fiyat/talep düzeninde onu tercih etmediğini gösterir.

Başlangıçta tüm alımların tahmini katkısı aynı kaynak durumunda karşılaştırıldı. Gerçek ek gelir, iki klon arasındaki toplam teslimat cirosu farkıdır; alış bedeli düşülmüş net kâr değildir. Klonlara yalnız alımı mümkün kılacak aynı test sermayesi verildi; bunlar doğal ilerleme süreleri değildir.

| Alım | Tahmini geri ödeme | 10dk gerçek ek ciro, boş kuyruk | 10dk gerçek ek ciro, dolu kuyruk |
|---|---:|---:|---:|
| Yaya | 7,5dk | 157₺ | 421₺ |
| Bisiklet | 15dk | 157₺ | 489₺ |
| Motor | 45dk | 174₺ | 798₺ |
| Araba | 120dk | 174₺ | 798₺ |
| Hizmet | 9,79dk | 99₺ | 0₺ |
| Prim | 60dk | 21₺ | 0₺ |
| Konfor | 83,33dk | 24₺ | 0₺ |
| Operasyon | 150dk | 24₺ | 0₺ |

Dolu kuyruk profili başlangıç şirketini1saat yatırım yapmadan çalıştırarak oluştu. Hizmet/prim/konfor/operasyonun ilk10dk katkısı0₺: kabul edilmiş30iş eski ücret ve hızlarını tutuyor. Bu alımlar sonsuza kadar etkisiz değil;60dk farkları sırasıyla461/90/39/85₺. Kuyruk boşken bile ilk60sn farkı küçük veya0olabilir. Buna karşılık çalışan eklemek bekleyen eski işleri de daha erken taşıyabilir.

Talep doygun(4yaya/Şile) profilde tüm yeni çalışanlar, konfor ve operasyon için tahmini gelir katkısı0;60dk gerçek ek ciro da0. Hizmette7.seviyeden sonraki baz +25puan, mevcut çarpana göre yaklaşık%9,09;20.seviyede yaklaşık%4,17artış. Sabit “+%25” etiketi mevcut gelire%25artış anlamına gelmez.

## Yedi ilçe ve prestige şartı

Verim politikası/tohum4242 için doğal olarak ulaşılan1./3./5.tur filoları yedi ilçede ayrı klonlarla sınandı. Eski işler ilçe değiştirirken korundu; ilk10dk ölçüldü,15dk daha yerleşme sonrası son10dk gelir ölçüldü. Rastgele sipariş mesafeleri yüzünden kısa örnekler tahmini ortalamayla birebir eşleşmez.

| İlçe | 1.tur sonu gerçek ₺/dk | 3.tur | 5.tur |
|---|---:|---:|---:|
| Şile | 455,4 | 744 | 927,2 |
| Beykoz | 1003,2 | 1386,4 | 2021,6 |
| Üsküdar | 1644,7 | 2232,7 | 3233,2 |
| Kadıköy | 2611,6 | 3982 | 5127,9 |
| Beşiktaş | 4274,3 | 6201,6 | 8609,7 |
| Şişli | 3816,3 | 6201,8 | 8488,5 |
| Beyoğlu | 3933 | 5996,4 | 8192,8 |

İlk tur örneğinde aynı filo için tahmini Beşiktaş geliri4242,67₺/dk, Beyoğlu4083,04₺/dk: yaklaşık%3,76düşüş. Gerçek10dk örneği de Beşiktaş lehine. Aktif son ilçe koşulu yüzünden hazır turu bitirmek için düşük getirili ilçeye geçmek gerekiyor. Bu aşamada şart değiştirilmedi; R4'te 'son ilçe açıldı + tur cirosu' alternatifi değerlendirilmelidir.

## Dört saat çevrim dışı işlem maliyeti

| Profil | 3tekrar batch süresi | Gerçek dönüş giriş fonksiyonu | Tamamlanan iş | Karşılanamayan talep |
|---|---:|---:|---:|---:|
| Yeni şirket/Şile | 77,86–84,28ms | 78,31ms | 481 | 209 |
| Beyoğlu/1yaya | 63,78–66,53ms | 64,05ms | 232 | 6458 |
| Beyoğlu/20çalışan | 1062,07–1207,95ms | 1052,37ms | 6707 | 0 |

Beyoğlu profilleri sentetik:1yaya veya[8yaya,6bisiklet,4motor,2araba]; gelişmiş profilde hizmet10,prim3,konfor5,operasyon5. Kazanç eşitliği üç tekrarda, tek4saat/30sn parçalı işlemede ve gerçek _apply_offline_income girişinde doğrulandı. Sıfır geçen süreli yeniden dönüş ek ödeme yapmadı. Uzun fonksiyon çağrısında gerçek dünya saati ilerleyebileceği için sıfır süre denetiminde zaman damgasına kısa gelecek sınırı verildi; yeni geçen1sn geliri çift ödeme diye sınıflanmadı.

**Bu bir Android sonucu değildir.** CPU süreleri masaüstünde headless ölçüldü; GPU/render/kullanıcı etkileşimi/AndroidPSS/pil/sıcaklık kapsam dışı. Bellek alanı JSON’da süreç statik tahsisi olarak vardır; telefon RAM/PSS ölçümü olarak yorumlanmaz. Düşük kapasiteli profil daha az işi kabul ettiğinden gelişmiş filodan daha ucuz hesaplanabilir.6458 karşılanamayan sipariş, kasadan kaybolan6458sipariş ücreti değildir.

## Kayıt sıklığı tabanı

| Profil | 5dk kayıt isteği | Tamamlanan iş | Sabit kayıt50yazma ortalaması | p95 |
|---|---:|---:|---:|---:|
| new_company | 23 | 13 | 4,98ms | 7,03ms |
| developed_fleet | 134 | 126 | 6,28ms | 8,9ms |

Normal30sn kayıt teorik olarak5dk’da yaklaşık10kezdir. Gerçek _process(1/30) çağrısı yeni şirkette23, gelişmiş filoda134istek üretti. Aynı karede biten işler birleştirilebildiği için teslimat sayısı ile ek kayıt isteği tam eşit olmak zorunda değildir.50 gerçek SaveStore yazması geçici profil diski üzerinde sabit son durumla ayrı ölçüldü; tüm karelerde disk gecikmesi uygulanmadı. Android flash gecikmesi veya kare takılması bu sayılardan doğrudan çıkarılamaz. En büyük gözlenen tek yazma 28,7ms.

## Sonuç ve sıradaki aşama

R1 bitti; R2 henüz başlamadı. Sonuçların önceliği:
1. Kayıt isteklerini birleştirmek ve rota çiftlerini önbelleğe almak; kritik kayıtları koruyarak önce/sonra kıyaslamak(R2).
2. Yatırım kartlarında gerçek marjinal katkı ve kuyruk gecikmesini görünür yapmak(R3).
3. Arabanın kullanım alanı, birbirine yakınsayan yükseltme yolları ve aktif Beyoğlu prestige şartını ölçümlü revize etmek(R4).
4. Hedef ilk tur süresini kullanıcı tercihiyle belirlemek;91–98dk mevcut davranıştır, doğrulanmış ideal tasarım değildir.

Sabit harita kararı korundu; görsel, ses, ekonomi, kayıt sözleşmesi veya APK değişikliği yapılmadı. Telefon kurulumu/testi yapılmadı. Kullanıcı kontrolü için DUR.

## Tekrar üretme

tools/run_r1.ps1: izole APPDATA ve çıktı/log hata denetimi. tools/measure_r1.gd:45tur, marjinal alımlar ve7ilçe. tools/measure_r1_io.gd: kayıt istekleri ve gerçek disk yazması. tools/r1_probe_game.gd: yalnız ölçüm izolasyonu. tools/summarize_r1.py: bu rapor ve CSV.

Ham sonuçlar: build/balance/r1-company-v6.json, r1-io-baseline.json. Politikalar ve marjinal örnekler CSV olarak aynı klasörde. Nihai koşu failures=[]; ilk geliştirme koşularındaki betik tür hataları ve sıfır-süre denetimi düzeltildikten sonra nihai koşu baştan tamamlandı. Oyun runtime dosyaları değiştirilmedi.
