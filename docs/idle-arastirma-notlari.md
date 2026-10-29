# Kullanıcının idle oyun araştırması — kaynak notu
Tarih: 28 Ekim 2026. Aşağıdaki metin kullanıcı tarafından sağlanmıştır. Birincil kaynaklarla doğrulanan bölümler ve İstanbul Kurye için önerilen kararlar ayrıca oyun-tasarim-belgesi.md içinde ayrılır. Bu arşiv, bütün örnek oyunların mekaniklerini projeye ekleme kararı değildir.

---

Mobil bir idle oyun tasarlamak veya geliştirmek için aşağıdaki araştırma notlarını temel al. Önce mevcut projeyi incele; proje yoksa benden oyun fikrini, hedef platformu ve geliştirme teknolojisini öğren. Ardından uygulanabilir bir oyun tasarım belgesi, sistem listesi ve geliştirme planı hazırla. Kod yazmamı ayrıca istediğimde bu plana göre uygulamaya geç.

## Temel tasarım ilkesi

Idle oyun döngüsü:
Kaynak üret → Kaynağı topla → Yatırım seç → Üretim biçimi değişsin → Yeni hedef veya darboğaz açılsın.

Oyuncu oyunda değilken ilerleme sürmeli. Geri döndüğünde yalnızca ödül toplamakla kalmamalı; bir sonraki anlamlı kararı verebilmelidir.

## Araştırılan başarılı örnekler

- Idle Miner Tycoon: Üretim hatları, darboğaz yönetimi, yöneticiler, otomasyon, çoklu madenler, çevrim dışı kazanç ve etkinlikler.
- Egg, Inc.: Kümes ve nakliye kapasitesi dengesi, araştırma, çok katmanlı prestige, kupalar, eser toplama ve haftalık ortak görevler.
- AdVenture Capitalist: İşletmeler, yöneticilerle otomasyon, kalıcı güç veren melek yatırımcılar, yeni dünyalar ve süreli etkinlikler.
- Tap Titans 2: Aktif ve otomatik savaş, prestige, eserler, ekipman, beceriler, klan baskınları ve turnuvalar.
- AFK Arena / AFK Journey: Otomatik savaş, çevrim dışı ödül, kahraman koleksiyonu, takım kurma ve sosyal sistemler.
- Cell to Singularity: Keşif, aşamalı içerik açma, farklı simülasyon alanları ve temalı etkinlikler.
- Legend of Mushroom: Otomatik savaş, ekipman çekme, sınıf seçimi, boss ve ittifak sistemleri.

Bunlar kesin bir gelir sıralaması değil; farklı idle alt türlerini temsil eden örneklerdir.

## Tasarlanması gereken sistemler

1. Temel üretim ve kaynak toplama döngüsü
2. Artan yükseltme maliyetleri ve üretim çarpanları
3. Üretim, depolama, taşıma veya savaş gücü gibi gerçek darboğazlar
4. Erken açılan otomasyon
5. Oyuncu yokken çalışan çevrim dışı ilerleme
6. Dönüşte kazanılan kaynakları ve sonraki seçenekleri gösteren ekran
7. Kısa, orta ve uzun vadeli hedefler
8. Yeni mekaniklerin aşamalı açılması
9. Prestige: Bir kısmı sıfırlayıp kalıcı güç kazanma
10. Birbirinden farklı stratejik geliştirmeler
11. Temaya uygun koleksiyon ve keşif
12. İsteğe bağlı etkinlik, sosyal sistem ve canlı içerik
13. Kayıt, zaman hesabı ve cihazlar arası tutarlılık
14. Oyun içi olay ölçümü ve denge ayarları

Ekonomi için başlangıç modeli:
Üretim/saniye = temel üretim × seviye etkisi × yönetici × araştırma × kalıcı bonus
Yükseltme maliyeti = başlangıç maliyeti × büyüme katsayısı ^ mevcut seviye
Çevrim dışı kazanç = üretim/saniye × geçen süre × çevrim dışı verim

Bu formüller örnek taslaktır; katsayıları oyun testiyle belirle.

## Oyuncuyu tutacak tasarım kararları

- İlk dakikalarda yapılan yükseltmeler ekranda görünür bir değişiklik yaratsın.
- İlk otomasyon erken açılsın.
- Her dönüşte 2–3 anlaşılır yatırım seçeneği bulunsun.
- Yakın hedef ve uzak hedef aynı anda görülebilsin.
- Prestige öncesinde oyuncu kazanacağı kalıcı gücü görebilsin.
- Yeni sistemler bir anda yüklenmesin; aşamalı açılsın.
- Etkinlikler ana oyunun aynısı olmasın; küçük bir oynanış farkı getirsin.
- Ara veren oyuncuya kısa özet ve önerilen ilk adım gösterilsin.
- Bildirimler seyrek, somut ve oyuncuya faydalı olsun.
- Reklamlar tercihe bağlı olsun; ödül ve satın alma fiyatı açık gösterilsin.

Oyuncuyu kayıp korkusuyla sürekli girişe zorlama. Sahte geri sayım, yanıltıcı satın alma düğmesi, aşırı teklif penceresi ve angarya gibi günlük görevler kullanma.

## İlk sürüm önceliği

Önce şu küçük ama tamamlanmış döngüyü kur:
- Tek bir güçlü oyun teması
- Bir üretim döngüsü
- Bir gerçek darboğaz
- En az iki yatırım seçeneği
- Erken otomasyon
- Çevrim dışı kazanç
- Dönüş ekranı
- Bir uzun vadeli hedef
- Bir prestige katmanı

Temel döngü eğlenceli ve anlaşılır hâle gelmeden klan, gacha, çok sayıda para birimi veya sezon bileti ekleme.

## Ölçülecek metrikler

- D1, D7 ve D30 geri dönüş oranı
- İlk otomasyona ulaşma oranı
- İlk çevrim dışı dönüş oranı
- İlk prestige oranı ve buna ulaşma süresi
- Oyuncuların takıldığı ilerleme noktaları
- Oturum başına anlamlı karar sayısı
- Etkinlik katılımı
- Reklam sonrası oyunu bırakma oranı

## Beklediğim çıktı

Bana önce şu başlıklarda somut bir plan ver:
1. Oyunun temel fikri ve hedef oyuncusu
2. İlk 10 dakikalık oyuncu deneyimi
3. Temel oyun döngüsü
4. Ekonomi ve ilerleme sistemleri
5. Çevrim dışı ilerleme hesabı
6. Prestige tasarımı
7. Oyuncu tutma yöntemleri
8. İlk sürüm kapsamı
9. Geliştirme sırası
10. Açık tasarım riskleri ve nasıl test edilecekleri

Önerilerini soyut bırakma. Örnek sayılar, ekran akışı ve oyuncunun vereceği kararlarla açıkla. Araştırmadan doğrulanan oyun özellikleriyle kendi tasarım önerilerini birbirinden ayır.

