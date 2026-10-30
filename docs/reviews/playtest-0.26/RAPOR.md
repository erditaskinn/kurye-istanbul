# İstanbul Kurye 0.26 — sınırlı bağımsız değerlendirme

30 Ekim 2026, yaklaşık15:29–15:34 Europe/Istanbul. Kaynak kodu değiştirilmedi. Gerçek oyuncu kayıtları/telefon kullanılmadı. Rapor ve araçlar yalnız build/playtest/ altında; GitHub'a gönderilmedi.

## Yöntem ve önemli sınırlama

**20–30dakikalık gerçek kullanıcı oynanışı YAPILAMADI.** Oyunun gerçek penceresi ayrıAPPDATA ile açıldı; fakat Windows Computer Use bağlantısı ilk başlatma, tekrar ve oturum sıfırlama sonrası her defasında `trusted Node process exited unexpectedly` hatası verdi. İkinci mevcut CUA aracı da `windows sandbox failed: helper_unknown_error: setup refresh had errors` ile kapandı. Aynı hatada sonsuz tekrar yapılmadı. Benim açtığım test penceresi sonunda kapatıldı.

Bu nedenle aşağıdaki sonuçlar kullanıcı gibi tıklayıp oynanmış test değil; Godot sahne düzeyinde senaryo çağrıları, gerçek renderer ekran görüntüleri, hedefli kaynak okuma ve daha önce üretilmiş denge ölçümlerinin değerlendirmesidir. Projeyi geliştiren aynı sohbet olduğundan bağımsızlık ve ilk kez görme koşulu da sağlanamaz. İlk aşama teknik nedenle engellendikten sonra kod incelemesine geçildi. Oyun eğlencesi, sezgisel ilk kullanım ve gerçek telefondaki dokunma hissi doğrulanmış sayılmamalıdır.

NativeUI için önerilen Sol/Medium modeline geçildiği iddia edilmiyor; model ayarı bu testte araçlarla değiştirilmedi. Alt ajan kullanılmadı.55tur veya mevcut12betik yeniden çalıştırılmadı.

## Yapılan kontroller

- AyrıAPPDATA profillerinde 480×800 ve480×1040 Filo/Geliştir/Motivasyon/Şirket/Başarımlar/rehber gerçek görüntüleri.
- Aktif dokunma alanı boyutu ve dikey etiket taşması taraması. Taranan ekranda dikey metin taşması bulunmadı; bu bütün yatay/scroll/telefon durumlarının kusursuz olduğu anlamına gelmez.
- Ayarlar zaman hesabı: iki dakikalık yokluk zaman damgası enjekte edilerek kontrol ve ayar değişikliği karşılaştırıldı. Gerçek iki dakika beklenmedi.
- Dönüş önerilerinin ileri oyun sentetik profili; rehber metni; normal yeniden açılış.
-10dk simülasyon, yatırım yapılmadan:469₺kasa/22teslimat/0yıldız/8kuyruk. Bu gerçek10dk oynanış değildir.
- Yeniden açılışta şirket adı ve469₺korundu. Başarım/itibar güvenliği önceki12betiklik kanıt kapsamında; bu tur bütün senaryolar tekrar oynanmadı.

Araçlar: audit.gd, supplement.gd. Ham sonuçlar: audit-results.json, supplement-results.json, audit.log. Pencere yakalamaları doğrudan Godot renderer'dan; Windows arayüzünden alınmış görüntüler değildir. Oluşturma ve ana menü görüntüleri mevcut test şirketinin marka düzenleme/menü senaryosudur; sıfırdan ilk ekranmış gibi yorumlanmamalıdır. Dosya isimlerinde tall oran1040olarak düzeltildi.

## Öncelikli10bulgu

### 1 — Yüksek / doğrulanmış hata: Ayarlar süresi kazanca dönüşmeyebiliyor

Adımlar: Şirket üretimdeyken Ayarlar'ı aç; burada bir süre bekle; ses/titreşimi değiştirip geri dön veya Ana Menü→Devam Et yap. Beklenen, ayarlarda durdurulan simülasyon süresinin dönüşte bir kez işlenmesi. Gerçek davranış, `_toggle_sound`, `_toggle_haptics` ve `_back_to_menu` içindeki `_save_game` çağrılarının önce `last_saved_at` değerini şimdiye taşıması; `_close_settings` veya `_start_playing` eski aralığı artık bulamıyor.

Kanıt: audit-results.json `settings_elapsed_with_and_without_toggle`: aynı120snkontrolünde normal kapanış85₺, ses değiştirme sonrası0₺. supplement-results.json: ayarlardan menüye geçip devamda0₺. Kontrol başlangıçta1yaya/tohum4242. Sadece ses değişimi gerçekten yürütüldü; titreşim yolu aynı kod desenine dayanır ve ayrıca fiziksel titreşim testi yapılmadı.

Kaynak: scripts/main.gd:548,556,572,1340civarı `_save_game`, `_close_settings`. Öneri: Duran sürenin hesabını ayar tercihi kaydından ayır; zaman damgasını ilerletmeden önce süreyi tek kez kapat veya ayrı muhasebe checkpoint'i tut. Ses/haptic/menu kombinasyonlarına zaman ilerleten regresyon testi ekle. Hızlı sıfır-süre yaşam döngüsü testleri bu hatayı yakalamamış.

### 2 — Yüksek / doğrulanmış yönlendirme hatası: Rehber eski sekmeleri tarif ediyor

Adımlar: Rehberi aç. Gerçek metin “Şirket bölümünden filonu büyüt… Motivasyon bölümünde konfor yatırımı seç.” Oysa filo Filo'da, Konfor Geliştir'de, Motivasyon yıldızlı kalıcı bonus. Oyuncu metni izleyince aradığı kartı bulamaz.

Kanıt: audit-results.json `guide_copy`, guide-800.png/guide-1040.png. Kaynak scripts/main.gd:2073. Öneri: Beş sekmeli akışa göre metni güncelle; yeniYıldız/başarım/uzmanlık açıklamasını kısa bağlamsal adımlara böl. Uzun zorunlu eğitim ekleme.

### 3 — Orta / doğrulanmış kullanılabilirlik eksikliği: Bazı kontroller44mantıksalpikselin altında

Adımlar: Çekmece, marka ve rehber kapatma kontrollerini incele. Çekmece ×42×38, şirket kurma ×40×38; rehber geri414×32. Bu, projenin önceki44pxdokunma hedefini karşılamıyor. Fiziksel telefonda yanlış dokunma sıklığı ölçülmedi.

Kanıt: audit-results.json `small_targets`, iki ekran oranı. Kaynak company_ui.gd:75,373; main.gd:2054. Öneri: Görsel simgeyi büyütmek zorunda olmadan44×44en az dokunma alanı ve çakışmayan kenar boşluğu ver; taramaya kapatma ve modal düğmeleri de dahil et.

### 4 — Orta / gözlenen kullanılabilirlik riski: Yıldız kazanma yolu ilk Motivasyon görünümünün altında

Adımlar: Yeni şirketle Motivasyon'u aç. Bakiye0, sonraki ödül0/100ve10yıldız gerekli görünür; “100teslimat=1yıldız”, itibar ödülü ve Başarımlar düğmesi ilk kaydırma alanının altındadır. Yeni oyuncunun başarımlardan yıldız alınabileceğini keşfetmesi kaydırmaya bağlı. Kullanıcı deneyindeki anlaşılma oranı ölçülmedi.

Kanıt tab1-800.png/tab1-1040.png. Kaynak company_ui.gd:182–183. Öneri: Bakiye kartında tek satır “Teslimat + Başarımlar” bilgisi ve görünür küçük ödül bağlantısı; uzun açıklama altta kalabilir. Kullanıcının yazısız altbar kararını bozma.

### 5 — Orta / doğrulanmış uç durum: Dönüşün üç önerisinden ikisi aynı ilçe ekranına gidiyor

Adımlar: Açılmış ilçe aktif ilçeden yüksekken, hizmet üst seviyedeyken ve filo talebi karşılıyorken dönüş önerilerini üret. `_return_investments` boşsa önce ilçe başa eklenir, sonra eksik satır doldurmak için tekrar ilçe eklenir. “Açık ilçeleri karşılaştır” ve “İlçe hedefini incele” aynı aksiyondur.

Kanıt audit-results.json `duplicate_return_recommendations`: district/district/guide. Profil sentetik ileri oyun: hizmet50, açılmış6, aktif0,400çalışan; yaygınlık iddiası yoktur. Kaynak main.gd:1783–1803. Öneri: Aksiyon anahtarına göre tekilleştir; kalan yere başarımlar/uzmanlık/gerçekten farklı hedef getir veya iki öneri göster.

### 6 — Orta / doğrulanmış açıklama hatası: Teslimat HUD değeri ile tooltip farklı sayaç

Adımlar: Şirket teslimatlarını tamamla; HUD22gösterirken tooltip0gösterir. Görünenmetin `deliveries+dispatch.completed`, tooltipyalnız`deliveries` üzerinden üretilir. Masaüstünde bilgi tutarsızlığıdır; mobilde tooltiperişimi sınırlı olsa da sayı kapsamını düzeltmek gerekir.

Kanıt supplement-results.json: `delivery_hud_text=22`, `delivery_hud_tooltip=0`, `completed_team=22`. Kaynak scripts/hud_presenter.gd `refresh`. Öneri: Tek etkin teslimat sayacı işlevinden metin ve tam sayı açıklaması üret; tur/toplam kapsamını açıkça tanımla.

### 7 — Orta / tasarım riski: Ana haritada yakın ve uzun vadeli hedef birlikte görünmüyor

Adımlar: Şirketi kur, tüm çekmeceleri kapat. Alt alanda gelir/filo/kuyruk var; sonraki ilçe ciro hedefi ve itibar ilerlemesi sürekli görünmüyor. Yakın hedef için ilçe/geri dönüş ekranının keşfi gerekiyor. Idle bekleyişinde “şimdi neye gidiyorum?” sorusunu zayıflatabilir; oyuncu testiyle doğrulanmalı.

Kanıt ten-minutes-simulated-1040.png; HUD/CompanyUI.activity metni. Öneri: Haritayı daraltmadan mevcut alt bilgi alanında kısa “Beykoz:403/550₺” hedef satırı veya sırayla görünen hedef; uzun vadeli itibar ayrıntısı isteğe bağlı açılır. Kalıcı hareketli kurye önerilmiyor.

### 8 — Orta / denge hipotezi: İlk premium motivasyon kararı geç gelebiliyor

Kaynak mevcut docs/balance/progression-0.26.json; bu tur yeniden55turçalıştırılmadı. İlk motivasyon normalbotta41,5–43dk,10dk-kararpolitikasında60dk. Her seviyenin güçlükalıcıolması bu süreyi açıklayabilir; yeni sekmenin uzun süre yalnız kilitli düğme göstermesi yine de risk. İnsan için kesin süre veya “oyuncu bırakır” sonucu yoktur.

Öneri: Önce kullanıcının yıldız kazanma yolunu gördüğünü test et. Hâlâ gereksiz bekleme varsa tek seferlik küçük eğitim ödülü veya ilk basamağı ayrı ele al; tüm maliyetleri düşürüp ilk-itibar dengesini tekrar bozma. Satın alınmış seviyelerden yıldız geri alma yok.

### 9 — Orta / tasarım riski: Hazır başarımlar ana akışta fark edilmeyebilir

Başarımlar Şirket içinde kaydırma sonrası ve Motivasyon açıklamasının altında. Başarım ekranı dışında altbardaki ilgili ikonda hazır ödül adedi görünmüyor. Dönüş önerisi yalnız uygun olduğunda bağlantı veriyor; canlı oynarken ilk10teslimat ödülü sessizce bekleyebilir. Otomatik ödül verme istenmiş değildir; keşfedilebilirlik problemi hipotezidir.

Kanıt company_ui.gd:211, HUDnavgörselleri, tab2-800.png. Öneri: Şirket ikonunda küçük, kaybolmayan hazır ödül rozeti veya ilk başarımda bir kez kısa bildirim. FOMO, kırmızı aciliyet, sürekli popup ekleme. Bu bulgu4'ten farklı olarak yıldız kazanma açıklamasını değil, **hak edilmiş ödülün görünürlüğünü** ele alır.

### 10 — Düşük / estetik tercih: HUD ve pencere metinlerinin görsel dili ayrışıyor

Üst HUD Tiny5bloklu; panel ve düğmelerde daha yumuşak anti-aliaslı gövde fontu. Piksel ikonlar güçlü, ancak menü başlığı/uzun etiketler rasterHUDile farklı görünür. Bir hata veya okunabilirlikte kanıtlanmış düşüş değildir; görsel bütünlük tercihidir.

Kanıt tab0-800.png, tab4-800.png, main-menu-1040.png. Öneri: Önce yalnız başlık/düğme fontu içiniki örnek hazırla; uzun Türkçe açıklamaların okunurluğunu koru. Tüm metni düşünmeden piksel fonta geçirmek veya onaylı haritayı yeniden üretmek gerekmez.

## Olumlu doğrulananlar

Taranan iki oranda etiketlerin dikey satır yüksekliği taşması yok. Filo kartları mevcut→sonraki geliri ve düşük katkıyı açık gösteriyor. Motivasyon kartı toplam+%20puanile mevcutkazançartışını ayırıyor. Başarım ekranında kilitli ödül düğmesi pasif; bu tur oödülün atomik güvenliği yenidenyürütülmedi. Normalrestartşirketkimliği/kasayı korudu. Kalıcı yıldız/uzmanlık/başarım önceki12testkanıtı vardır; bunlar gerçek kullanıcıoynanışı kanıtı değildir.

## Öncelikli revizyon sırası

1. Önce ayar-zaman hesabı: ses/titreşim/menü kombinasyonlarında tam bir kez ödeme testi.
2. Rehber yönlendirmeleri + HUDsayaç açıklaması + ilçe önerisi tekilleştirme.
3.44pxkapatma alanları; ilk Motivasyon görünümünde kazanım yolu ve başarım hazır bildirimi.
4. Yakın/uzak hedef görünürlüğü; sonra kullanıcıgeribildirimiyle ilkYıldızsüresi.
5. Tipografi için küçük görselkarşılaştırma; toptanyenidengörselleştirme yok.

Tamamlanmayanlar: gerçek20–30dkoynanış, nativeUIodak/tıklama/drag davranışı, sanalklavye, fizikselAndroidgeri, haptik/ses/FPS/PSS, insan eğlencesi. ComputerUsebağlantısı düzeldiğinde bunlar ayrıca yürütülmeli. Bu rapor kaynakdüzeltmesi için onay değildir; kullanıcı istemeden kod değiştirilmedi.
