# Şirket modeli V2 — 0.14.0-company

> Tarihsel V2 sözleşmesi. R4 itibarıyla güncel sayısal/ilerleme sözleşmesi docs/sirket-modeli-v3.md; ekonomi7/şema8. Aşağıdaki eski fiyat/hız/hedefler eski kayıt göçü için korunur, yeni oyun dengesi değildir.
Kullanıcının doğrudan şirket kurma ve dört alt bölüm isteği üzerine uygulanmış ilk oynanabilir sürüm. Yeni akış ve görsel değerlendirme için durulacak; yeni şirket ekonomisinin son dengesi henüz onaylanmadı.

## Yeni temel
Oyuncu kişisel kurye sürmez veya ayrı kişisel araç yükseltmez. Başlangıç menüsünden sonra 2–24 karakter şirket adı ve dokuz piksel amblemden biri seçilir. Ücretsiz kuruluş, 60 ₺ sermaye ve bir gerçek yaya çalışanla başlar. İsim/logo daha sonra Şirket bölümünden değiştirilebilir; yeniden ücretsiz çalışan verilmez. Şirket kimliği yerel kayıtta tutulur; olay günlüğüne şirket adı yazılmaz.

Ana ekranda harita, üst kasa/ciro/teslimat, şirket adı/logo ve küçük filo/gelir özeti bulunur. Alt sıra: Geliştir, Motivasyon, Şirket, Ayarlar. Eski kişisel kurye kartı ve sürekli görünen iki yatırım/ekip düğmesi kaldırıldı. Alt alan 246→144 mantıksal piksele indi. Bölümler alt taraftan tek çekmece olarak açılır; aynı anda bir çekmece vardır. Filo listesi kaydırılır, geri tuşu önce çekmeceyi kapatır. Haritada hareketli kurye yoktur.

## Bölümler
- Geliştir: Hizmet Kalitesi ve Teslimat Primi.
- Motivasyon: Çalışma Konforu. Kalıcı, tur içi yatırım; elle yenilenen sayaç veya sürekli dokunma işi yoktur.
- Şirket: Ad/logo düzenleme, yaya/bisiklet/motor/araba ekleme, Operasyon Merkezi ve ilçeler/albüm bağlantısı.
- Ayarlar: Mevcut menü, birim açıklaması ve onaylı tam sıfırlama.

Filo baştan erişilir; ilk 5 teslimatta ekip açılması kuralı kaldırılmıştır. Her satın alma ilgili çalışan sayısını ve gerçek paralel iş kapasitesini artırır. Talep tamamen karşılanıyorsa daha fazla çalışan anlık sürekli gelir kazandırmayabilir; katkı satırı bunu sıfır gösterir. Oyuncu prim/hizmet veya daha yüksek talebe sahip ilçeyi değerlendirebilir.

## İlk parametreler / hipotez
| Yatırım | Başlangıç bedeli | Etki |
|---|---:|---|
| Ek yaya | 150 ₺ | Ortalama 30 sn iş döngüsüyle ek slot |
| Bisiklet | 300 ₺ | Ortalama 24 sn iş döngüsüyle ek slot |
| Motor | 900 ₺ | Ortalama 15 sn iş döngüsüyle ek slot |
| Araba | 2,4K ₺ | Ortalama 12 sn iş döngüsüyle ek slot |
| Hizmet | 100 × 1,55^seviye | Baz ücret çarpanı 1 + 0,25×seviye; en çok50 |
| Teslimat primi | 120 × 1,6^seviye | Ayrı ücret çarpanı 1 + 0,05×seviye; en çok20 |
| Çalışma konforu | 100 × 1,65^seviye | Hız çarpanı 1 + 0,03×seviye; en çok20 |
| Operasyon merkezi | 300 × 1,7^seviye | Hız çarpanı 1 + 0,05×seviye; en çok20 |

İşe alımlar aynı rolde 1,6 katsayısıyla artar. Ücretsiz kuruluş çalışanı satın alınmış sayılmaz; örneğin bir ücretsiz yaya varken ilk ek yaya hâlâ150 ₺'dir. Süreler Şile'nin normalize ortalama mesafesinde, başlangıç operasyon/konforuyla verilmiştir; gerçek rota değişir.

Gösterilen ₺/sn = min(talep, filo kapasitesi) × ortalama sipariş ücreti /60. Para gerçekte teslimat bitince eklenir; gösterge kesintisiz sabit maaş vaadi değildir. Hizmet/prim yeni kabul edilen iş ücretini, konfor/operasyon yeni iş hız profilini değiştirir. Kuyruk ve aktif işler kendi kilitli teklif/profilini korur. Alt notlar bunu açıklar.

## Korunan mekanikler
K/M/B/T gösterimi ve tam sayı finansal kayıt, ortak olay saati, çevrim dışı4saat tavanı, manuel ilçe etkinleştirme, yedi harita, kalıcı albüm ve İstanbul İtibarı korundu. Yeni tur şirket kimliğini ve albümü tutar; filo tek ücretsiz yayaya, hizmet/prim/konfor/operasyon0'a ve kasa60 ₺'ye döner. Tam sıfırlama şirket kimliğini de temizler.

Önceki A8'in kişisel kurye + ekip üretimine ilişkin süre/denge raporları bu model için sonuç sayılmaz. 220K yeni tur ve ilçe eşikleri ilk referans olarak kaldı; yeni roster/yatırım kararları kullanıcı yapı onayından sonra ayrı uzun denge koşularıyla ölçülmelidir. Yeni katsayılar nihai oyuncu ekonomisi değildir.

## Kayıt geçişi
Şema7, ekonomi6. Önce eski kaydın geçmiş süresi kendi eski motor/bonus/fiyat kurallarıyla kapatılır. Ardından eski kişisel kurye, sahip olduğu araç türünde gerçek bir filo slotuna eklenir; mevcut çalışanlar korunur. Eski aktif kişisel işin rolü/slotu dönüştürülür; kilitli ödemesi ve kalan süresi korunur. Gizli ek kurucu slotu artık talep işlemez. Geçiş bir kez kaydedilir.

Mevcut kasa (verilen test parası dahil), ciro, itibar, ilçe ve albüm korunur. Eski kayıtta şirket adı yoksa bir kez ad/logo istenir. Bu sırada yeni sermaye veya ikinci ücretsiz çalışan verilmez. Brand değişimi de tekrar çalışan üretmez. Yeni Android test paketi aynı kimlik/imzayla güncellenebilir; kullanıcı kaydı bu geliştirme turunda doğrudan değiştirilmedi.

## Kontroller
Güncel kabul koşusu tools/test_company.ps1: company_model, company_layout, number_format, save_store, isometric_projection geçti.

Company_model; ad doğrulama,9 seçenek, ücretsiz tek gerçek çalışan, görünmez kurucu olmaması,4 tip alım, ücret/hız yatırımlarının gerçek tekliflere etkisi, kabul edilmiş iş kilidi, kimlik değişiminde slot çoğalmaması, kayıt/yeniden açma, yeni tur kaydı, büyük/küçük adım eşliği, açık/kapalı üretim eşliği, tekrar dönüşte çift kredi olmaması, mobil duraklama ve ekonomi5'ten tam eski süreyle geçişi kapsar.

Company_layout; iki telefon oranında dört alt düğmeyi,7 ilçedeki16 adet44px dokunma kutusunun sınır/çakışmasını ve AtlasTexture filo portrelerinin kutularına sığmasını doğrular. Kaydırma içeriği mouse_filter=PASS kullanır. Testler geçici APPDATA ile koştu; gerçek oyun kaydı kullanılmadı.

A1–A9 döneminin kişisel kurye/5 teslimat/eski alt yerleşim varsayımlı testleri artık yeni sözleşmeyi tarif etmez. tests/README.md ayrımı açıklar. Geçmiş20 test sonucu bu yeni model için tekrar edilmiş sayılmaz.

Görüntü aracı tools/capture_company.gd. company-create, company-map, company-fleet, company-upgrades, company-motivation, company-tall dosyaları build/ui-check altında. Kuruluş, ana ekran, filo ve motivasyon ekranları gözle incelendi. APK0.14.0-company/code14, build/istanbul-kurye-a9-test.apk. İmza ve hizalama kontrolleri derleme betiğinde yapılır. Bu tur bağlı telefon görünmedi; gerçek klavye/çekmece kullanımı ve bu modelin cihaz kontrolü henüz yapılmadı.

## Sonraki kontrol
Kullanıcı şirket kuruluşunu ve alt çubuk düzenini inceleyecek. Sonra geri bildirim doğrultusunda kimlik/filo görünümü, şirket içi yatırım çeşitleri ve yeni ekonomi dengesi ele alınabilir. Bu ilk şirket sürümü sonunda DUR; yeni sistem/denge veya telefona kurulum otomatik başlamayacak.

Son APK: 59.786.050 bayt, SHA-256 719eeb743cbed1c774322fe34b6f28bd59d04db3f129bb79f04605d14511dd44. Beş güncel test betiği ve son kaynakla derleme geçti; kullanıcı incelemesi bekleniyor.
