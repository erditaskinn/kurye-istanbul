# 0.29 — Beş mobil iyileştirme

Kullanıcının seçtiği beş madde uygulandı. Sabit harita, idle döngü, yazısız beşli altbar ve ekonomi katsayıları korunur. Kayıt şema11/ekonomi7; district_tip_seen isteğe bağlı yeni alan olup eski kayıtta false varsayılır.

1. **Güvenli alan:** Android'de DisplayServer.get_display_safe_area ekran pikselinden viewport alanına çevrilir. Kök oyunControl güvenli bölgeye yerleşir. Yan boşlukta480tasarım genişliği korunarak bütünü ölçeklenir; mevcut sabit genişlikli kartlar bölge dışına çıkmaz. Viewport değişince tekrar hesaplanır. Masaüstünün varsayılan yerleşimi değişmez. Altbar/çekmece/kurulum/harita kökle birlikte hareket eder. Çok kısa alanlar ve nativeWindow modal/Android sanal klavye ayrıca fiziksel cihazda sınanmalıdır.

2. **Ödül kilidi:** claim_in_progress işlem başında açılır, ilgili düğme anında kilitlenir; kayıt çağrısında tekrar giriş engellenir. Başarısız kayıt sonrası flag temizlenir ve uygun ödül tekrar alınabilir. Başarılı kayıtta tek-seferlikkimlik kontrolü devam eder. Kilit, güvenilir state/atomikkaydın yerine geçmez; önceki koruma korunur.

3. **İlk ilçe yönlendirmesi:** Beykoz açıldığında normal haritada bir kez “İlçeleri gör / Daha sonra” kartı. Kendiliğinden ilçe değiştirmez, kapanınca tekrar rahatsız etmez, tercih kaydedilir ve itibarda korunur. Tam oyun resetinde yeniden kullanılabilir. Menü, modal, çekmece veya dönüş ekranında gizlenir. Eski kayıtta ilkkez güncelleme sonrasında da gösterilebilir.

4. **Saat/arka plan doğrulaması:** Yeni betik ileri tarihe karşı tekhesapta4saat cap, geriye alışta gelir yokluğu, aynıanresume'de para/yıldız tekrar ödenmemesi ve arka planda sesin durmasını sınar. Dönüşte eski kısa efekt tekrar oynatılmaz; müzik sistemi bulunmadığından müzik sürdürme özelliği uydurulmadı. Date.now/visibilitychange eklenmedi; GodotTime ve uygulama bildirimleri korundu. Sunucu saati eklenmedi; tekrar tekrar ileri tarih ayarlama hilesine tam koruma olduğu iddia edilmez.

5. **Aktif sekme:** Daha açık turkuaz dolgu,4pxüst çizgi ve mevcut alt çizgi birlikte kullanılır. Basılıikon/dokunmageribildirimi sürer; seçiliolmayansekmeden belirgin ayrılır.

## Kanıt

tests/mobile_polish.gd başarısız/reentrantödül, normalçiftalım, ilçeipucu, saat/audio/aktifsekme ve480×800/1040üzerinde dört güvenlialan kombinasyonunu test eder. Güvenlialangeometrisinde0,01piksel tolerans: gerçek kayan noktafarkı0,0001piksel gözlendi; gözle görülür taşma toleransa gizlenmez. Kapıya eklenince14güncelbetik olur.

tools/capture_mobile_polish.gd üç görüntü üretir: docs/screenshots/mobile-polish-0.29/. Normalilk-ilçe ve yanboşlukluFilo görünümü gözle kontrol edildi. Bunlar sentetik görüntülerdir; ilkilçegörselinde açılış durumu test için zorlandı, gerçekoyuncu kaydı kullanılmadı.

APK0.29.0-mobile-polish/code29 aynıtestpaketi/imzasıyla hazırlanır. Fiziksel telefon kurulumu, GitHubpush ve ComputerUseyeniden denemesi bu aşamanın parçası değildir. Nihai toplutest/APKsonucu geliştirmeplanına eklenir. Önceki aralıklı WAVkapanışuyarısı ayrıca izlenir.

Nihai sonuç:14betiklik strictkapı exit0ile tamamen geçti; bu koşuda WAVkapanışuyarısı görülmedi, kalıcı çözüldüğü iddia edilmiyor. APKcode29hazır; imza ve16Khizalama doğrulandı. SHA256 0D95E0A05563B0253E8EFDF803474B370811C66754F93B956FD58F7DD1CD20A3. Telefona kurulmadı. Kullanıcı kontrolü için DUR.
