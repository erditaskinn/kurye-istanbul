# İstanbul Kurye — güncel inceleme girişi

31 Ekim 2026. **0.31.0-phone-polish / Android versionCode31**. Godot4.6.3, Android portre, Compatibility; kayıt şeması11 / ekonomi7. Eski belgelerdeki “güncel” ifadeleri kendi tarihlerine aittir. Çalışan kod ve0.31 yama notları önceliklidir.

Güncel gerçek telefon ekranları: `docs/screenshots/phone-polish-0.31/`. Görüntülerin sürüm ve test şirketi bağlamı için klasördeki README dosyasını oku.

## Önce oku

1. `docs/phone-polish-0.31.md`: son yama ve sınırlar.
2. `docs/readable-cards-0.30.md`: önceki okunabilirlik yaması.
3. `scripts/main.gd`, `scripts/company_ui.gd`, `scripts/hud_presenter.gd`, `scripts/static_map_view.gd` ve bağlı ekonomi/kayıt/üretim/başarım/uzmanlık modülleri. Gerçek formülleri koddan çıkar.
4. `docs/progression-0.26.md`, `docs/sirket-modeli-v3.md`, `docs/idle-arastirma-notlari.md`: tarihsel tasarım bağlamı; eski katsayıları güncel kabul etme.
5. `docs/balance/`:55 tur ve36 dört-saat profilinin tarihsel ölçümleri.0.31'in ilk motivasyon indirimi sonrasında yeniden ölçülmüş sonuçlar değildir. Önce verileri oku; pahalı simülasyonları gereksiz tekrarlama.
6. `tests/README.md`, `tools/test_company.ps1`:15 güncel test grubu; arşivdekiler eski kişisel kurye/hareketli harita varsayımlarına dayanabilir.

## Korunacak ürün kararları

Sabit İstanbul haritası; hareket ettirilen oyuncu kuryesi yok. Otomatik teslimat ve4 saat çevrim dışı sınırı. Yazısız beşli alt bar: Filo / Geliştir / Ekip Motivasyonu / Şirket / Ayarlar. Şirket adı ve9 logo. Yaya/bisiklet/motor/araba filosu. Daha çok zorunlu tıklama, günlük angarya veya kayıp korkusu çözüm değildir.

İlk motivasyon artık3 yıldız; sonraki maliyet ceil(10×1,45^seviye).100 teslimata1 yıldız, itibara10;13 başarım birer kez yıldız verir. Her motivasyon seviyesi+20 yüzde puan,20 seviye sınırı; kendi içinde bileşik değil. Yıldızlar/seviye itibarda korunur. İtibar başına+25 yüzde puan; güncel yeni tur hedefi650K ve Beyoğlu, eski mevcut turda220K korunabilir. Kabul edilmiş işlerin ücret/hızları sonradan yeniden fiyatlanmaz. Üç uzmanlık ilgili rol hızına35/35/40% ekler. Reklam/gerçek ödeme/bulut henüz yok.

## Doğrulama sınırları

0.30'da gerçek Samsung A50 / Android11 üzerinde ayrı yapay test şirketiyle29 dakika4,7 saniyelik duvar saati oturumu yapıldı. Süre okuma/araç gecikmesi/arka plan/yeniden açılışı da içerir; kesintisiz aktif oyun veya insan kullanıcı araştırması değildir. Şile→Beykoz→Üsküdar, filo/hizmet, ödüller,124 saniye arka planda+387 ₺/10 teslimat ve yeniden açılış incelendi. Öznel sıkıcılık değerlendirmesi gerçek oyuncu tutma verisi değildir.

0.31'de15 test grubu geçti. Kısa fiziksel yama kontrolünde hazır ödüller ilk sırada, çubuktan sürükleme, filo karşılaştırması, sınırlı portre boyutları, HUD/Ayarlar aralıkları ve Şirket→Başarımlar geçişi doğrulandı; son süreçte SCRIPT ERROR/ERROR/FATAL EXCEPTION yok. Kayıt korundu. Yeni0.31 ilk motivasyon/itibar süresi, yeni29 dakikalık oturum, D1/D7/D30, ses/titreşim hissi, FPS/PSS/pil veya farklı cihazlarda geniş test yapılmadı.1,5–2 saat itibar süresi tasarım hedefidir; son indirim sonrası ölçülmüş sonuç sayma.

Önceden aralıklı WAV kapanış uyarısı görüldü; son temiz koşular kalıcı motor çözümü değildir. Sunucu saati yok; üst sınır/geriye alış/tekrar kontrolleri ileri saat manipülasyonuna tam koruma iddiası değildir.

`build/` raporları, günlükleri, özel kayıtlar, SDK/JDK, APK ve imza anahtarları depoda yoktur. Bu yerel dosyaları okumuş gibi davranma. Tarihsel fixture gerektiren araçlar temiz klonda çalışmayabilir. Görsel değerlendirirken gerçekten erişebildiğin görüntülerin sürümünü belirt;0.29 görüntülerini0.31 sanma.

Yalnız inceleme: kodu değiştirme, commit/PR/rapor dosyası oluşturma. Türkçe doğrudan sohbet metni ver. Her önemli bulguda güncel dosya/satır, görüntü/bölge veya çalıştırılmış senaryo kanıtı; oyuncu etkisi, somut öneri ve doğrulama yöntemi ver. Doğrulanmış hata / UX sorunu / denge hipotezi / estetik tercihi ayır. Yapamadığın testi ve erişemediğin içeriği açıkça belirt.
