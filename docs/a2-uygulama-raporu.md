# A2 — Ortak sipariş ve zaman hesabı
Tarih: 28 Ekim 2026. Durum: tamamlandı; kullanıcı kontrolü bekleniyor. A3 başlamadı.

## Uygulanan değişiklik
Kurucu ve ekip artık scripts/dispatch.gd içindeki aynı olay saatini, sipariş kuyruğunu ve iş atamasını kullanır. Açık oyun ile çevrim dışı dönüş scripts/main.gd içindeki _advance_simulation üzerinden aynı ödemeleri üretir.

- Alım aşaması için 20 sn ve rotaya/araç rolüne/bölgeye bağlı teslimat süresi kullanılır.
- Süre büyük bir adımın ortasında biterse fazlalık sonraki işe aktarılır; eski 15 sn adımlarındaki zaman kaybı kaldırıldı.
- Atama dönüşümlüdür. Kurucu toplam ekip sayısına yanlışlıkla eklenmez; ekip HUD'u yalnızca çalışanları sayar.
- Siparişin ilçe, mesafe ve ücret teklifleri kabul anında saklanır; süresi atamada kilitlenir. Araç alımı sürmekteki işin süresini/ödemesini değiştirmez.
- Önceki ilçenin kabul edilmiş işi özgün şartlarıyla tamamlanır. Yeni haritadaki simgeler bu eski işe yanlış hedef olarak yanıp sönmez. Bilgi kartı eski işe ait rolü yeni ilçenin noktasına yazmaz.
- Boş kurucu için “Sipariş bekliyor / Yeni siparişler otomatik atanır” gösterilir. Ekip bu sırada çalışmaya devam edebilir.
- Otomatik ilçe geçişi mevcut prototip davranışı olarak devam eder; oyuncunun etkin ilçe seçimi A6'dadır.
- Fiyatlar, talep dizisi, şirket/çalışan alım bedelleri ve ilçe/prestige eşikleri korunmuştur. A3'ün başlangıç sermayesi, hizmet yatırımı ve yeni fiyatları uygulanmadı.

## Üretim farkı
A2, yalnızca aynı sonucu farklı biçimde hesaplayan bir düzenleme değildir. Önceden kurucu, ayrı ve çok hızlı bir hareket döngüsünden bağımsız işler bitiriyor; kapalı oyunda ise 5/7/9/11 ₺/dk sabit tarife alıyordu. Yeni modelde kurucu da çalışanlarla aynı rol hızları ve talep havuzuna bağlıdır.

Eski kurucu hareket hızları 90/145/205/275 idi; yeni ortak servis hesabında araç rolü hızları 4/6,5/10/14 ve 20 sn alım aşaması kullanılıyor. Bu nedenle eski çevrim içi ilerleme ve ilk şirket açılma süresiyle eşitlik vaat edilmez. Fiyatlar eski referans olarak durduğu için bu sürüm nihai ilk-10-dakika dengesi değildir; A3/A4'te ayarlanacak.

### Tekrarlanabilir karşılaştırma
tests/simulation_clock.gd içindeki kontrollü örnek:
- Bölge Şile; talep 1 sipariş/dk.
- 300 birim mesafe ve 42 ₺/teslimat.
- Bir kurucu ve bir yaya çalışan; yeni modelde başlangıçta kabul edilmiş bir kurucu işi.
- Süre 600 sn; işlem/satın alma yapılmıyor.
- Eski çevrim dışı kural: kurucu 50 ₺ sabit + çalışanların eski 15 sn adımlı teslimatları 210 ₺ = **260 ₺**.
- Ortak hesap: 5 kurucu + 4 çalışan teslimatı = **378 ₺**.

Bu örnek genel oyuncu getirisi, evrensel artış oranı veya eski çevrim içi oyunun birebir karşılaştırması değildir. Doğrulanan ana özellik, yeni motorun kendi açık/kapalı yollarının aynı başlangıç durumunda aynı sonucu vermesidir.

## Kayıt ve veri geçişi
- Kayıt şeması 2, ekonomi sürümü 1. Önceki uygulamanın yeni kaydı eski ekonomi sanıp yeniden işlemesi sürüm kontrolüyle engellenir.
- Kabul edilmiş işler, kalan süreler, kuyruk, atama sırası ve rastgele üreticinin durumu korunur. Rastgele durum hassasiyet kaybetmemesi için metin olarak saklanır.
- Eski kaydın son ayrılışı önce eski kuralla bir kez kapatılır. scripts/legacy_dispatch.gd yalnızca bu geçiş ve karşılaştırma testi için tutulur; normal üretimde kullanılmaz.
- Eski kasa/araç/çalışan/yeni tur sayısı silinmez. Eski format kurucunun tam konumunu kaydetmediğinden sadece mevcut sipariş kimliği, ücreti ve alım/taşıma aşaması taşınabilir; olmayan alt-saniye ilerleme geri üretilemez.
- Yeni formatta gerçek kalan iş süresi saklanır.
- Son tüketilmiş zaman geriye gitmez. Tekrar dönüş aynı aralığı tekrar ödemez; saat geri alındığında negatif gelir veya kayıt silme uygulanmaz.
- Yerel saatle kesin hile önleme veya cihazlar arası kayıt birleştirme iddiası yoktur.
- Şirket bedeli telafisi henüz uygulanmadı; şirket giriş kilidi A3/A4'te değiştiğinde göç kuralıyla ele alınacak.

## Doğrulama
Bu A2 çalışmasında 11 farklı test betiğinin kontrolleri geçti:
1. simulation_clock
2. delivery_status
3. map_camera
4. delivery_flow
5. staff_progression
6. progression_ui
7. offline_summary
8. district_progression
9. menu_reset
10. save_store
11. isometric_projection

Ana kontrol: aynı tohum ve başlangıç kaydıyla 600 sn tek adım, 0,1 sn adımlar, düzensiz adımlar ve JSON yeniden başlatma eşdeğerliği. Dört saat, bölge eşiği, kabul edilmiş ücret/bölge kilidi, tekrar ödeme, saat geri alma, eski kayıt geçişi ve sonraki rastgele sipariş dizisi de kontrol edildi.

Duraklamadan dönüşte simulation_clock ile map_camera tekrar çalıştırıldı ve geçti. Konsoldaki SCRIPT ERROR/ERROR çıktıları, çıkış kodu 0 olsa da hata sayıldı. Testler APPDATA geçici dizinlere yönlendirilerek çalıştırıldı; gerçek oyuncu kaydı kullanılmadı.

## Görsel kontrol
tools/capture_a2.gd ile 480×800 gerçek Godot görüntüleri alınıp gözle incelendi:
- a2-pickup.png: paket alımı.
- a2-delivering.png: teslimat aşaması.
- a2-team.png ve a2-company-working.png: çalışan aktif, kurucu ekip toplamına karışmıyor.
- a2-waiting.png: kurucu bekliyor, ekip çalışıyor.
- a2-previous-district.png: önceki bölge uyarısı.
- a2-previous-district-card.png: yeni bölge kartında eski sipariş rolü gösterilmiyor.

Dosyalar build/ui-check altında. Genel alım/teslimat, şirket ve dönüş özeti görüntüleri de incelendi. Harita simgelerinin 480×800 ve 480×1040 testleri geçti.

## Kalan sınırlar ve sonraki aşama
Gerçek Android cihazındaki kilit ekranı/işlem sonlandırma/performans kontrolü A9'da yapılacak. İlk 10 dakika ve yatırım dengesi henüz son hâlini almadı. Kullanıcı kontrolü sonrası A3: gerçek darboğaz göstergeleri, hizmet yatırımı, maliyet eğrileri ve karşılaştırmalı yatırım getirisi. A3'e bu çalışma sırasında geçilmedi.

