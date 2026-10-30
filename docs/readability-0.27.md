# 0.27 — Oynanış incelemesi düzeltmeleri ve okunabilirlik

30 Ekim 2026. Kullanıcı rapor bulgularının uygulanmasını, yazıların okunaklılaştırılmasını ve Computer Use engelinin açıklanmasını istedi. Ardından bu iş tamamlanınca bilgisayarı yeniden başlatacağını belirtti; bu aşamada Computer Use tekrar denenmedi.

## Uygulananlar

- Ayarlar açıkken geçen süre, ses/titreşim/menü/kritik kayıt öncesinde tek kez simüle edilir. Kritik kayıt zamanı ilerletilmeden önce bu aralık kapanır. Duraklatma kaydı da aynı korumadan yararlanır. Yeni playtest_fixes.gd aynı120snaralığı ses/titreşim/menü/pause ve normaldönüşte eşit kazançla, sonraki sıfırsürede çift ödeme olmadan doğrular.
- Rehber Filo/Geliştir/Motivasyon/Şirket görevlerini doğru tarif eder.
- HUDtamteslimat tooltip'i görünen tur sayacıyla aynı kaynaktan üretilir ve “Bu tur” kapsamı eklenir.
- Dönüşte ilçe önerisi iki defa eklenmez.
- Çekmece ve markakapatma44×44; rehbergeri414×44.
- Motivasyonun ilk görünümünde100teslimat/itibar yıldız oranları ve hazır başarımlara44pxüstü bağlantı vardır.
- Şirketikonunda hazır ödül sayacı; anaaltbilgide sonrakiilçe/itibar cirohedefi, mevcutitibar ve darboğaz görünür. Altbar ikonları yazısız kalır.
- HUDmetninde blokluTiny5 yerine Godot'un yerleşik okunaklı fontu kullanılır. FontVariation ile Tiny5₺yedekglifidir; Türkçeve₺has_char testi geçer. Yeni işletimsistemi fontu kopyalanmadı veya harici font kurulmadı. Üstcaption14ve sayılarençok20ile panel içindekonum korunur. Pikselçerçeve/harita/ikonlar aynı.

İlk motivasyon bekleme süresi raporda dengehipoteziydi;10yıldız/20puan kalıcı model bu aşamada değiştirilmedi. Önce görünür kazanımyolu düzeltildi; gerçekoyuncu incelemesi sonra gerekir. Yeni başarım ödülü/fiyat/uzmanlık katsayısı eklenmedi.

## Doğrulama ve sınırlar

Yeni playtest_fixes yanında önceki12betiğin davranış kontrolleri geçer. **Toplu test kapısı tamamen temiz değil:** game_feedback davranışassertionları geçse de kapanışta aralıklı AudioStreamWAV/AudioStreamPlaybackWAV `unlock.wav`kaynağı uyarısı yeniden görüldü; stricttools/test_company bu ERRORsatırında durur. Ayrıntılılog build/feedback-readability.log. Diğer12betik temiz; kapının durmasından sonrakigeçiş/kayıt/format/projeksiyon betikleri ayrı tamamlandı. Kısa sesmiksörteardown beklemesi sorunu çözmediği için testdeğişikliği geri alındı. Hata filtrelenmedi ve13betiktemizgeçti iddiası yapılmıyor. Bu kapanışkaynağı sorunu ayrıca açık teknik iş olarak kalır.

GerçekGodot2ekranoranıyakalamaları docs/screenshots/readability-0.27/altında.480×800Motivasyon görünümü gözle kontrol edildi. Fizikseloyuncu/telefon/klavye/FPS testi yapılmadı.

APK0.27.0-readability/code27 aynıtestpaketi/imzasıyla üretildi, imza/hizalama kontrolleri geçti. Telefona yüklenmedi, GitHub'a push yapılmadı. Kayıt şema11/ekonomi7; kullanıcı ilerlemesine müdahale yok.

## Computer Use durumu

Önceki testte Windowsarayüzbağlantısı daha@oai/sky importunda `trusted Node process exited unexpectedly`ile kapandı. Tekrar, reset ve alternatifCUA denemesinde `windows sandbox failed: helper_unknown_error: setup refresh had errors`görüldü. Bu oyunçökmesi veya kullanıcıiznininreddi olarak doğrulanmadı; yardımcıçalıştırma/sandboxkurulumkatmanında teknikbaşlatmahatası var. Kesinkökneden bilinmiyor, yenidenbaşlatmanın çözeceği garanti değil.

Kullanıcı bilgisayarı yenidenbaşlatıp “açtım” dediğinde önce hafif ComputerUsebağlantıkontrolü yapılacak. Çalışırsa izoleprofilegerçekarayüzoynanıştesti; çalışmazsa aynıdenemeleri sonsuztekrarlamadan kesin hata ve gözlenebilen ortam bilgisi raporlanacak. Bu belge bekleme/yeni tur kontrolnoktasıdır.
