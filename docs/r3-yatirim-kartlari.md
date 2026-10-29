# R3 — Yatırım katkısı ve kuyruk açıklıkları

Tamamlandı:0.20.0-r3/code20. Ekonomi6/şema7, maliyetler, çarpanlar, gerçek sipariş kabul/ödeme ve prestige koşulları aynı. Yeni denge R4 kapsamındadır.

## Görünen değişiklikler

Geliştir/Motivasyon/Şirket yatırım kartları aynı düzeni kullanır. Her kartta başlık/fiyat, mevcut→sonraki seviye veya çalışan adedi, ücret/hız çarpanı, mevcut→sonraki tahmini ₺/sn ve marjinal katkı yer alır. Ücret/hızın mevcut çarpana göre göreli artışı baz yüzde puanından ayrılır: hizmet7→8 için ×2,75→×3 ve yaklaşık%9,09mevcut ücret artışı. Bu ideal çarpan oranıdır; sipariş başına tam sayı yuvarlaması gerçek ortalama ücret artışını biraz değiştirebilir. Üretim tahmini yuvarlanmış gerçek ücret dağılımından hesaplanır.

Pozitif katkıda bedel/tahmini ek gelir ile yaklaşık geri ödeme gösterilir; dk/sa/gün birimleri kullanılır. Bu yeni işlerin/kuyruk oturduktan sonraki yaklaşık aynı-ilçe/talep hesabıdır, kabul edilmiş işlerin oluşturacağı başlangıç gecikmesini içermez. Ekrandaki not ve bilgi balonları bu sınırı belirtir. Küçük pozitif gelir0,0’a yuvarlanmasın diye iki basamak;0,01altında '<0,01' gösterimi var. Büyük sayılar mevcutK/M/B/T birimleriyle kısalır.

Talep zaten karşılanıyorsa sıfır katkı için sonlu geri ödeme uydurulmaz: 'Talep karşılanıyor • Sürekli gelir katkısı yok.' Çalışan/hız artışı birikmiş kuyruğun geçici olarak daha erken bitmesini sağlayabilir; bu kalıcı sürekli gelir tahminiyle aynı şey değildir. Filo kartları gelecekteki ortalama iş süresini de gösterir; eldeki eski işlerin süresinin değişeceğini vaat etmez.

Ücret/hız yükseltmelerinde 'yeni kabul edilen işlerde geçerli' ve aktif/eski işlerin değişmediği yazılır. Kuyruk varsa sayısıyla '30 eski iş: etki gecikebilir' açıklaması görünür. Yeni kurye bekleyen işleri de alabilir ifadesi ayrı tutulur. İş teklifleri kuyruğa kabul edildiği anda kilitlenmeye devam eder; geriye dönük fiyatlama veya hızlandırma yapılmadı.

Çekmece üstündeki durum satırı talep, kapasite, kuyruk ve 'bu tur karşılanamayan talep' adedini gösterir. Sayaç dispatch.missed verisidir; kesin kayıpTL veya kasadan kesinti olarak sunulmaz. Sayaç tüm mevcut turu kapsar, yalnız ekrandaki ilçenin son dakikasını değil. Yeni turda mevcut dispatch.reset davranışıyla sıfırlanır.

## Yerleşim

Harita,114pxüst alan ve144pxalt alan korundu. Aynı çekmece ve dikey kaydırma kullanılır. Kartlar176pxyükseklik ve en az44pxsatın alma alanıyla daha fazla açıklama taşır; tüm filo/operasyon ve ilçeler düğmesi aşağı kaydırılarak erişilir. Son seviyede satın alma kapalı, 'Tamamlandı' ve mevcut gelir gösterilir. Şirket adı uzunsa kısaltılır. Başlık/çerçeve/ikon tasarımı değiştirilmedi.

## Hesaplama ve doğrulama

main.gd _production_snapshot artık opsiyonel ücret/hız seviyesi önizlemeleri alabilir; gerçek oyun seviyelerini geçici olarak değiştirmeden hesaplar. _investment prim/konfor/operasyonu da kapsar ve before/after döndürür. Varsayılan üretim formülü aynı katsayıları kullanır. UI metinleri CompanyUI içinde; ödemeler/simülasyon bu metinlerden hesaplanmaz.

tools/test_company.ps1 altı betikle geçti. Yeni investment_preview testi:
-7ilçede4çalışan türü+hizmet+prim+konfor+operasyon için56gerçek satın alma; fiyat ve alım sonrası gelir/kapasite önizlemeyle eşleşti.
-Önizleme oyuncu kaydı, RNG veya kabul edilmiş işleri değiştirmedi; gerçek satın alma da eski işleri yeniden fiyatlamadı.
-Talep doygunluğunda filo/hız katkısı0ve geri ödeme tanımsız; UI nedeni gösteriyor.
-Dolu kuyrukta eski iş sayısı/gecikme ve karşılanamayan talebin tur kapsamı görünür.
-Hizmet7.seviye göreli artışı, üst seviye kapalı butonları kontrol edildi.
-480×800/1040, kart sınırları, metin yükseklikleri, kaydırma ve44pxsatın alma alanı doğrulandı.

Gerçek Godot önizlemeleri tools/capture_r3.gd ile izole profilde oluşturuldu: build/ui-check/r3-upgrades.png, r3-fleet.png, r3-operations.png, r3-full-queue.png, r3-service-7.png, r3-demand-cap.png, r3-capped.png, r3-tall.png. Bazılarında yalnız inceleme amacıyla test sermayesi ve doğrudan seviye ayarı vardır; telefon kaydı değildir. Boş/dolu kuyruk, sıfır katkı ve operasyon alt bölümü gözle incelendi. Cihaz kaydı/test parası değiştirilmedi; bu tur telefona yükleme veya cihaz testi yapılmadı.

R3 tamamlandı; kullanıcı görsel/karar okunurluğu kontrolü için DUR. R4 başlamadı: ilk tur hedefi, yatırım rollerinin ayrışması, araba kullanım alanı ve prestige ilçe şartı ölçümlere göre tasarlanacak.
