# R7.1 — İtibar sonrası şirket uzmanlığı

Durum: Tasarım tamamlandı; uygulama ve denge testi başlamadı. R7'nin tamamı bitmiş değildir. Bu belge mevcut kaynak incelenerek hazırlanmış özgün tasarım önerisidir; dış oyunlara ilişkin doğrulanmış araştırma sonucu değildir.

## Amaç

Mevcut İstanbul İtibarı her turda +25 yüzde puan kalıcı ücret bonusu veriyor. Tekrar oynanışta şirketin nasıl büyüyeceği konusunda ek karar az. İlk itibardan sonra bir şirket uzmanlığı açılacak. Oyuncu sonraki tur için üç modelden birini seçecek; filo ve ilçe yatırımlarını buna göre yapabilecek.

Şirket adı, dokuz logo, sabit İstanbul haritası, yedi ilçe, kartpostallar, otomatik teslimat ve dört saat çevrim dışı sınırı korunur. Yeni aktif tıklama görevi yoktur. İlk turda uzmanlık etkisi yoktur: mevcut 650K hedef ve ölçülmüş 105–115 dakikalık normal politika sonuçları taban olarak kalır. İnsan oyuncuda aynı süre garanti edilmez.

## Tek kalıcı açılış, tur başına bir seçim

- İlk itibar kazanılınca üç uzmanlığın tamamı kalıcı açılır. Yeni para birimi ve harcanan itibar yoktur; mevcut itibar kazanç bonusu aynen sürer.
- Seçim yeni tur kurulmadan önce itibar ekranında yapılır. Sonuç önizlenir; onayda tur ve uzmanlık tek kayıt işlemiyle yazılır.
- Oyuncu tercih yapmak istemezse Standart Şirket ile devam edebilir; uzmanlık zorunlu değildir.
- Bir sonraki itibar ekranında ücretsiz başka model seçilebilir. Mevcut tur ortasında değişmez. Böylece devam eden işlerin sözleşmesi ve kapasite dengesi tutarlı kalır.
- Seçim yapmak için oyunda bekleme, süreli teklif, günlük seri veya kaçırılabilir ödül yoktur.
- Eski kayıtlar Standart Şirket olarak yüklenir. Daha önce itibar kazanmış oyuncu, mevcut turunu sıfırlamadan o turda devam eder; sıradaki itibarında seçim yapar.

Kalıcı gelişme uzmanlık sisteminin açılması ve mevcut itibarın birikmesidir. İlk sürümde üç dal için ayrıca seviye ağacı eklenmez; önce bu kararın oynanışa etkisi ölçülür.

## Üç model — ilk test katsayıları

Bu sayılar nihai denge değildir; Godot olay motoru ölçümünün başlangıç adaylarıdır. Her tur yalnız bir model etkindir, modeller birbiriyle çarpılmaz.

| Model | Etki | Örnek karar ve sınır |
|---|---|---|
| Mahalle Ağı | Yaya ve bisiklet etkin hızı ×1,15; motor/araba değişmez | Hafif filo ve konforu destekler. Üsküdar gibi bir ilçede talebi karşılayınca ek hız geliri artırmayabilir. |
| Ekspres Hat | Motor etkin hızı ×1,15; diğer roller değişmez | Motor ve operasyon odaklı büyümeyi destekler. Araba veriminin yükseldiği yoğun ilçelerde otomatik olarak en iyi seçim değildir. |
| Dağıtım Merkezi | Araba etkin hızı ×1,20; diğer roller değişmez | Araba ve operasyon yatırımını destekler. Başlangıçtaki tek yaya güçlenmez; fayda için önce araba yatırımı gerekir. |
| Standart Şirket | Ek etki yok | Önceki davranışın korunması ve karşılaştırma tabanı. |

Mahalle Ağı örneği: konfor/operasyon sıfır bisiklet hızı 14 → 16,1. Aynı sabit iş yükünde iş süresi yaklaşık %13 azalır; gelir doğrudan %15 artmış sayılmaz. Talep ve ödeme yuvarlaması gerçek kazancı belirler. Ekspres Hat motoru 23 → 26,45 yapar. Dağıtım Merkezi Şile arabasını 36 × 0,55 = 19,8 → 23,76, Beyoğlu arabasını 48,6 → 58,32 yapar. Mevcut rol/ilçe farkları korunur.

Modeller karşı role ceza vermez; bedeli o tur başka uzmanlıktan yararlanamamaktır. İlk sürümde özel sipariş türleri, ek talep, farklı ücret veya gerçek çoklu paket taşıma eklenmez. Bunlar ayrı mekanikler ve ayrı ölçüm gerektirir.

## Ekran akışı

1. İlk tur Şirket bölümünde küçük kilitli bir Uzmanlık kartı: “İlk İstanbul İtibarı ile açılır”. Haritada yeni kalıcı panel yok.
2. İtibar koşulları tamamlanınca mevcut itibar önizlemesi açılır. Kazanılacak +1 itibar, sıfırlanacaklar ve korunacaklar görünür.
3. “Yeni turun çalışma modeli” alanından dört seçenekli ayrı seçim sayfasına geçilir. Her kartta etkilediği filo, mevcut → yeni örnek kapasite ve talep sınırı açıklaması bulunur. Tek kart seçilidir. 44 pikselden küçük dokunma alanı yoktur.
4. “Bu modelle yeni tur” son onayı itibar, model ve yeni başlangıcı birlikte kaydeder. Geri/iptal mevcut şirkete hiçbir şey yapmaz.
5. Yeni turda Şirket kartı etkin modeli ve sonraki itibarında ücretsiz değiştirilebileceğini gösterir. Yatırım kartları ve tahmini gelir aynı etkin hız hesabını kullanır.
6. Dönüş ekranındaki öneriler mevcut modelin gerçek katkısına göre sıralanır. Gelir sağlamayan alım, uzmanlığa uyuyor diye önceliklendirilmez.

Görsel dil mevcut lacivert/pirinç paneller ve Tiny5 ile sürer. Mahalle için bisiklet/mahalle, ekspres için motor/şimşek, dağıtım için araba/depo teması kullanılabilir. Yeni raster ikon çiziminden önce bir görsel onay turu yapılır; bu aşamada onaylı alt/üst bar görselleri yeniden tasarlanmaz.

## Ekonomi ve kayıt sözleşmesi

- Tek kaynaklı hız hesabı: mevcut şirket rol hızı, ilçe faktörü ve konfor/operasyon hesabından sonra seçili rol katsayısıyla çarpılır. Gerçek sipariş, gelir önizlemesi ve yatırım karşılaştırması aynı işlevi kullanır.
- Mevcut legacy_speed_floor alt sınırı korunur; uzmanlık eski satın alınmış hızı azaltamaz. İlk geçişte eski oyuncuya geriye dönük uzmanlık verilmediğinden mevcut tur kazancı değişmez.
- Kuyruğa kabul edilmiş işler kendi paid ve speed_profile alanlarını korur. Yeni uzmanlık yalnız yeni tur oluşturulduğunda uygulanır; ilk ücretsiz yayanın işi de aynı kaynaktan hız alır.
- Kayıtta sürümlü specialization_id bulunur. Bilinmeyen değer Standart'a güvenle düşer; bilinen kimlikler etiket metniyle eşleştirilmez. Yeni alanı okuyabilen şema sürümü artırılır; eski sürümün yeni kaydı yazması engellenir.
- Yüklemede önce eski ekonomiyle çevrim dışı süre işlenir; ardından yeni alan göçü yapılır. Eski kaydın geçmiş yokluğuna uzmanlık etkisi eklenmez. Göç tek seferlik ve yeniden yüklemede etkisiz olmalıdır.
- İtibar işlemi aday kaydı hazırlar, diske atomik yazma başarılı olunca canlı durumu değiştirir. Hatalı kayıtta eski tur, para, itibar ve RNG aynen kalır.
- Tam oyun sıfırlamada uzmanlık Standart'a döner; normal itibar geçişinde seçilen kimlik korunur. Ses/titreşim tercihleri mevcut kurala göre korunur.

## Test ve kabul kapıları

1. Standart model için yeni/ilerlemiş/eski kayıt profillerinde önceki sürümle deterministik eşlik: para, ciro, siparişler, RNG ve dört saat çevrim dışı sonucu. Duvar saati dışında normalizasyon yapılmaz.
2. Her model × yedi ilçe × dört rol: gerçek hız, iş süresi, yatırım önizlemesi ve kalıcı seçim eşleşir. Sıfır katkı ve tam talep karşılanması dürüst gösterilir.
3. Açık oyun ile parçalı ve tek seferlik dört saat simülasyon aynı sonuçları verir. Çevrim dışı binlerce teslimat efekt kuyruğu oluşturmaz.
4. İlk itibar açılışı, eski itibarlı kayıt, bilinmeyen kimlik, başarısız kayıt, iptal/Android geri ve yeniden başlatma sınanır. Eski 220K mevcut tur hedefi ve hız alt sınırı korunur.
5. Her model için eşit tohum/karar aralığıyla ikinci–beşinci turlar ölçülür; ilk tur Standart tabanı tekrar doğrulanır. Rol alımları, boşa kapasite, gerçek marjinal kazanç ve itibar süreleri raporlanır.
6. Bir model bütün ölçülen durumları belirgin biçimde domine ederse veya modeller aynı alım sırasına yol açarsa katsayıları kabul etmeyiz. En az iki modelin farklı filo/ilçe profillerinde yararlı olduğu gösterilmelidir; bot ölçümü insan eğlencesinin kanıtı sayılmaz.
7. 480×800 ve 480×1040 görüntülerinde Türkçe metinler, büyük sayılar, kaydırma ve seçim/iptal görünümü kontrol edilir. Telefon yüklemesi ve fiziksel ses/titreşim/FPS testi ayrı kaydedilir.

## Uygulama sırası ve kontrol durakları

- **R7.1 / bu aşama:** Mevcut kodu inceleme, bu tasarım ve test sözleşmesi. Runtime/APK değişmez. Kullanıcı incelemesi için dur.
- **R7.2:** Uzmanlık modülü, sürümlü kayıt göçü ve atomik itibar seçimi; mevcut piksel panel bileşenleriyle seçim akışı. Deterministik test ve ekran görüntüleri sun; kullanıcı kontrolü için dur.
- **R7.3:** Çoklu tur denge ölçümü, gerekirse katsayı revizyonu; onaylı özel ikonlar, son cihaz kontrolü ve test APK'sı. Kullanıcı kontrolü için dur.
- **Sonraki ayrı iş:** Yayın kararı verilirse release imzası/AAB ve mağaza hazırlığı. Bu tasarım yayın yetkisi değildir.

R7.2 ve R7.3 için ilk araştırma/kurulum gerekmez. R7.1 sonunda kullanıcı devam demeden uygulamaya başlanmaz. R5 fiziksel cihaz geri bildirim ve R6 cihaz performans doğrulaması hâlâ bekleyen işlerdir.
