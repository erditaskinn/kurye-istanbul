# Filo ve kalıcı motivasyon — 30 Ekim 2026

Kullanıcının istediği yeni düzen uygulandı: Filo / Geliştir / Ekip Motivasyonu / Şirket / Ayarlar. Beş eşit dokunma alanı, ikonlar yazısız; Filo en solda. İç sekme kimlikleri eski kısayolları korumak için 4/0/1/2/3'tür. Yeni filo ekranında yalnız dört çalışan türü; Şirket'te kimlik, operasyon, ilçeler/albüm/uzmanlık. Eski Çalışma Konforu kartı seviyeleri/fiyatı korunarak Geliştir'e taşındı. Bu değişiklik R7.3'ten önce kullanıcı tarafından istenen yeni kapsamdır; R7.3 tamamlanmış değildir.

Kullanıcı iki tercihi açıkça seçti: Motivasyon Yıldızı adı ve otomatik teslimat gelirine güçlü kalıcı yüzde bonus. Bu nedenle ayrı sabit ₺/sn üretimi eklenmedi.

## İlk denge adayı

- Tamamlanan her100 teslimat →1 yıldız. Sayaç canlı/çevrim dışı aynı teslimat callback'inde ilerler; yüzlükten kalan0–99 kaydedilir.
- Başarılı İstanbul İtibarı →10 yıldız. Aday kayda ödül dahil edilir; başarısız yazım veya iptal ödül vermez.
- İlk motivasyon seviyesi5 yıldız; sonraki maliyet ceil(5 ×1,45^mevcut_seviye). ₺ harcanmaz.
- En çok20 seviye. Çarpan 1+0,20×seviye. Seviye1 +%20,2 +%40,20 +%400; kendi içinde bileşik değildir. Hizmet/prim/itibar gibi diğer çarpanlarla çarpılır.
- Etkin bonus kabul anında iş ücretine kilitlenir. Mevcut işlere geriye dönük zam yapılmaz. Tahmini üretim geliri aynı çarpanı kullanır. Kazanç hâlâ teslimat tamamlanınca ödenir; talep/kapasite sınırı sürer.
- Yıldız, motivasyon seviyesi ve kalan teslimat sayacı itibar sonrasında korunur. Tam oyun sıfırlama bunları sıfırlar.
- Eski kayıt alanları yoksa0 başlar; satın alınmış konfor seviyeleri kaybolmaz. Önceki bütün teslimatlara toplu geriye dönük yıldız verilmez. Yüklemedeki yeni hesaplanan yokluk teslimatları normal yıldız üretir.
- Şema10; ekonomi7. Eski uygulama bu yeni şemayı yazamaz. Yeni sürümden sonra eski APK'ya dönmek önerilmez.
- Gerçek para, reklam SDK'sı, sahte video düğmesi veya mağaza ürünü yoktur. İleride satın alınan bakiye eklenecekse cihaz üstü bu kayıt tek başına ödeme doğrulaması değildir; mağaza makbuzu/doğrulama ve satın alınmış bakiyenin sıfırlama/iade kuralları ayrıca tasarlanmalıdır.

Bu değerler insan oynanışıyla ve uzun vadeli tur ekonomisiyle henüz dengelenmedi. Önceki ilk-itibar105–115dk ölçümü motivasyon satın almayan tabana aittir; yeni sistemi satın alan oyuncu için aynı süre iddia edilmez. +%20 mevcut toplam kazanç artışı yalnız0→1 için geçerlidir;1→2 mevcut kazancı yaklaşık%16,67artırır.

## Görsel üretim

imagegen becerisi / built-in image_gen kullanıldı. Referans assets/ui/navigation/nav-icons-v1.png. Yeni görsel assets/ui/navigation/fleet-v1.png; mevcut atlas değiştirilmedi. AtlasTexture bölgesiyle simge gösterilir; ayrı Python görsel düzenlemesi yapılmadı. Basılı durumda mevcut çerçeve/aktif turkuaz çizgi kullanılır.

Üretim istemi: “Generate one new pixel art UI button icon for an Istanbul courier idle mobile game, matching reference image: crisp deliberately blocky pixel clusters, navy blue square bevelled button with stepped brass/gold border, warm cream highlights, teal delivery scooter with small golden parcel on rear rack, small cream delivery van behind scooter, coherent single fleet emblem, instantly readable at 52px. No text, no letters, no numbers. Single centered square button fully visible with 4% outer margin, dark navy flat background. Match reference's ornate restrained gold edges, top-left light and chunky pixels. This is the new FLEET navigation button; do not reproduce wrench, tea, house or gear. Save as project-ready icon.”

## Doğrulama ve durak

tools/test_company.ps1 içindeki11 betik geçti. Yeni tests/motivation.gd yıldızsız alımın reddi, kilometre taşı, başarısız kayıtta bakiye koruması, yalnız yıldızla alım, kilitli işlerin değişmemesi, gerçek ücret, itibar ödülü/kalıcılık, yeniden açılış, üst sınır ve sıfırlamayı sınar. Beşli altbar testi ve Konfor'un yeni yeri güncellendi. Çoklu tur denge, video ve gerçek ödeme testleri yapılmadı.

tools/capture_fleet.gd iki oranda altbar/filo/motivasyon görünümü üretir; build/ui-check/fleet-*.png ve motivation-stars-*.png. 480×800 motivasyon görünümü gözle kontrol edildi. Kaynak uygulandı; bu değişiklik için henüz yeni APK üretilmedi/telefona yüklenmedi, GitHub'a gönderilmedi. Telefon hâlâ0.24.0-r7.2 kullanıyor.

Kullanıcı görsel kontrolü için DUR. Sonraki iş: bu tasarımın kontrolü, ardından motivasyon dahil yeni denge ölçümü ve onay sonrası güncel APK. R7.3 uzmanlık ölçümü de bekleyen kapsamda tutulur.
