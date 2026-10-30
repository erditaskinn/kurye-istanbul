# 0.26 — Motivasyon, uzmanlık, dönüş ve başarımlar

30 Ekim 2026. Kullanıcı dört geliştirme maddesinin kesmeden tamamlanmasını ve ardından achievement eklenmesini istedi. Bu kapsam kaynakta tamamlandı; fiziksel telefon USB listesinde boş olduğundan yükleme/telefon performans denetimi yapılamadı. APK0.26.0-progression/code26 hazır; mevcut test imzası/paketi korunur. Kayıt şeması11, ekonomi7.

## 1. Motivasyon ekranı

Yıldız için assets/ui/progression/star.svg, altın/pirinç ve turkuaz paletli piksel simge; bakiye paneli, kalıcı seviye, mevcut→sonraki toplam bonus, mevcut ücrete göre gerçek göreli artış,0–100teslimat çubuğu ve eksik yıldız metni. Çubuk ve alım düğmesi480×800'de başlangıç görünümüne sığar. Örneğin+%40→+%60 mevcut ücrete göre+%14,29'dur; +%20 mevcut kazanç denmez.

## 2. Ölçülen yıldız ekonomisi

Önceki aday: ilk5yıldız, uzmanlıklar15/15/20. Aynı gerçek motorla55tur ölçüldü; motive ilk tur83–93dk,5.tur27–27,5dk. Bu aday korundu: build/progression-candidate-a.json. Bu sonuçlar nedeniyle ilk maliyet10yıldıza çıkarıldı; büyüme1,45, seviye başına20yüzde puan ve20seviye sınırı aynı kaldı. Satın alınmış motivasyon seviyeleri ve bakiye korunur; geriye dönük yıldız tahsilatı yoktur.

Nihai adayda tekrar55tur: dört model×iki tohum×beş tur=40tur, motivasyon almayan Standart iki tohum×beş tur=10tur,10dk-karar aralıklı Ekspres beş tur. Otomatik dengeli politika en fazla30snde3₺yatırımı, uygunsa bir motivasyon alımı; kazanılmış başarımları otomatik toplar. İnsan davranışını temsil ettiği iddia edilmez.

| Koşul | İlk tur dk | İkinci tur dk | Beşinci tur dk |
|---|---:|---:|---:|
| Standart, motivasyon alımı açık |94–100|56–58,5|32,5|
| Mahalle Ağı, motivasyon açık |94–100|54,5–57|32|
| Ekspres Hat, motivasyon açık |94–100|56–58,5|32|
| Dağıtım Merkezi, motivasyon açık |94–100|55,5–58,5|32|
| Standart, motivasyon almayan kontrol |109–115|86–86,5|55,5–56|
| Ekspres,10dk-karar aralığı |150|130|100|

İlk motivasyon alımı normalpolitikada41,5–43dk, seyrek politikada60dk. Bu erken ekip otomasyonuyla karıştırılmaz: otomasyon zaten kuruluştan açıktır. İki normaltohumda ilk tur1,5–2saat tercihine uydu; bir garanti değildir. İlk tur sonunda motivasyon2,5.turda4; seyrek politikada5.tur5seviye. Tüm hakların otomatik alınması insanın ödül ekranını kullanmasına göre daha iyimserdir. Toplam110tur iki adayda ölçüldü; nihai kabul edilen55turdur.

Ham nihai sonuç docs/balance/progression-0.26.json; araç tools/measure_progression.gd, izole APPDATA gerektirir. Önceki ekonomik simülasyon çıktıları üzerine yazılmadı. Bu araç satın alma checkpointlerini Probe ile sayar; motivasyon/başarım/itibar gerçek atomik kayda izoleprofilde yazar. İnsan retention/eğlence ve20seviye sonu dengesi ölçülmedi.

## 3. Uzmanlık

Küçük menü yerine dört kartlık uzmanlık penceresi: Standart, Mahalle, Ekspres, Dağıtım. Kartlarda mevcut filo piksel portreleri ve Standart için yeni kupa simgesi kullanılır. Seçim tur başlatmaz; son itibar onayı korunur. Android geri önce seçim penceresini, sonra itibar onayını kapatır.

Nihai aday rol katsayıları: yaya/bisiklet×1,35; motor×1,35; araba×1,40. Sadece seçilen dalın ilgili rolüne uygulanır, diğer roller aynı kalır. Kendi arasında birleşmez; gerçek/önizleme hızları tek kaynağı kullanır. Mevcut kabul edilmiş işler değişmez. Uzmanlık daha önce seçilmişse yeni kabul edilen işlerde yeni katsayı kullanılır; mevcut hız profilleri aynı kalır.

Ek36gerçek4saat simülasyonu: tek bisiklet/motor/araba, Şile/Kadıköy/Beyoğlu, dört model. Hizmet8/konfor4/operasyon4/itibar2, aynıtohum. Kadıköy/Beyoğlu'nda ilgili dal bisiklette+%34,69–35,48, motorda+%34,82–34,98, arabada+%39,34–39,76gerçek ek ciro sağladı. Şile'de talep karşılandığı için ek kazanç0. Bütün modellerin her filoda güçlü olduğu söylenemez. Karma filo botunda tur süreleri yakın; Mahalle5.tur[4,3,2,2], Dağıtım[3,1,1,3], Standart[4,2,2,3]filolarına yöneldi(4242tohum). Bu strateji farkıdır; insan kararlarının yeterince eğlenceli olduğunun kanıtı değildir.

Araç tools/measure_specialization_profiles.gd; ham docs/balance/specialization-profiles-0.26.json. İlkR7.1taslak katsayıları bu raporla güncellenir.

## 4. Dönüş özeti

Gerçek offline simülasyonun kazandırdığı yıldız farkı return_summary.stars olarak birikir; bakiye farkı yerine simülasyon raporu kullanılır. Toplam kazanç/teslimat yanında kazanılan yıldız ve sonraki yüzlüğe ilerleme görünür. Eski özette stars yoksa0kabul edilir. Önerilerde uygun bakiye varsa kalıcı motivasyonu incele; yoksa alınabilir başarım ödülleri eklenir. Diğer filo/hizmet/ilçe önerileri korunur; bu düğmeler satın almaz veya ödül toplamaz. Önceki R7.2'de yıldız özeti yoktu, bu sürüm ekler.

## 5. Başarımlar

Şirket bölümünden ve motivasyondan erişilen13kalıcı, süre sınırı olmayan hedef. Teslimat10/100/1000/10000; toplamciro1K/100K/1M; albüm3/7; itibar1/5; motivasyon1/5. Ödüller sırasıyla1/2/4/8,2/4/8,2/5,3/8,1/4yıldız; toplam52yıldız, sınırsız tekrarlı çiftlik yok. Kupa simgesi assets/ui/progression/trophy.svg; ilerleme ve alınmış/hazır/kilitli durumu ayrı.

Hak kazanmak otomatik, ödül almak tek düğmeyle isteğe bağlıdır; kaybolan veya günlük giriş isteyen ödül yok. İlerleme/ödülkimlikleri kayıtta; itibar geçişinde korunur; tam reset siler. Başarısız disk yazımı bakiye/ödül durumunu değiştirmez; çift tıklama, yeniden açılış ve yeni tur aynı ödülü tekrar vermez. Bilinmeyen kimlikten ödül alınamaz. Yeni lifetime_deliveries gerçek callback'te artar. Eski kayıtta yalnız mevcut kayıtta bilinen dispatch toplamı başlangıç kabul edilir; bilinmeyen eski turlar için teslimat sayısı uydurulmaz. Eski toplamciro/albüm/itibar/motivasyon hedefleri mevcut gerçek alanlarla hak kazanabilir.

Motivasyon ve başarım atomik kayıtları güncel monoton last_saved_at yazar; başarıdan sonra canlı zaman damgası güncellenir. Böylece eski otomatik checkpoint tarihinden işlenmiş sürenin tekrar ödenmesi önlenir. Reklam veya gerçek para satın alımı eklenmedi.

## Kabul ve sınırlar

12güncel betik geçti: tools/test_company.ps1. Yeni progression.gd ödül kilidi/çift alım/hatalı yazım/restart/prestige/reset/bilinmeyen kimlik/eski şema, offline yıldız ve lifetime, iki oranlı kartlar ve modalgeri sırasını sınar. Motivasyon ve uzmanlık betikleri yeni fiyat/katsayılara göre güncellendi. Mevcut9temel betik korunur. Bir ara toplu koşuda kapanış kaynağı uyarısı çıktı; ayrıntılı tekil tekrar ve nihai12betikte yeniden görülmedi; uyarı filtrelenmedi.

tools/capture_progression.gd dört ekran×iki oran=8gerçekGodotPNG üretir; docs/screenshots/progression-0.26/.480×800görünümleri gözle kontrol edildi; dönüş satır çakışması düzeltildi. Bu görüntüler fiziksel telefon görüntüsü değildir. Kod-nativeSVG simgeler kullanıldı; yeni harici servis/eklenti eklenmedi.

APK0.26.0-progression/code26 aynı testimzasıyla üretildi, imza ve16Khizalama denetimi geçti. TelefonADBcihaz listesi boş olduğu için bu tur yüklenmedi; gerçek Android FPS/PSS/ses/titreşim onayı yapılmadı. GitHub'a otomatik push yapılmadı. İstenen dört kaynak geliştirmesi+başarımlar tamamlandı. Sonraki kullanıcı kontrolü: yeni APK'yı telefonda oynama, ödül/uzmanlık anlaşılabilirliği ve gerçek cihazperformansı; gerekirse bu ölçüme göre küçük revizyonlar.
