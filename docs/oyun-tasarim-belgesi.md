# İstanbul Kurye — Oyun Tasarım Belgesi v1 (tarihsel çekirdek)

> Güncel kullanıcı kararı: Şirket modeli V2 (docs/sirket-modeli-v2.md) uygulanmıştır. Ad/9logo ile doğrudan şirket,1ücretsiz yaya,4 filo türü ve Geliştir/Motivasyon/Şirket/Ayarlar alt çubuğu vardır. Aşağıdaki kişisel kurye/araç ve5 teslimatta ekip kapısı maddeleri tarihsel tasarımdır; yeni sözleşme yerine kullanmayın. EskiA8 denge sonuçları yeni modele doğrudan geçmez.

Tarih: 28 Ekim 2026  
Durum: A1–A9 teknik işleri uygulandı; A50 Android11 üzerinde ilk cihaz kontrolü yapıldı. A4/A8 küçük kullanıcı anlama/eğlence denemesi ve geniş cihaz/yayın kontrolleri bekleniyor. Sonraki bölümlerdeki hedefler tamamen uygulanmış değildir. Güncel ayrıntılar aşama raporları ve geliştirme planındadır. Her aşamadan sonra gösterim ve kullanıcı kontrolü gerekir.

Bu belge, kullanıcının docs/idle-arastirma-notlari.md dosyasına arşivlenen araştırmasını mevcut Godot projesine uyarlar. Uygulama sırası ve tamamlanma kaydı docs/gelistirme-plani.md içinde tutulur. Sayılar tasarım denemesi içindir; araştırılan oyunlardan alınmış kanıtlanmış denge katsayıları değildir.

## Dayanaklar: doğrulanan bilgi, mevcut durum ve öneri
- **Doğrulanan örnek oyun özelliği:** Birincil geliştirici/oyun kaynaklarında belirtilen özellik.
- **Mevcut uygulama:** Yerel kod incelemesiyle görülen davranış. Bu turda yeniden oynanış testi yapılmadı.
- **Öneri:** İstanbul Kurye için henüz uygulanmamış tasarım kararı.
- **Denge hipotezi:** Simülasyon ve oyuncu testiyle değişebilecek sayı, hedef süre veya beklenen davranış.

| Örnek | Resmî kaynakta doğrulanan özellik | Buraya aktarılacak öneri |
|---|---|---|
| Idle Miner Tycoon | Yöneticilerle otomasyon, oyuncu yokken kazanç, araştırma, koleksiyon ve etkinlikler | Otomatik işi yönetmek; elle toplama angaryası eklememek |
| Egg, Inc. | Nakliye araçları, araştırma, kaynak dengesi, prestige, Contracts ve artifacts | Talep/taşıma kapasitesi dengesi; farklı yatırım yolları |
| AdVenture Capitalist | Çalışanlar, yükseltmeler, kalıcı kazanç artıran Angel Investors; farklı etkinlik dengeleri | Sıfırlama ödülünü sayıyla göstermek; etkinlikte küçük bir oynanış farkı |
| Cell to Singularity | Keşif ağacı, yükseltmeler, yeniden başlama ile kalıcı hız/yeni içerik, yan simülasyonlar | İlçelerle keşif ve kalıcı ilerleme |

Kaynaklar:
- https://www.idleminertycoon.com/
- https://play.google.com/store/apps/details?id=com.auxbrain.egginc (geliştirici Auxbrain açıklaması)
- https://hyperhippo.com/games/adventure-capitalist/
- https://screenzilla.helpshift.com/hc/en/5-adventure-capitalist/section/22-gameplay-settings/
- https://celltosingularity.com/faq/

Bu kaynaklar özelliklerin varlığını destekler; tek başına geri dönüş/gelir başarısına neden olduklarını kanıtlamaz. Maden–asansör–depo için kesin formül, başka oyunların çevrim dışı katsayıları veya açılma süreleri doğrulanmış kabul edilmez. Tap Titans, AFK ve Legend of Mushroom araştırma arşivinde tutulur; savaş, ekipman çekilişi ve klan sistemleri bu oyunun ilk sürümüne taşınmaz.

### Mevcut prototipin somut envanteri
| Alan | Mevcut durum | Yeniden tasarım gerekçesi |
|---|---|---|
| Tema/görsel | Godot 4.6, Android portre, 7 ayrı sabit piksel harita, bilgi amaçlı simgeler | Korunur; kurye haritada hareket etmez |
| Kurucu kurye | Otomatik mesafe bazlı teslimat; hız 90/145/205/275 | Ekip ile ortak zaman/ölçek modeli gerekli |
| Araç | 300/1.300/4.000 ₺; ücret 30 + floor(mesafe/25) + araç_seviyesi×12 | Hız ve ücret etkileri bağımsız stratejik yatırımlara ayrılacak |
| Ekip | Şirket 9.000 ₺; roller 900/1.900/4.200/9.000 ₺; tekrarlı alım +%50 taban | Ekip kararına ulaşma gecikiyor; maliyet eğrisi yeniden kurulacak |
| Talep/kuyruk | Ekip için 1/2/3/5/7/9/12 sipariş/dk; 30 iş tamponu | Gerçek darboğaz var, fakat oyuncuya kapasite/getiri açıklanmıyor |
| Çevrim dışı | Kurucu sabit 5/7/9/11 ₺/dk; ekip 15 sn adımlı; üst sınır 4 saat | Açık ve kapalı oyun aynı ekonomiyi kullanmıyor |
| İlçeler | Ciro 0/2.500/8.000/22.000/50.000/90.000/140.000; otomatik geçiş | Açılma ve işletmeye geçme kararları ayrılacak |
| Prestige | Beyoğlu + 220.000 tur cirosu; her tur +10 yüzde puan | Kalıcı ödül, süre ve sıfırlama ekranı yeniden değerlendirilecek |
| Dönüş özeti | Süre, kurucu/ekip kazancı ve hedef mevcut; para zaten ekleniyor | 2–3 bağlamsal yatırım seçeneği ve darboğaz açıklaması eklenecek |
| Kayıt | Tek yerel JSON; cihaz saati; şema sürümü/atomik yedek yok | Köklü değişiklikten önce veri göçü ve zaman tutarlılığı gerekli |
| Ölçüm/bulut | Analitik, bulut kayıt, etkinlik, reklam, satın alma yok | Var kabul edilmeyecek; ilk sürüm kapsamı kontrollü tutulacak |

Kod dayanakları: scripts/main.gd içindeki _process, _calculate_payout, _income_multiplier, _apply_offline_income, _offline_income_for, _save_game, _rebirth; scripts/dispatch.gd içindeki advance, delivery_seconds, _assign. README'deki geçmiş yaklaşık 152 dakikalık tek denge koşusu yeni ekonomi için süre kanıtı değildir.

## 1. Oyunun temel fikri ve hedef oyuncusu
**Önerilen tanım:** İstanbul'un mahalle esnafını müşterilerine bağlayan küçük kurye işini, otomatik çalışan bir dağıtım şirketine büyüt.

Hedef: 2–5 dakikalık oturumlarla ilerlemek, İstanbul atmosferini keşfetmek ve birkaç net işletme kararı vermek isteyen mobil oyuncu. İlk hedef Android, tek oyunculu, internet olmadan çekirdek oynanış. Çok oyunculu altyapı ilk sürüm gereksinimi değildir.

Korunan kimlik:
- Şile → Beykoz → Üsküdar → Kadıköy → Beşiktaş → Şişli → Beyoğlu içerik sırası.
- Ayrıntılı sabit piksel haritalar, lacivert/kehribar/turkuaz arayüz.
- Harita atmosfer ve bilgi sunar; rota çizme, kurye sürme ve zorunlu tıklama yok.
- Para teslimat tamamlanınca otomatik kasaya girer. Araştırmadaki “toplama” bu oyunda muhasebeleşmedir; ayrıca basılması gereken bir tahsilat düğmesi değildir.

Oyuncunun sorusu: “Daha hızlı mı taşıyayım, aynı teslimattan daha iyi ücret mi alayım, ekibi mi büyüteyim, yoksa yeni ilçenin talebine mi geçeyim?”

## 2. İlk 10 dakikalık oyuncu deneyimi
Aşağıdaki değerler **başlangıç denge hipotezidir**:
- İlk kuruluştaki kasa: 60 ₺ başlangıç sermayesi; tur/toplam cirosuna yazılmaz.
- Şile talebi: 3 sipariş/dk.
- Örnek mesafede kurucu hizmet süresi: 30 sn; kapasite 2 sipariş/dk.
- Ortalama taban ödeme: 20 ₺; başlangıçta yaklaşık 40 ₺/dk.
- İlk bisiklet 100 ₺: aynı iş 30 → 24 sn; kapasite 2 → 2,5/dk.
- Hizmet seviyesi 1: 100 ₺; aynı iş ücreti 20 → 25 ₺.
- İlk çalışan 150 ₺: aynı mesafede ilave 2 sipariş/dk kapasite.

| Aralık | Oyuncunun gördüğü | Anlamlı karar / açılım |
|---|---|---|
| 0:00–0:30 | Şile haritası, ilk otomatik sipariş, ilerleyen süre, ilk ödeme | Tek kısa açıklama: “Teslimatlar otomatik, sen işi büyütürsün” |
| 0:30–2:00 | Talep 3/dk, kapasite 2/dk, büyüyen küçük kuyruk | 100 ₺ bisiklet veya 100 ₺ hizmet kalitesi; ikisi başlangıçta yaklaşık 40 → 50 ₺/dk sağlayabilir |
| 2:00–4:00 | Seçilen yatırım kartında gerçek önce/sonra; ilk 5 teslimatta ekip sekmesi | Diğer yatırım veya ilk çalışan için biriktirmek |
| 3:00–6:00 | Ekip işe alımı ve otomatik sipariş ataması | Hız mı, ücret mi, paralel kapasite mi? Tek zorunlu satın alma sırası yok |
| 6:00–10:00 | Kuyruk eriyor veya çalışanlar boş kalmaya başlıyor | Talep sınırlıyorsa ek kurye yerine hizmet kalitesi; Beykoz için yakın ciro hedefi |
| İstenilen an ayrıl/geri dön | Para otomatik eklenmiş kısa özet ve uygun yatırım kartları | Oyun açık tutulmadan da aynı işletme ilerler |

Örnek yol: yaklaşık 1. dakikada bisiklet, 3. dakikada hizmet seviyesi, 5–6. dakikada ilk çalışan. Bunlar sabit örnek mesafe ve harcama varsayımıdır; gerçek rota/kuyruk sonucu ölçülmeden kesin zaman sözü verilmez. Çalışan alındığında birikmiş kuyruk, geçici olarak gelen talepten hızlı teslim edilebilir. Bu yüzden sabit gelir çarpımıyla kesin 10. dakika bakiyesi yazılmaz.

Erken ekip yönetimi için 9.000 ₺ şirket kilidi kaldırılması önerilir. İşletme baştan mikro şirket sayılır; ekip ekranı ilk 5 teslimatta açılır. 9.000 ₺ bedeli başka bir zorunlu kapıya otomatik taşınmaz. Bu değişiklik oyuncuya anlatılır ve eski şirket hakkı korunur.

İlk yükseltmenin görsel geri bildirimi: kurye/araç kartı ve ekip portresi değişir, süre/kapasite satırı önce→sonra gösterir. Haritada hareketli araç eklenmez. Hizmet yükseltmesi paket/hizmet rozeti ve sipariş ücretiyle görünür olur.

## 3. Temel oyun döngüsü
Esnaf siparişi gelir → sınırlı kuyruğa alınır → boş kurucu/çalışana otomatik atanır → teslim edilir → ücret kasaya yazılır → oyuncu yatırım seçer → kapasite veya sipariş değeri değişir → sonraki darboğaz/ilçe açılır.

**Tek gerçek hat:** Kurucu ve ekip aynı sipariş kaynağını ve aynı teslimat hesabını kullanır. Kurucuya ayrıca sınırsız sipariş üretip aynı zamanda ekip havuzunu saymak yok.

**İlk gerçek darboğaz:** Sipariş talebi ile toplam taşıma kapasitesinin dengesi.
- Talep 3/dk, kapasite 2/dk: “Kuryeler yetişemiyor”; kuyruk büyür.
- Talep 3/dk, kapasite 4,5/dk ve kuyruk boş: “Ekipte boş kapasite var”; yeni kurye bugün geliri artırmayabilir.
- Kapasite 4,5/dk, kuyruk dolu: ekip önce kuyruk eritir; geçici üretim 3/dk'dan yüksek olabilir.

Kuyruk 30 işlik tek tampondur; depo, yakıt, enerji ve paket hazırlama hattı ilk sürüme eklenmez. Dolu kuyruk yeni potansiyel siparişin alınamaması demektir; kazanılmış para/itibar düşmez. “Kaçırdın!” pencereleri ve giriş zorunluluğu yaratılmaz.

Ekran akışı:
Ana harita → alt sabit işletme durumu (talep / kapasite / kuyruk / tahmini ₺/dk) → 2–3 yatırım kartı → Ekip veya İlçeler.
Dönüş → kazanç dökümü + mevcut darboğaz → uygun yatırım kartları veya Oyuna Dön.
Prestige → önce/sonra + kayıplar/korunanlar → açık onay → yeni tur.

## 4. Ekonomi ve ilerleme sistemleri
### Tek para ve farklı roller
Harcama kaynağı oyun parası ₺; gerçek satış fiyatı değildir. Kasa harcanabilir, tur cirosu ve toplam ciro istatistiktir. Kalıcı itibar sayı/bonus olarak tutulur; ikinci bir harcama para birimi veya rastgele kart pazarı yok. İlk sürümde maaş, kira veya yakıt olarak sürekli para eksilten gider eklenmez; sipariş ücreti net oyun kazancıdır, yatırımlar tek seferlik alımdır.

| Yatırım | Etki | Etkisinin sınırı |
|---|---|---|
| Kurucu aracı / rota verimliliği | İlgili kuryenin iş süresini azaltır | Talep yoksa geliri sonsuz artırmaz |
| Hizmet kalitesi | Yeni sipariş ücretini artırır | Hizmet süresini kısaltmaz |
| Çalışan | Paralel taşıma kapasitesi ekler | Talep/boş kuyruk sınırına takılır |
| Yeni ilçe | Daha fazla talep, değişen trafik/mesafe ve yeni görsel | “Her koşulda daha iyi” sayılmaz; aktif etmek oyuncu kararıdır |

MVP'de talebi ayrıca pazarlama ağacıyla artırmaya gerek yoktur; ilçe geçişleri yeterli farklılık sağlar. Yönetici/araştırma çarpanları başlangıçta 1'dir. Otomasyon zaten açık olduğundan yönetici satın almak otomasyon şartı olmaz.

### Formüller
Kararlı durumdaki UI tahmini:
- Kapasite/dk ≈ Σ(60 / ilgili kuryenin ortalama tam iş süresi).
- Teslimat/dk ≈ min(talep/dk, kapasite/dk), yalnızca kuyruk boşalmış kararlı durum için.
- Beklenen ₺/sn ≈ teslimat/dk × ortalama net ödeme / 60.
- İş süresi = (alım yolculuğu + teslimat yolculuğu) / ilgili araç hızı × ilçe trafik etkisi. Aynı birimler kurucu ve ekipte kullanılır.
- Net ödeme = rota baz ücreti × (1 + 0,25 × hizmet seviyesi) × ilçe ücret etkisi × (1 + 0,25 × itibar sayısı).
- Hizmet maliyeti(L) = ceil(100 × 1,55^L); L alınmış hizmet seviyesi: 100, 155, 241, 373...
- Aynı rolde yeni çalışan maliyeti(n) = ceil(rol taban maliyeti × 1,60^n); örnek yaya: 150, 240, 384...
- Kurucu araç geçişleri ayrı kademe fiyatlarıdır: ilk deneme 100 / 800 / 2.500 ₺. Her maliyeti aynı üstel eğriye zorlamak gerekmez.

Hizmet ve itibar bonusları kendi içinde toplamsal seviyeler, birbirleri arasında çarpandır. Araç hız avantajı ayrıca ücret artışı olarak ikinci kez sayılmaz. Yukarıdaki oran formülü ödeme fonksiyonu değildir: gerçek para yalnızca tamamlanan siparişten yazılır.

Sipariş ücreti tek bir anda, iş kuyruğa kabul edilirken kilitlenir. Sipariş özgün ilçe kimliğini, rota verisini, trafik/ücret katsayılarını ve hizmet/itibar anlık değerlerini taşır. Kuyruktaki eski iş yeni ilçenin yüksek ücretine çevrilemez. Yeni hizmet seviyesi ve itibar yalnızca bundan sonra kabul edilen işleri etkiler. İş süresi ise kurye atandığında, ilgili rol ve siparişin özgün bölge koşullarıyla hesaplanıp kilitlenir. Araç değişiminin aktif işte kalan mesafeyi nasıl etkilediği tek bir kuralla belirlenir; MVP önerisi kabul edilmiş işin süresini de sabit tutmak ve yeni araç etkisini sonraki işe uygulamaktır. Satın alma kartı “Yeni siparişlerde” der.

Yatırım önizlemesi en az fiyat, eksik tutar, değişecek değer, beklenen net katkı ve sınırlayıcı sebebi gösterir. Katkı 0 ise “önerilen” etiketi verilmez; belirsiz rota ortalamaları yaklaşık işaretlenir. Getiri tahmini mevcut kuyruk geçişi ile uzun vadeli katkıyı ayırır. Dönüşte 2–3 anlaşılır seçenek, gerekirse gelecekte ulaşılabilir hedef olarak gösterilir; hepsinin o anda satın alınabilir veya hemen yararlı olduğu söylenmez. Yararsız kapasite alımı yerine biriktirme/ilçe seçeneği gösterilebilir. Oyuncu her dönüşte satın almaya zorlanmaz.

### İlçeler
Aynı anda bir etkin işletme bölgesi; yedi eşzamanlı şube ilk sürümde yok. Açılma ile etkin bölge seçimi ayrılır. Yeni ilçe gelince ücret/rota/boş kapasite kıyaslaması gösterilir; kazançta gizli otomatik ilçe değişimi yapılmaz. Bölge değişiminden sonra eski bölge yeni talep üretmez. Kuyruktaki ve sürmekteki kabul edilmiş eski işler özgün koşullarıyla tamamlanır; yeni kabul edilen işler seçili bölgeden gelir. Bu geçici karışık kuyruk çoklu şube üretimi değildir. Eski işler için rota verisi etkin haritadan yeniden yorumlanmaz. Ücretler değişmez; atanmış işlerin kalan süreleri korunur.

| İlçe | Tematik lojistik kimlik | Örnek talep/dk |
|---|---|---:|
| Şile | Düşük talep, sakin öğrenme alanı | 3 |
| Beykoz | Daha uzun kıyı teslimatları; hız önem kazanır | 5 |
| Üsküdar | Daha sık iş; paralel ekip önemli olur | 7 |
| Kadıköy | Yoğun esnaf siparişleri | 10 |
| Beşiktaş | Yoğunluk ve daha yüksek sipariş değeri | 14 |
| Şişli | Yüksek iş hacmi, daha uzun servis döngüsü | 20 |
| Beyoğlu | Sıkışık/yokuşlu rota karakteri, son tur hedefi | 28 |

Bunlar gerçek ilçe talep/nüfus istatistiği değildir. Tematik oyun parametreleridir. Ayrı ilçe katsayıları gerçek rota süresi/ödemede kullanılır; başka bir ikinci trafik çarpanı gizlice eklenmez.

İlk deneme tur cirosu eşikleri: 0 / 500 / 2.000 / 6.500 / 18.000 / 50.000 / 120.000 ₺. Beykoz için ilk 8–15 dakika bir test hedefidir. Mevcut 220.000 prestige eşiği yalnızca karşılaştırma başlangıcıdır; yeni ekonomiyle geçerliliği test edilmeden sabitlenmez.

## 5. Çevrim dışı ilerleme hesabı
Uygulama kapalıyken telefonda Godot çalıştırmak gerekmez. Dönüşte kaydedilmiş duruma geçen süre uygulanır.

- İlk deneme: mevcut 4 saat tavanı, çevrim dışı verim 1,0. Oyunu kapatmak üretimi ayrıca keyfî azaltmaz.
- Aynı sipariş üreticisi, kuyruk, kurye durumu ve ödeme kodu hem açık hem kapalı oyun için kullanılır.
- Bir sonraki sipariş gelişi/teslimat bitişine ilerleyen olay hesabı kullanılır; 4 saati kare kare veya kalan zamanı kaybeden 15 sn dilimlerle yürütmeyiz.
- Kesin ödeme tamamlanan işler toplamıdır. “Gelir/sn × süre × verim” yalnızca kararlı durumdaki yaklaşık açıklamadır.
- Örnek: kuyruk dengelendikten sonra 3 iş/dk ve 25 ₺/iş ile 10 dk ≈ 750 ₺. Başlangıçtaki kalan işler/kuyruk kesin sonucu değiştirebilir.
- Çevrim dışı otomatik satın alma, prestige veya etkin ilçe değişimi yok; açılan içerik dönüşte bildirilir.
- Özet: hesaplanan süre, kurucu/ekip kazancı, tamamlanan işler, gerekiyorsa 4 saat sınırı, mevcut darboğaz ve 2–3 uygun yatırım. Para önceden kasaya eklenir; özet üretimi durdurmaz.
- 4 saat tavanı testte 8/12 saat alternatifleriyle değerlendirilebilir; doldu bildirimleri veya reklamla tavan satışı MVP'de yok.

### Kayıt, saat ve cihaz sınırı
Kök ekonomi değişiminden önce sürümlü kayıt, son sağlam yedek ve veri göçü hazırlanır. Kasa, kabul edilmiş işler, kalan süre/mesafe, kuyruk, rastgele üretici durumu, kalıcı açılımlar, tüketilmiş zaman ve okunmamış özet birlikte saklanır.

Ödeme ve zaman ilerlemesi tek tutarlı kayıt işlemi olmalıdır. Geçici dosyaya yaz → doğrula → platforma uygun atomik değiştir → yedeği koru. Bozulma testinde son sağlam kayıt geri gelir. Kuruş altı artıklar saklanır; her karede yuvarlayarak para kaybı/çoğalması oluşmaz.

Açık oyun: monoton geçen süre. Kapalı oyun: UTC zaman farkı; negatif süre 0, gelecek sıçraması tavanla sınırlanır. Geri alınan saat son kabul edilen zaman işaretini geriye taşıyamaz; aynı geçmiş aralık tekrar kredilenmez. Kullanıcıya ceza veya kayıt silme yok.

Yalnızca cihaz saatiyle kesin hile önleme sağlanamaz. Cihazlar arası bulut eşitleme ilk sürümde bulunmaz; “aynı kaydı iki telefonda birleştirme” sözü verilmez. Sonraki aşamada sunucu zamanı, kayıt revizyonu ve çatışma seçimi gerekir; iki kasayı toplamak çözüm değildir.

Eski kayıttan göç: otomatik sıfırlama yok; kasa, toplam/tur cirosu, araç hakkı, çalışanlar, ulaşılan ilçeler ve yeniden başlama sayısı korunur veya açık eşdeğer kuralla taşınır. Eski süre önce eski sürüm kuralıyla bir kez hesaplanır; sonra yeni ekonomi başlar. Yeni 60 ₺ sermaye eski kayda tekrar verilmez. Önerilen şirket göçü: eski kayıtta mevcut tur için company=true ise kaldırılan şirket giriş bedeli olan 9.000 ₺ bir kez kasaya geri verilir; tur/toplam cirosuna ve ilçe açılışına eklenmez. Kayda göç sürümü ve tamamlanmış telafi işlemi birlikte yazılır; tekrar açmak ikinci telafi oluşturmaz. Önceki sıfırlanmış turlardaki şirket harcamaları için geçmiş satın alma kaydı bulunmadığından geriye dönük çoklu iade varsayılmaz. Bu telafi ve eski bonusun yeni kurala dönüşümü göç ekranında açıkça gösterilir. Korunan/değişenler tek seferlik açıklanır; göç başarısızsa orijinal yedek kalır.

## 6. Prestige tasarımı
**Önerilen ad:** İstanbul İtibarı / Yeni Şirket Turu. Tek katman, tek kalıcı sayı; rastgele eser, ikinci reset veya ayrı itibar dükkânı yok.

- Son ilçeye ulaşma ve yeterli tur cirosu şartı; 220.000 ₺ ilk test referansı.
- Her tamamlanan tur +1 itibar; gelir çarpanı 1 + 0,25 × toplam itibar. İlk tur %0 → %25; sonraki %25 → %50. Her defasında bileşik ×1,25 değil.
- A7 uygulandı: eski +10 yerine tur başına +25 yüzde puan. Eski ayrılık eski bonusla kapanır; itibar sayısı korunur. Bütünleşik denge A8'de doğrulanacak.
- Kasa, araçlar, hizmet seviyeleri, ekip, kuyruk ve tur içi etkin ilçe ilerlemesi sıfırlanır. Yeni turda tek sefer 60 ₺ kuruluş sermayesi verilir, ciroya sayılmaz.
- Toplam ciro/istatistik, ayarlar, kazanılmış İstanbul Albümü, kalıcı itibar ve görülmüş öğretici adımları korunur. İçeriklerin yeniden işletmeye açılması tur ekonomisine bağlıdır; albümdeki keşifler silinmez.
- Önizleme: “Şimdi +1 itibar; kalıcı ücret bonusu %0 → %25. Aynı örnek sipariş 25 → 31,25 ₺. Kasa/filo/ekip yeniden kurulur.” Kesin yeniden erişim süresi vaat edilmez.
- Yeni tur isteğe bağlıdır; bekleyen oyuncu mevcut işletmesinde devam edebilir.
- Eski rebirth_count 1:1 korunur; değişen bonus açıkça gösterilir. Sıfırlama + ödül + yeni kayıt tek işlem olur.

İlk prestige için başlangıç test hedefi: 12–24 saat hesaba katılan üretim, günde birkaç kısa ziyaretle yaklaşık 1–3 gün. Bu, simülasyon ve gerçek kullanıcı denemesiyle doğrulanacak hipotezdir; mevcut 220.000 eşiğinin bunu sağladığı iddia edilmez. Eşik bu hedefe uymuyorsa hedef/ekonomi birlikte revize edilir. İlk turdan sonraki ilk 10 dakikanın tekrar daha rahat ama hâlâ karar içeren olması gerekir.

## 7. Oyuncu tutma yöntemleri
- **Yakın hedef:** Bir sonraki yararlı yatırım, eksik tutar ve tahmini etkisi.
- **Orta hedef:** Açılacak ilçe, beklenen yeni talep ve mevcut filonun bunu karşılayıp karşılamadığı.
- **Uzak hedef:** İstanbul ağı ve yeni turdaki kalıcı itibar.
- **Aşamalı öğretim:** Kurucu otomasyonu baştan; 5 teslimatta ekip; Beykoz'da bölge karşılaştırması; ilerleyen ilçelerde yeni kurye rolleri; son ilçede prestige açıklaması.
- **İstanbul Albümü:** Her ilçede ilk işletme açılışında garantili bir kartpostal/şehir rozeti; 7 parçalık kalıcı koleksiyon. Mevcut harita görselleri yeniden kullanılabilir. Gacha, tekrarlı parça veya üretim zorunluluğu yok.
- **Dönüşte karar:** Araç/hizmet/çalışan arasından duruma uygun seçenekler; “Hepsini yap” listesi yok. Hiçbir alım yararlı değilse sonraki ilçe hedefi veya biriktirme önerilir.
- **Zorlamasız iletişim:** İlk sürümde bildirim ve reklam yok. Daha sonra bildirim eklenirse kapalı varsayılan, oyuncu seçimi ve somut fayda; seri kaybı tehdidi yok.
- **Daha sonraki etkinlik örneği:** Tekrar oynanabilir “Kadıköy Kitap Günü”; farklı paket sınıfı/öncelik tercihi. Ana oyunu kopyalayan yalnızca ×2 kazanç modu olmaz. Sona erince kazanılmış ödül geri alınmaz; ana ilerleme etkinliğe bağlı olmaz.
- Reklam/satın alma eklenmesi ayrı ürün kararıdır. Olursa kullanıcı tercihi, kesin ödül/fiyat, açık gerçek para ayrımı; gizli geri sayım, zorunlu reklam ve aşırı teklif penceresi yok.

## 8. İlk sürüm kapsamı
### Çekirdek sürüm
- Tek otomatik sipariş hattı ve kurucu dahil ortak kurye ekonomisi.
- Talep/taşıma kapasitesi darboğazı, 30 iş tamponu.
- Araç, hizmet ve erken ekip yatırımları; bir harcanabilir para.
- 7 mevcut ilçe görseli, bir etkin bölge, kademeli içerik açma.
- Aynı modelle çevrim dışı hesap; açıklayıcı dönüş ve yatırım ekranı.
- Tek prestige katmanı ve 7 garantili albüm kartı.
- Sürümlü yerel kayıt, veri göçü, zaman hesabı, yerel denge günlüğü.
- Android'de dokunma, metin, performans ve yaşam döngüsü doğrulaması.

### Sonraya bırakılanlar
Ayrı araştırma/yönetici ağacı, aynı anda çoklu şube, depo/yakıt/enerji, etkinlik, bildirim, bulut hesap, sosyal/klan, sıralama, reklam, gerçek para satın alma, sezon bileti. Bunlar yol haritasında görünür kalır; çekirdeğin çıkışını engellemez.

Savaş, boss, kahraman/gacha ve çok katmanlı prestige mevcut tema/kapsam için önerilmez. Başarılı bir başka oyunda bulunmaları tek başına ekleme gerekçesi değildir.

## 9. Geliştirme sırası ve kabul kapıları
Aşamalar bağımlılık sırasındadır. Her aşamada sonucu göster → kullanıcı kontrolü için dur. Ayrıca uygulama talebi gelmeden bu tasarım turunda oyun kodu yazılmaz.

| Aşama | Teslim | Tamamlanma şartı |
|---|---|---|
| A0 — Tasarım | Araştırma arşivi, bu belge, sistem izleme ve yol haritası | Mevcut/öneri ayrımı, bütün araştırma maddeleri, kullanıcı incelemesi |
| A1 — Güvenli temel | Kayıt sürümü/göç/yedek; ekonomi verilerini UI'dan ayırma; mevcut davranışın başlangıç ölçümü | Eski kayıtta para/araç/ekip kaybı yok; yarım yazmadan kurtarma; bu adımda gizli denge değişimi yok |
| A2 — Ortak simülasyon | Kurucu+ekip aynı kuyruk ve olay saati; açık/kapalı aynı ödeme | Aynı başlangıç/tohumla 10 dk farklı zaman adımları ve kapalı hesap eşdeğer; çift ödeme yok; eski modele göre üretim farkı raporlanır |
| A3 — Stratejik ekonomi | Araç/hizmet/işe alım, gerçek darboğaz ve maliyet eğrileri | Üç strateji ve farklı rota örnekleriyle gerçek katkı/boş kapasite doğrulanır |
| A4 — İlk 10 dakika | Erken ekip yönetimi, aşamalı açıklamalar, görünür yatırım değişimi | Oyuncu yardım almadan neden gelir sınırlı ve hangi iki yatırımı seçebileceğini anlatır |
| A5 — Dönüş ve öneriler | Var olan özetin ortak ekonomi, 2–3 bağlamsal yatırım ve yakın hedefle uyarlanması | Toplam=döküm=kasa işlemleri; yararsız alım önerilmez; kapanıp açınca tekrar ödeme yok |
| A6 — İlçeler/keşif | Açılma/etkinleşme ayrımı, tematik parametreler ve İstanbul Albümü | Yeni bölge aktif işleri bozmaz; albüm kalıcı; yeni talebin etkisi anlaşılır |
| A7 — Prestige | Önizleme, +1 itibar, korunacak/sıfırlanacak alanlar, tekrar tur dengesi | Ödül yalnızca bir kez; bonus örnek hesapla tutarlı; eski itibar korunur |
| A8 — Denge ve ölçüm | Yerel olay günlüğü, otomatik karşılaştırmalar, oyuncu denemesi | Hız/ücret/ekip stratejilerinden birinin sürekli anlamsız kaldığı durumlar giderilir |
| A9 — Android | Araç hazırlığı, APK, gerçek telefon testleri | Dokunma/okunabilirlik; kilit ekranı, uygulama kapatma ve uzun dönüşte tutarlı kayıt/gelir |

Ölçüm için gereken asgari yerel olaylar A1–A3'te belirlenir, ilk 10 dakika denemesi A4'te yapılır; denge işi A8'e kadar tamamen ertelenmez. A8 bütünleşik ayardır. Reklam veya canlı sistem için ayrıca yeni kapsam/teknik plan gerekir.

A1 mevcut davranışı koruyan temeldir. A2 ortak sipariş modeline geçtiği için üretimi zaten değiştirebilir: bu aşamada eski fiyatlar referans yapılandırma olarak kullanılır, eski/yeni üretim farkları açıkça raporlanır ve A3 hedef fiyatları henüz uygulanmaz. Tam davranış eşitliği eski motorla değil, yeni motorun açık/kapalı zaman yolları arasında aranır. A3 bundan sonra hedef ekonomiyi ayarlar.

Önerilen teknik sınır: simülasyon durumu ve advance işlemi UI'dan bağımsız; ekonomi verileri tek tabloda; kayıt/göç ayrı katmanda; main.gd yalnızca durum gösterimi ve kullanıcı kararlarını iletmeye doğru aşamalı sadeleşir. Mevcut kod tek seferde baştan yazılmaz. Harita varlıkları korunur.

## 10. Açık tasarım riskleri ve testleri
| Risk | Nasıl doğrulanır? |
|---|---|
| Çevrim dışı oyun daha az/fazla ödüyor | Aynı kayıt/tohumda 600 sn açık, kapalı ve farklı adımlı hesap; kasa/iş/kuyruk/ücretin tamamı aynı |
| Fazla zaman kayboluyor | 95 sn işte 15 sn adımlar ile olay saati karşılaştırması; artık süre sonraki işe geçer |
| Tek yatırım her zaman üstün | Araç-önce, hizmet-önce, ekip-önce; kısa/uzun rota ve düşük/yüksek talep; para kadar karar çeşitliliği de incelenir |
| İlk çalışan sonrası sahte gelir tahmini | Biriken kuyruğun eridiği geçici hız ile uzun vadeli talep sınırını ayrı ölç |
| Hızlı kurye yavaşları işsiz bırakıyor | Kuyruk adaleti, uygun iş dağıtımı, gereksiz çalışan alımını önerme kontrolü; aynı iş iki kez atanmaz |
| Yeni ilçe yalnızca resim değiştiriyor | Daha uzun rota/daha yüksek talepte farklı yatırım önerisi ve gerçek sonuç doğrulanır |
| Geçişte iş/ücret değişiyor | Araç/hizmet/bölge değişimini aktif iş ortasında test et; kilitli ücret ve kabul edilmiş iş korunur |
| Prestige ödülü yetersiz veya şişirici | Aynı stratejinin ilk ve ikinci tur karşılaştırması; toplamsal bonus ve tek ödül; süre tahmini oyuncu denemesiyle |
| Sıfırlama/göç veri kaybettiriyor | Eski formatlar, bozuk JSON, işlem ortası kapatma, onay iptali; yedekten geri yükleme |
| Cihaz saati tekrar kazanç üretiyor | Saat geri/ileri alma, aynı aralığa dönme, saat dilimi değişimi, art arda resume; 4 saat ve 4 saat+1 sınırı |
| Birden fazla cihaz kasa çoğaltıyor | MVP'de bulut yok; sonraki bulut sürümünde kayıt revizyonu/çatışma çözümü ayrı test edilir |
| Oyuncu ekranı anlayamıyor | Küçük telefonlarda görev vermeden ilk yatırım/ekip/ilçe seçimi; “Darboğaz nedir?” gözlemi |
| Yoğun işte performans bozuluyor | Son ilçe, yüksek ekip sayısı, 30 kuyruk ve 4 saat dönüş; profiler ve gerçek telefon; her iş için UI yeniden kurma yok |
| 4 saat sınırı geri gelme baskısı yaratıyor | Günde 1–3 ziyaret ve uzun ara senaryoları; 4/8/12 saat seçeneklerini test et, kayıp korkusu dili kullanma |

### Ölçüm sözlüğü
Metrikler tasarım kararını sınar; mevcut kullanıcı verisi veya başarı sonucu yoktur.
- Yerel olaylar: session_start, automatic_delivery_completed, upgrade_purchased, worker_hired, offline_applied, return_summary_shown, district_unlocked/activated, bottleneck_changed, prestige_preview/confirmed.
- Olaylar oturum/kayıt revizyonu ve ekonomi sürümüyle eşleşir. Ham kişisel bilgi veya gizli ağ gönderimi eklenmez.
- İlk otomasyon zaten başta açıktır: ilk otomatik teslimat ve ilk bağımsız çalışan teslimatı ayrı ölçülür. “Otomasyonu açtı” oranı bu oyunda tek başına anlamlı değildir.
- İlk çevrim dışı dönüş: en az 60 sn sonra geçerli offline_applied; aynı zaman aralığı tek olay.
- İlk prestige oranı/süresi: ilk kuruluştan ilk onaylı prestige'e; hem takvim süresi hem hesaba katılan üretim süresi ayrı tutulur.
- Takılma: mevcut talep/kapasite, son yararlı satın almadan geçen süre ve yeni oyuncunun açıklayabildiği seçenekler birlikte incelenir.
- Anlamlı karar: üretim/ücret/kapasite veya etkin bölgeyi değiştiren bilinçli seçim; her tıklama sayılmaz, öğreticide zorlanan seçim ayrı işaretlenir.
- D1/D7/D30: yeterli yaştaki kurulum kohortlarında sırasıyla [24,48), [168,192), [720,744) saat aralığında dönenler / uygun kurulumlar. Takvim günü tanımı seçilecekse analizden önce sabitlenir.
- Etkinlik katılımı ve reklam sonrası çıkış, ilgili özellik eklenmeden ölçülebilir sayılmaz.
- Tek yerel geliştirme günlüğü küresel D1/D7/D30 üretmez. Gerçek kohortlar için oyuncu testi ve uygun veri/izin düzeni gerekir. İlk sürümde yerel ölçüm, sonraki yayında onaylı asgari analitik ayrı karardır.

### Araştırmadaki 14 sistemin izleme tablosu
| # | Sistem | Karşılığı / durum | Aşama |
|---|---|---|---|
| 1 | Üretim/toplama | Otomatik teslimat ve kasaya kredi; ortak hatla revize | A2–A4 |
| 2 | Maliyet/çarpanlar | Üstel hizmet/işe alım; veri tablosu, katkı önizlemesi | A3 |
| 3 | Gerçek darboğaz | Talep–taşıma kapasitesi ve tek kuyruk | A2–A3 |
| 4 | Erken otomasyon | Kurucu baştan otomatik; ilk 5 teslimatta ekip | A4 |
| 5 | Çevrim dışı | Aynı olay hesabı; tavan/verim açık | A2, A5 |
| 6 | Dönüş ekranı | Var olan özeti koru; 2–3 uygun seçenek | A5 |
| 7 | Kısa/orta/uzun hedef | Yatırım, ilçe, İstanbul İtibarı | A4–A7 |
| 8 | Aşamalı mekanik | Ekip, yeni roller, ilçe, prestige sırası | A4, A6–A7 |
| 9 | Prestige | Tek itibar katmanı, açık önizleme | A7 |
| 10 | Stratejik gelişimler | Hız, hizmet, paralel ekip; talebe göre tercih | A3 |
| 11 | Koleksiyon/keşif | 7 garantili kalıcı İstanbul Albümü parçası | A6 |
| 12 | Etkinlik/sosyal/canlı | Fikirler kayıtlı; çekirdek sonrası ayrı kapsam | Ertelendi |
| 13 | Kayıt/zaman/cihaz | Yerel sürüm/göç/atomik işlem şimdi; bulut sonra | A1–A2, A9; bulut ertelendi |
| 14 | Olay ölçümü/denge | Asgari yerel olaylar erken, karşılaştırmalı denge | A1–A4, A8 |

### Henüz sonuçlandırılmayacak kararlar
Son denge katsayıları ve prestige eşiği, 4 saat tavanının nihai seçimi, bulut/hesap hizmeti, reklam/ödeme politikası ve etkinlik takvimi ölçüm/kullanıcı kararı gerektirir. Bu belgenin varlığı bu özellikleri uygulama, kurulum veya harici servise veri gönderme izni değildir.


### A3 uygulama notu — 28 Ekim 2026
Araç/hizmet/çalışan yatırımları ve gerçek talep-kapasite hesabı uygulandı; uygulanan değerler ve kontrollü ölçümler `a3-uygulama-raporu.md` içindedir. Ekip yönetiminin 5 teslimatta ücretsiz açılması A3'e öne alındı. Buradaki sonraki aşama önerileri tamamlanmış ürün özellikleri değildir. Mevcut ilçe eşikleri ve %10 prestige bonusu A6/A7'ye kadar korunur.

### A4 uygulama notu — 28 Ekim 2026
İsteğe bağlı beş durum adımı, yakın/uzak hedef, rehber okundu kaydı ve ilk 10 dakika ölçümleri uygulandı. Ayrıntılar `a4-uygulama-raporu.md` içindedir. Oyuncunun yardımsız anlaması kullanıcı denemesiyle doğrulanacak; ekonomi katsayıları bu aşamada değiştirilmedi.

### A5 uygulama notu — 28 Ekim 2026
Dönüşte gerçek katkı dökümü, mevcut darboğaz ve pozitif katkılı yatırım seçenekleri uygulandı. Uygun yatırım sayısı azsa ilçe/rehber bilgi seçenekleri kullanılır; sıfır katkılı alım önerilmez. Ayrıntılar `a5-uygulama-raporu.md` içindedir. A6 ilçe/albüm ve A7 prestige önerileri henüz uygulanmadı.

### A6 uygulama notu — 28 Ekim 2026
İlçe açılma/etkinleştirme ayrımı, gerçek hesapla uyumlu karşılaştırma ve kalıcı 7 kartlık İstanbul Albümü uygulandı. İlçe mesafeleri ayrıldı ve önerilen 500/2.000/6.500/18.000/50.000/120.000 eşikleri denemeye alındı. İlk Beykoz 15 kontrollü koşuda 7,6–9,1 dk; 8 dk altındaki örnekler A8 denge değerlendirmesine kaydedildi. Kayıt şeması 4, ekonomi sürümü 3; geçmiş süre eski modeliyle kapanır. Ayrıntılar `a6-uygulama-raporu.md` içindedir. Prestige hâlâ eski %10 değerindedir; önerilen %25 A7'de değerlendirilecek.

### A7 uygulama notu — 28 Ekim 2026
İstanbul İtibarı, kilitliyken de açılan önce/sonra önizleme ve +25 yüzde puan kuralı uygulandı. Yeni tur tam kaydı yazıldıktan sonra çalışan işletme sıfırlanır; yazma hatasında mevcut işletme korunur. Şema 5 / ekonomi 4; eski süre eski bonusla kapanır. Beş eşleşen ilk 10 dakika örneği ikinci turun daha rahat başladığını gösterdi; ilk prestige için 12–24 saat hedefi henüz doğrulanmadı. 220.000 eşiği A8 ölçüm başlangıcı olarak korundu. Ayrıntılar `a7-uygulama-raporu.md` içindedir.

### A8 uygulama notu — 28 Ekim 2026
İlk ilçe eşiği 550 ₺'ye ayarlandı; 15 erken örnekte 8,2–9,5 dk. Diğer fiyatlar/eşikler ve itibar 220.000 korundu. 42 uzun politika örneğinde idle dönüş düzeni ölçüldü; ilk 10 dakika sonrası 4/8 saat dönüş örnekleri yaklaşık 12/24 saat duvar süresinde ilk itibara erişti. Sürekli aktif politika yaklaşık 2 saattir; 12–24 saat hedefi her oyuncuya zorunlu alt bekleme değil idle dönüş temposu olarak yorumlandı. Bu kapsam kararı kullanıcı denemesinde değerlendirilecek. Yerel ve sınırlı olay günlüğü eklendi; retention oranı üretilmedi. Şema 6 / ekonomi 5. Ayrıntılar `a8-uygulama-raporu.md` içindedir. Küçük oyuncu denemesi tamamlanmış sayılmaz.

### A9 uygulama notu — 28 Ekim 2026
Windows debug APK ve Samsung A50 Android11 kontrolü tamamlandı. Eski oyuna dokunmadan ayrı test paketi kuruldu; eski kaydın kopyasıyla göç ve gerçek arka plan hesabı doğrulandı. Geri tuşu, duraklama guard'ı, 30FPS sınırı ve gerçek dokunmatik albüm kaydırması düzeltildi. 18 test geçti; 123sn cihaz kazancı bağımsız motorla eşleşti. Ayrıntılar `a9-uygulama-raporu.md` içinde. Bu tek cihaz debug denemesidir; serbest oyuncu denemesi, çoklu cihaz/pil/ısı ve mağaza yayını tamamlanmış sayılmaz. Kullanıcı geri bildirimi için dur.
