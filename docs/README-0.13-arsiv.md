# İstanbul Kurye

## İstanbul Kurye — 0.13 görsel test sürümü

Kullanıcının araştırması `docs/idle-arastirma-notlari.md`, tasarım `docs/oyun-tasarim-belgesi.md`, güncel aşama `docs/gelistirme-plani.md` içindedir. A1 kayıt temeli, A2 ortak sipariş/zaman motoru ve A3 stratejik ekonomi uygulandı. A3 sonuçları `docs/a3-uygulama-raporu.md` içindedir. A4 isteğe bağlı ilk adımlar rehberi de uygulandı; kullanıcı anlama denemesi bekleniyor. A5 dönüş önerileri de uygulandı; kullanıcı kontrolü bekleniyor. A6 ilçe seçimi ve İstanbul Albümü uygulandı; kullanıcı kontrolü bekleniyor. A7 İstanbul İtibarı ve yeni tur önizlemesi uygulandı; kullanıcı kontrolü bekleniyor. A8 teknik ölçüm ve ilk denge ayarı uygulandı; küçük kullanıcı denemesi bekleniyor. A9 Windows debug APK ve Samsung A50 / Android 11 kontrolü tamamlandı; kullanıcı serbest oyun geri bildirimi bekleniyor.

Godot 4.6 ile hazırlanmış tek oyunculu Android idle prototipi. Kurucu ve ekip ortak kuyruktaki siparişleri otomatik taşır; ödeme otomatik kasaya eklenir. Sabit piksel haritada hareketli karakter yoktur. Yeni oyun 60 ₺ ile başlar; bu tutar ciro sayılmaz. Araç kapasiteyi, hizmet seviyesi sipariş ücretini, çalışanlar paralel taşıma kapasitesini artırır. İlk 5 teslimatta ekip yönetimi ücretsiz açılır. İlk bisiklet ve hizmet yükseltmesi 100 ₺, ilk yaya çalışan 150 ₺ tutar. Hizmet ve aynı roldeki çalışanların sonraki fiyatları artar.

Talep, kapasite, bekleyen kuyruk ve yaklaşık sürekli gelir gösterilir. Talep tamamen karşılanıyorsa ek hız/çalışanın sürekli gelir katkısı sıfır olabilir; birikmiş kuyruğu eritmek ayrı belirtilir. Tahminler dengelenmiş akış içindir, anlık ödeme vaadi değildir. Kabul edilmiş işin ücreti ve atanmış süresi korunur. Açık ve kapalı oyun aynı olay hesabını kullanır; çevrim dışı süre dört saatle sınırlıdır. Kayıt cihazda tutulur.

## Giriş ve ayarlar

Uygulama açıldığında giriş menüsü görünür. Yeni kayıt `Oyuna Başla`, eski kayıt `Devam Et` ile açılır. Oyun içindeki dişli düğmesi veya giriş menüsü ayarları açar. `Oyunu Sıfırla` önce onay ister; onaylanınca bu cihazdaki kasa, ciro, bölge, araç, çalışanlar, rebirth ve kamera ilerlemesi sıfırlanır. İptal edildiğinde kayıt korunur. Menü ve ayarlar açıkken oyun görüntüsü durur; devam edildiğinde geçen süre çevrim dışı kazanç hesabına katılır.

## Sabit harita

Uzun telefonlarda orta harita alanı kullanılabilir yüksekliğe genişler. Sabit piksel sanat arka planı ve kutu içindeki dükkân/ev simgeleri gösterilir; güncel hedefin çerçevesi hafifçe yanıp söner. Simgeler her görselin kendi konumlarına bağlıdır. Bir simgeye dokunmak yer adı, türü ve mevcut siparişteki rolünü gösteren bilgi kartını açar. Kartlar yalnızca bilgi verir; teslimat rotaları otomatik seçilir ve oyuncunun müdahalesi gerekmez. Kart açıkken teslimatlar devam eder. Bu görünümde kaydırma, yakınlaştırma ve karakter takibi kullanılmaz. Yedi ilçenin her biri için ayrı görsel vardır; harita gerçek ölçekli navigasyon haritası değildir.

Teslimat kartı dükkânı, müşteriyi ve o anki alım/teslim aşamasını gösterir. Turuncu dükkânı, turkuaz müşteriyi belirtir. Tahmini süre atamada kilitlenen işin kalan alım/teslimat aşamasından hesaplanır; araç satın almak aktif işin süresini veya ücretini değiştirmez. Kurucu boşsa sipariş beklediği açıkça gösterilir. İlerleme çubuğu her yeni alım veya teslimat aşamasında yeniden başlar.

### Şile oyun haritası

Şile bölümündeki kıyı, yollar, evler ve teslimat noktaları oyun için kurgusal olarak tasarlanır. Gerçek coğrafyayı temsil etmez. Seyrek, bağlı yol ağını üretmek için:

```sh
python3 tools/build_fictional_sile_map.py
```

Bu komut `assets/maps/sile.json` dosyasını oluşturur. Yol ağı, sipariş mesafelerini ve arka plandaki teslimatları hesaplamak için kullanılmaya devam eder.

## Bölge ilerlemesi

Oyuncu Şile'de başlar. Tur cirosu büyüdükçe Beykoz, Üsküdar, Kadıköy, Beşiktaş, Şişli ve Beyoğlu açılır. Açılma etkin ilçeyi değiştirmez; oyuncu karşılaştırma ekranından seçer. Yeni talep seçilen ilçeden gelir, eski işler özgün koşullarıyla tamamlanır. Eşikler 0/550/2.000/6.500/18.000/50.000/120.000 ₺'dir. Sıra, coğrafi geçiş ve oyundaki sipariş talebi için tasarlanmıştır; gerçek nüfus sıralaması değildir. Yoğun bölgelerde teslimat trafiği kuryeyi biraz yavaşlatır, ve sipariş talebi artar. Son bölgedeki tur cirosu 220.000 ₺ olduğunda oyuncu onay vererek yeniden başlayabilir. Kasa, araç, hizmet ve ekip sıfırlanır; toplam ciro ve İstanbul Albümü korunur ve her tamamlanan tur +1 İstanbul İtibarı ve +25 yüzde puan kalıcı kazanç bonusu verir (%0 → %25 → %50). Şile'nin ayrı kıyı ve yol ağı vardır. Diğer altı bölgenin ayrı simge yapıları ve harita illüstrasyonları vardır; teslimat mesafelerini hesaplayan temel yol ağı hâlâ ortaktır.

## Geliştirme

Arayüz, `assets/ui/istanbul_theme.tres` ve `scenes/ui/FramedPanel.tscn` ile ortak lacivert/kehribar bir görünüm kullanır. Açılış için `assets/ui/menu_sahil.png`, ekip paneli için `assets/ui/ekip_portreleri.png`, sabit harita için `assets/maps/sile_sabit.png` ve `assets/maps/istanbul_sabit.png` üretilmiştir; paketteki SVG simgeler de kullanılır. Yedi ilçenin her biri ayrı harita görseli ve simge konumları kullanır. Eski ortak İstanbul görseli yalnızca yedek varlık olarak korunur.

Windows'ta görsel kontrol için, oyuncunun gerçek kaydını korumak üzere `APPDATA` geçici bir dizine yönlendirildikten sonra `godot --path . --rendering-method gl_compatibility --audio-driver Dummy --script res://tools/capture_ui.gd` çalıştırılabilir. Görüntüler `build/ui-check/` altına kaydedilir. Gerçek Android cihazdaki dokunma ve performans kontrolü ayrıca gereklidir.

Godot düzenleyicisi için `/workspace/kurye-istanbul` içinde `godot --path . --editor` çalıştırın.

Hazırlanmış bulut ortamında debug APK derlemek için:

```sh
bash tools/build_android.sh
```

Çıktı: `build/istanbul-kurye-debug.apk`. Bu APK test imzası taşır; mağaza yayını için ayrı bir yayın anahtarı ve cihaz testi gerekir.

Başsız doğrulama: `godot --headless --path . --editor --quit`.

Pixel art parçaları `assets/` altında tutulur. Yaya kurye, bisiklet, motor, hızlı motor ve şirket arabası için dört yönlü sprite atlasları; ayrıca zemin, bina, çevre ve dükkân/apartman işaretleri vardır. Kaynak çizim betiği `python3 tools/generate_art.py` ile bu PNG dosyalarını yeniden oluşturur.

Teslimat akışı ve eski kayıt uyumluluğu: `bash tools/test_delivery_flow.sh`. Betik test kayıtlarını geçici bir dizinde tutar.

Teslimat aşaması, ortak saate bağlı ilerleme ve kabul edilmiş işin kilitleri: `godot --headless --path . --script res://tests/delivery_status.gd`. Gerçek kayıtları korumak için bunu geçici bir Godot kullanıcı veri diziniyle çalıştırın.

Şirket gelişimi ve çalışan geliri: `bash tools/test_staff_progression.sh`. Bu betik de test kayıtlarını geçici bir dizinde tutar.

Bölge açılması, rebirth ve kayıt uyumluluğu: `bash tools/test_district_progression.sh`.

Uzun ekran, sabit simgeler, bilgi kartlarının otomatik rotayı koruması ve panel açıkken dokunmayı engelleme: `bash tools/test_map_camera.sh`.

Giriş menüsü, eski kayıt, duraklatma ve onaylı sıfırlama: `bash tools/test_menu_reset.sh`.

A2 öncesindeki tek otomatik koşuda kaydedilen 1/4/11/21 dakika ve 152 dakika ilerleme ölçümleri tarihsel prototip verisidir. Ortak sipariş modeli üretim temposunu değiştirdiği için bu süreler mevcut sürüme uygulanamaz. Yeni denge A3/A4 ve A8 aşamalarında ölçülecek.

Bu bir oyun mekanik ve görsel prototipidir. Yol ağı çizimden ayrı kavşak ve bağlantılar olarak tutulur; harita görselleri kurgusaldır. Çevrim içi sıralama ve yayın imzası henüz yoktur.

Araç yükseltme ekranı ortalama süre değişimini, yaklaşık sürekli gelir katkısını ve eksik tutarı gösterir. Hizmet kartı ortalama sipariş ücretini artıran ayrı yatırımdır. Devam eden siparişin ücreti satın alma sırasında değişmez. Ekip ekranında yoldaki çalışanlar, boş ekip sayısı ve sonraki işe alım maliyeti görünür; süreler eşit örnek mesafe karşılaştırmasıdır. Bu gösterimler `tests/progression_ui.gd` ile doğrulanır.

En az bir dakikalık ayrılışta kazanç oluşursa geri dönüş özeti gösterilir: kuryenin ve ekibin gerçek kazançları, ekip teslimatları ve hesaplanan süre ayrı görünür. Her ayrılış için dört saat sınırı korunur. Özet bilgilendirme amaçlıdır; para önceden kasaya eklenir ve otomatik teslimatlar devam eder. Okunmamış özet kayıtta korunur, kapatmak yeniden ödeme yapmaz. Doğrulama: `tests/offline_summary.gd` (geçici kullanıcı veri diziniyle).

Kadıköy için `assets/maps/kadikoy_sabit.png`, Beşiktaş için `assets/maps/besiktas_sabit.png` kullanılır. Gerçek yapıların siluetlerini taşıyan bu görseller stilize ilçe kolajlarıdır. Üretim yönergeleri ve referanslar: `docs/ilce-sanati-ikinci-grup.md`. Oyun içi kısa/uzun ekran önizlemeleri `build/ui-check/district-art-3*.png` ve `district-art-4*.png` altında oluşturulur.

Şişli için `assets/maps/sisli_sabit.png`, Beyoğlu için `assets/maps/beyoglu_sabit.png` kullanılır. Üretim yönergeleri ve gerçek yapı referansları `docs/ilce-sanati-ucuncu-grup.md` içindedir. `tests/map_camera.gd`, yedi ilçenin farklı görsel kullandığını ve iki ekran boyutundaki simge dokunma alanlarının çakışmadığını doğrular.

## A2 ortak hesap doğrulaması
`tests/simulation_clock.gd`, 600 saniye açık/kapalı hesabı, farklı zaman adımları, yeniden başlatma, dört saat tavanı, bölge geçişi, eski kayıt ve tekrar ödeme kontrollerini kapsar. `scripts/legacy_dispatch.gd` yalnızca eski kayıtların bir defalık geçmiş hesaplaması ve karşılaştırma örneği içindir. A2 tarihsel olarak kayıt şeması 2 / ekonomi sürümü 1 kullandı. A3–A5 kaydı şema 3 / ekonomi sürümü 2 kullandı. A6 şema 4 / ekonomi sürümü 3 kullandı. A7 şema 5 / ekonomi sürümü 4 kullandı. Güncel A8 şema 6 / ekonomi sürümü 5 kullanır. Normal çevrim dışı üretimde sabit kurucu gelir tarifesi kullanılmaz.

Ek A2 ekranları `tools/capture_a2.gd` ile oluşturulur; önce APPDATA geçici bir dizine yönlendirilmelidir. Bekleme, aktif ekip ve önceki ilçe işi görüntüleri `build/ui-check/a2-*.png` altındadır. A9'da Samsung A50 / Android 11 üzerinde ilk gerçek cihaz kontrolü yapıldı; çoklu cihaz ve uzun pil kontrolü bekliyor.

## A3 stratejik ekonomi doğrulaması
`tests/strategic_economy.gd`, üç yatırım yolu, talep/kapasite darboğazı, sıfır marjinal katkı, fiyat eğrileri, hizmet kaydı ve eski şirket bedelinin tek seferlik telafisini kapsar. Eski kayıtların geçmiş süresi eski kurallarıyla kapatılır; şirketi açık eski kayda ciroya eklenmeden 9.000 ₺ iade edilir. Gerçek oyuncu kaydı testlerde kullanılmaz. A3 ekranları geçici APPDATA ile `tools/capture_a3.gd` üzerinden üretilir. Bu A3 tarihsel kontrolünde ilçe eşikleri ve %10 prestige korunmuştu; A6 yeni ilçe eşiklerini, A7 +25 yüzde puan itibarı uyguladı.

## A4 ilk adımlar rehberi
Alt rehber düğmesi otomatik teslimat, yatırım farkı, ilk 5 teslimatta ekip, ilk çalışan ve darboğaz için mevcut ilerlemeye uygun kısa kart açar. Üretim sürer, zorunlu yatırım yoktur. Kartta yakın adım ve sıradaki ilçe hedefi birlikte görünür. Okundu bilgisi kaydedilir; tam sıfırlamada temizlenir. `tests/onboarding.gd` davranışları, `tools/measure_a4.gd` üç strateji/beş tohumun ilk 10 dakikasını doğrular. Sonuçlar ve sınırlar `docs/a4-uygulama-raporu.md` içindedir. Ekranlar `tools/capture_a4.gd` ile geçici APPDATA kullanılarak alınır.

## A5 dönüş kararları
Dönüş özeti gerçek kazanç dökümüne ek olarak mevcut darboğaz, kasa, talep/kapasite ve sonraki hedefi gösterir. Pozitif gelir katkılı yatırımlar bedel/eksik tutar ile sıralanır; sıfır katkılı kapasite alımı önerilmez. Az yatırım seçeneği varsa ilçe hedefi ve rehber bilgi seçenekleri sunulur. İncele düğmeleri satın almaz. Okunmamış döküm korunur; özet açmak/kapatmak yeniden ödeme yapmaz. Doğrulamalar `tests/return_choices.gd`, `tests/offline_summary.gd`; ayrıntılar `docs/a5-uygulama-raporu.md`. `tools/capture_a5.gd` geçici APPDATA ile ekran örneklerini üretir.

## A6 ilçe seçimi ve İstanbul Albümü
İlçe ekranı mevcut filo için talep, ortalama süre/ücret ve yaklaşık sürekli gelir karşılaştırır. Açık ilçeler ücretsiz seçilebilir; eski kabul edilmiş işler değişmez. İlçe geçişi sipariş üretmez. Her ilçede ilk kez çalışmaya başlamak kalıcı bir kartpostal kazandırır. Albümde yedi mevcut piksel harita büyük kaydırılabilir kartlar olarak kullanılır; yeni turda korunur, tam sıfırlamada temizlenir. Eski ziyaretler kayıt göçünde taşınır. `tests/district_choice.gd` ve `tests/district_progression.gd` ilgili davranışları doğrular; `tools/capture_a6.gd` ekranları üretir. Sonuçlar ve ölçüm sınırları `docs/a6-uygulama-raporu.md` içindedir.

## A7 İstanbul İtibarı
İlçe ekranındaki yeni tur önizlemesi kazanılacak +1 itibarı, önce/sonra kalıcı bonusu ve aynı Şile başlangıç işinin ücretini gösterir. Koşullar sağlanmadan inceleme yapılabilir; başlatma kilitlidir. Etkin Beyoğlu ve 220.000 ₺ tur cirosunda isteğe bağlı yeni tur açılır. Kasa, araç, hizmet, ekip, kuyruk ve ilçe erişimi sıfırlanır; toplam ciro, albüm ve görülmüş rehber kalır. Yeni 60 ₺ sermaye ciro değildir. Tam yeni tur kaydı yazılamazsa mevcut işletme değişmez. Eski kayıtların ayrılığı eski %10 kuralıyla hesaplanır, sonra korunmuş itibar sayısı yeni %25 kuralına geçer. Doğrulama `tests/prestige.gd`, eşleşen ilk/ikinci tur ölçümü `tools/measure_a7.gd`, ekran yakalama `tools/capture_a7.gd`; sonuçlar `docs/a7-uygulama-raporu.md`. A8 örneklerinde 220.000 eşiği idle dönüş temposuna uygun bulundu ve korundu; gerçek kullanıcı denemesi henüz bekliyor.

## A8 denge ve yerel ölçüm
İlk ilçe hedefi 550 ₺; eski kazanılmış erişim korunur. 42 uzun politika koşusu ve 15 erken oyun örneğiyle başlangıç/ilk itibar/ikinci tur karşılaştırıldı; sonuçlar ve sınırlar `docs/a8-uygulama-raporu.md` içinde. `godot --headless --path . --script res://tools/measure_a8.gd -- tuned` ham JSON üretir (diğer etiketler: baseline, warm-start); mutlaka geçici APPDATA ile çalıştırılmalıdır. Test politikası oyunda otomatik satın alma/ilçe geçişi açmaz.

`scripts/local_metrics.gd` sadece mevcut cihazdaki oyun kaydında son 128 olay, ilk gözlemler ve toplam sayaçlar tutar. Ağ/harici analitik/cihaz kimliği yoktur. Yatırım, otomasyon, ilçe, gerçek dönüş ve itibar gözlenir; para hesabını etkilemez. Eski kayıt geçmişi uydurulmaz, normal turda toplamlar kalır, tam sıfırlamada temizlenir. `tests/balance_metrics.gd` sınırları, olay saatini, kayıt ve ödülsüz gözlemi doğrular. D1/D7/D30 veya gerçek oyuncu eğlencesi ölçülmüş sayılmaz; küçük oyuncu denemesi ve A9 Android kontrolleri bekliyor.

## A9 Windows derlemesi ve cihaz sonucu
`powershell -ExecutionPolicy Bypass -File tools/build_android.ps1` ayrı Android A9 Test paketini üretir: `build/istanbul-kurye-a9-test.apk`. Java17 ve Godot4.6.3 Android debug şablonu .tools altında, SDK mevcut kullanıcı Android/Sdk konumundadır; yollar parametreyle değiştirilebilir. .tools ve debug anahtarı kaynak/oyun paketine alınmaz. Eski Linux betiği farklı ortam içindir.

Paket com.erditaskinn.istanbulkurye.a9test, etiket İstanbul Kurye Test, sürüm0.12.0-a9/code12, arm64, minAPI24/target36, yaklaşık57MiB. Eski telefondaki oyunun imza anahtarı bu bilgisayarda olmadığı için asıl kurulum silinmedi; ayrı test uygulaması ve kayıt kopyası kullanıldı. SamsungA50 Android11 üzerinde açılış, dokunma, alımlar, ilçe/albüm kaydırma, geri tuşu, arka plan ve kullanıcıyla kilit dönüşü kontrol edildi. Son kaynak kayıt yedeği birebir aynı kaldı. 123sn arka planın302₺ kazancı bağımsız motor tekrarıyla eşleşti; 18 test geçti. Sonuç ve sınırlar `docs/a9-uygulama-raporu.md` içinde.

Sonraki iş kullanıcının serbest oyun denemesi ve geri bildirime göre rötuş. Bu debug APK mağaza yayını değildir; çoklu cihaz/pil/ısınma ve yayın imzası ayrı değerlendirilir.

## Görsel revizyon V1 / 0.13.0-visual
Büyük tutarlar K/M/B/T gösterir; tam para değerleri hesap ve kayıtta korunur. Basamaklı piksel buton/panel teması, 8 dükkân + 8 apartman simgesi ve piksel HUD ikonları eklendi. Kaynaklar scripts/number_format.gd, scripts/pixel_style.gd ve assets/ui/pixel içindedir. 20 test geçti; tools/capture_polish.gd büyük sayılı kısa/uzun önizlemeleri üretir. Ayrıntılar docs/gorsel-iyilestirme-v1.md.

Güncel APK aynı build/istanbul-kurye-a9-test.apk yolundadır: sürüm0.13.0-visual/code13. Aynı test paketine güncelleme içindir; asıl eski oyundan ayrıdır. Bu görsel sürümün telefon kontrolü henüz yapılmadı, kullanıcı önizleme değerlendirmesi bekleniyor.
