# A5 — Dönüş özeti ve uygun sonraki karar
28 Ekim 2026. Uygulama tamamlandı; kullanıcı kontrolü bekleniyor.

## Ekran davranışı
Dönüş kartı gerçek hesaplanan süreyi, 4 saat tavanı uygulanmışsa açıklamasını, kurucu ve ekip katkılarını ve ekip teslimat sayısını korur. Para önce kasaya eklenir; kart para toplama zorunluluğu yaratmaz. Üretim kart açıkken sürer.

Yeni bölüm, mevcut kasayı, taşıma/talep darboğazını veya kuyruk erimesini ve talep/kapasite oranını gösterir. Sıradaki ilçe için mevcut tur cirosu ile gerçek eşik birlikte görünür. Son ilçede mevcut yeni tur eşiği gösterilir; A7 prestige değişiklikleri uygulanmadı.

Üç karar satırı vardır. Pozitif katkısı varsa araç, hizmet ve bir çalışan alternatifi gösterilir. Çalışan rolü, mevcut koşullarda tahmini ek gelir / maliyet oranıyla seçilir. Genel sıralama önce karşılanabilir yatırımları, sonra daha kısa tahmini geri ödeme süresini kullanır. Bu model tek ilçedeki dengelenmiş akış içindir; gelecekteki ilçe, kuyruk erimesi veya tüm oyun için en iyi strateji iddiası değildir.

Her yatırım maliyeti, yaklaşık ek ₺/dk ve gerçek eksik tutarı veya satın almaya hazır bilgisini taşır. Kilitli ekip, en üst araç/hizmet ve sıfır katkılı kapasite alımları önerilmez. Örneğin talep 3, kapasite 4 iş/dk ise yeni araç/çalışan yerine hizmet ve bilgi seçenekleri görünür. Uygun yatırım sayısı üçten azsa ilçe hedefi ve rehber satırları eklenir. Bunlar yatırım gibi sunulmaz. Bütün yatırımlar tükenmişse yalnızca iki bilgi seçeneği kalır; sahte üçüncü alım oluşturulmaz.

“İncele” satın almaz. Araç/hizmet için kart kapanır ve alt yatırım kartı işaret edilir; çalışan seçeneği ekip panelini açar. Bilgi seçenekleri bölge paneli veya rehberi açar. Özetin okunması kaydedilir, ek kredi veya otomatik harcama olmaz. Aktif teslimatlar değişmez.

## Hesap ve kayıt sınırları
Kazanç dökümü ayrılık sırasında gerçekleşen gelirden, yatırım önerileri ise dönüşteki güncel durumdan türetilir; birbirlerine karıştırılmaz. Üretim devam ederken mevcut kasa, hedef ve öneriler arayüz yenilemesinde güncellenir. Okunmamış döküm mevcut kayıt alanında korunur; öneriler her açılışta yeniden hesaplanır. Yeni kayıt şeması veya ekonomi katsayısı gerekmedi.

Mevcut 4 saat tavanı her ayrılış için geçerlidir. Okunmamış birden çok ayrılış özeti birikirse toplam gösterilen hesap süresi tek ayrılış tavanından uzun olabilir; açıklama “Her ayrılışta” der. Mevcut ilçe açılma ve %10 prestige davranışı korunur; yeni özellikleri A6/A7 uygular.

## Doğrulama
Altı ilgili test geçti: return_choices, offline_summary, onboarding, map_camera, menu_reset, simulation_clock. Godot konsolundaki SCRIPT ERROR/ERROR satırları hata sayıldı. Testlerde APPDATA geçici dizine yönlendirildi; gerçek oyuncu kaydı kullanılmadı.

Yeni test: yetersiz kasa ve eksik tutar, canlı kasa güncellemesi, kilitli ekip, pozitif çalışan önerisi, talep doygunluğunda sıfır katkılı alımların kaldırılması, en üst yatırım sonrası bilgi seçenekleri, gerçek son ilçe hedefi ve gezinmenin harcama/kredi üretmemesi. Mevcut testler okunmamış özetin yeniden başlatmada korunmasını, gerçek ödeme eşleşmesini, tekrar kredi olmamasını, 4 saat tavanını ve özet arkasında otomasyonu doğrular.

`tools/capture_a5.gd` ile erken dönüş, talep doygunluğu/kuyruk erimesi, 4 saat tavanı ve uzun ekran örnekleri üretildi. `build/ui-check/a5-early.png`, `a5-capped.png`, `a5-demand-limited.png`, `a5-tall.png` gözle incelendi; metinler ve seçenekler sığıyor. Gerçek Android cihaz kontrolü henüz yapılmadı.

## Kullanıcı kontrolü / devam
En az bir dakika ara verip geri dönerek kazanç dökümünü ve “İncele” seçeneklerini kontrol et. Seçeneklerin satın almadan ilgili ekrana götürmesi beklenir. A5 sonunda dur. Açık devam talebinden sonra A6: ilçe açılma/etkinleştirme ayrımı, ilçeler arasında anlamlı seçim ve İstanbul Albümü. A7 prestige, A8 bütünleşik denge, A9 gerçek Android cihaz testi bekliyor.
