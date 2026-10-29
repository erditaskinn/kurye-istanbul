# A7 — İstanbul İtibarı ve güvenli yeni tur
28 Ekim 2026. Uygulama tamamlandı; kullanıcı kontrolü bekleniyor.

## Oyuncunun gördüğü sonuç
İlçe ekranındaki “İstanbul İtibarı • Yeni turu incele” düğmesi koşullar sağlanmadan da önizleme açar. Kendiliğinden reset yoktur. Oyuncu “İşletmemde kal” ile mevcut üretime devam edebilir. Önizleme açıkken teslimatlar sürer; koşul ve istatistikler yenilenir.

Önizleme şunları birlikte gösterir:
- İtibar sayısı önce/sonra ve kalıcı kazanç yüzdesi.
- Aynı Şile başlangıç rotası, yaya kurye ve hizmet 0 için gerçek yuvarlanmış ödeme örneği. İlk tur 15 → 19 ₺; ikinci tur 19 → 23 ₺. Bu, gelişmiş eski işletmenin gelirini yeni küçük işletmeyle karşılaştırma iddiası değildir.
- Yeniden kurulacak kasa, araç, hizmet, ekip, kuyruk ve ilçe erişimi. Eski turun bekleyen/aktif işleri taşınmaz.
- Korunacak toplam ciro, albüm ve görülmüş rehber; mevcut ciro/albüm sayısı gösterilir.
- Yeni turda Şile ve ciro sayılmayan bir defalık 60 ₺ sermaye.
- Kilitliyken gerçek koşul, mevcut tur cirosu ve kalan tutar. Başlat düğmesi koşullar sağlanmadan kullanılamaz.

Ana haritadaki gelir satırında kalıcı itibar bonusu, ilçe panelinde itibar sayısı ve bonus görünür. Mevcut yedi piksel harita ve albüm korunur; bu sistem ekranı için yeni görsel varlık gerekmedi.

## Bonus ve koşullar
Tek katmanlı itibar kullanılır. Tamamlanan her tur +1 itibar verir. Çarpan = 1 + 0,25 × itibar. %0 → %25 → %50; bileşik ×1,25 değildir. Her sonraki tur +25 yüzde puan ekler; önceki toplam gelire göre her seferinde aynı oranda artış vaadi yoktur. Ödeme son aşamada tam ₺'ye yuvarlandığı için tek tek siparişlerde tam %25 artış görülmesi zorunlu değildir.

Yeni tur için etkin ilçenin Beyoğlu olması ve tur cirosunun en az 220.000 ₺ olması gerekir. Bu mevcut eşik A7'de korundu. Sadece toplam ömür boyu ciro veya kasadaki para koşulu sağlamaz. İtibar almak zorunlu değildir; mevcut işletme sınırsız devam edebilir. Önizlemenin erken açılabilmesi yeni tur yetkisi vermez.

## Kayıt işlemi ve hata koruması
Kayıt şeması 5, ekonomi sürümü 4. Yeni tur önce mevcut oyunu değiştirmeyen tam bir kayıt adayı olarak hazırlanır. Aday; +1 itibar, 60 ₺, temiz tur ekonomisi/ilçe erişimi, korunmuş toplam ciro/albüm/rehber, temiz kuyruk ve doğru ücretli tek başlangıç işi ile RNG durumunu içerir. Mevcut SaveStore bu tek tam kaydı geçici dosya/yedek düzeniyle yazar. Yazma başarılı olmadan çalışan oyun sıfırlanmaz.

Yazma başarısızsa mevcut kasa, araç, ekip, kuyruk ve itibar değişmez; oyuncuya işletmenin korunduğu bildirilir. Başarılı kayıttan sonra çalışan oyun yeni duruma geçer. Aynı onayın tekrar çağrılması, yeni tur cirosu sıfır olduğu için tekrar ödül vermez. Okunmamış eski dönüş özeti temizlenir; eski kazanç yeniden kredilendirilmez. Fiziksel cihazda anlık güç kesintisi/depolama arızası denemesi henüz yapılmadı; bu doğrulama A9'a aittir.

## Eski kayıt geçişi
Eski itibar sayısı 1:1 korunur. Ayrılık süresi önce kaydın eski ekonomi sürümündeki +10 yüzde puan kuralıyla hesaplanır; sonra gelecekte kabul edilecek işlerde +25 yüzde puan uygulanır. Kabul edilmiş aktif ve kuyruktaki işler kendi kilitli ücretlerini korur. Geçiş açıklaması eski/yeni bonusu açıkça yazar: örneğin 2 itibar +%20 → +%50. A3 şirket iadesi veya başlangıç sermayesi bu göçte tekrar verilmez. Açıklama onaylandıktan sonra yeniden açılışta tekrarlanmaz.

## Kontrollü ikinci tur karşılaştırması
`tools/measure_a7.gd`: beş eşleşen tohum, aynı hizmet → yaya → bisiklet politikası ve 600 sn simülasyon. İkinci tur, gerçek yeni tur geçişi üzerinden başlatıldı; ilk prestige'e kadar geçen zaman bu deneyde simüle edilmedi. İki durumda da 60 ₺ başlangıç, aynı rota tohumu, aynı fiyatlar ve yalnızca ilk üç yatırım kullanıldı. Alımlar karşılanabildiği anda yapılır; insan okuma/karar süresi dahil değildir.

| Tohum | İlk tur ciro / kasa | +1 itibar turu ciro / kasa | İlk çalışan: ilk / yeni tur |
|---|---|---|---|
| 7 | 707 / 417 ₺ | 902 / 612 ₺ | 289 / 225,5 sn |
| 42 | 683 / 393 ₺ | 912 / 622 ₺ | 321,5 / 246,5 sn |
| 99 | 723 / 433 ₺ | 904 / 614 ₺ | 318,5 / 230 sn |
| 2026 | 707 / 417 ₺ | 899 / 609 ₺ | 326,5 / 237,5 sn |
| 4242 | 692 / 402 ₺ | 869 / 579 ₺ | 232,5 / 207 sn |

İlk yatırım aralığı 67,5–112,5 sn'den 39–76,5 sn'ye geldi; bazı eşleşmelerde ilk yatırım anı aynı kaldı. Kalıcı bonus fiyatları veya kararları kaldırmadan ilerlemeyi rahatlatıyor. Bu sınırlı politika örneği, en iyi strateji veya gerçek kullanıcı tutunması kanıtı değildir.

İlk prestige için tasarımda yazan 12–24 saat üretim / yaklaşık 1–3 gün hedefi bu deneyle doğrulanmadı. 220.000 ₺ eşiği hâlâ başlangıç denemesidir; tüm oyun ekonomisi ve ziyaret sıklığıyla birlikte A8'de ölçülüp değerlendirilecek. A7'nin tamamlanması son denge onayı anlamına gelmez.

## Kontroller
16 farklı test betiği geçti: prestige, district_choice, district_progression, simulation_clock, strategic_economy, return_choices, onboarding, offline_summary, delivery_status, delivery_flow, staff_progression, map_camera, menu_reset, save_store, isometric_projection, progression_ui. Konsoldaki SCRIPT ERROR/ERROR satırları hata sayıldı. Testler ayrı geçici APPDATA ile yapıldı; gerçek oyuncu kaydı kullanılmadı.

Yeni prestige testi: kilitli ve uygun önizleme, iptal, koşulun doğrudan çağrıda da uygulanması, yazma hatası enjekte edildiğinde çalışan oyun/dosya korunması, disk ve canlı başlangıç işinin eşleşmesi, tek ödül, tekrar onay, anında yeniden başlatma, sıfırlanan/korunan alanlar, ikinci turda %50, A6 ayrılığının eski bonusla birebir para hesabı, kilitli işlerin korunması, gelecekteki teklife yeni bonus ve göçün tekrarlanmaması. JSON süreleri 0,0001 sn toleransla, para tam sayı olarak karşılaştırılır.

`tools/capture_a7.gd` ile a7-locked, a7-ready, a7-new-run ve a7-second-tour-tall üretildi. Kilitli/uygun kısa ekran, yeni turun haritası ve ikinci tur uzun önizlemesi gözle incelendi. Düğmeler ve açıklamalar sığıyor; ana haritada +%25 gösteriliyor. Gerçek Android dokunma/performance testi henüz yapılmadı.

## Kullanıcı kontrolü / devam
İlçe ekranından İstanbul İtibarı önizlemesini aç; bonus ve korunacak/sıfırlanacak alanları kontrol et. Koşullara ulaşmadan da inceleyebilirsin; başlatma kilitli kalır. A7 sonunda dur. Açık devam talebinden sonra A8: bütünleşik ekonomi, farklı yatırım/ziyaret stratejileri, ilk ilçe ve prestige süreleri ve denge ayarları. A4 yardımsız anlama denemesi ile A9 gerçek Android cihaz kontrolü hâlâ bekliyor.
