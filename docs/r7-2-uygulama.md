# R7.2 — Uzmanlık uygulaması / 30 Ekim 2026

Kaynak uygulaması tamamlandı. APK yeniden üretilmedi; telefona yükleme veya telefon kaydına müdahale yapılmadı. Mevcut APK 0.23.0-r6'dır. Ekonomi sürümü 7; yeni uzmanlık alanını eski uygulamanın yazmaması için kayıt şeması 9 oldu.

scripts/specialization.gd üç aday rol uzmanlığını ve Standart modeli tek işlevde uygular. Gerçek teklif hızı ve yatırım önizlemesi aynı işlevi kullanır. Ücret, talep, ilk tur, tur hedefi ve mevcut itibar ücret bonusu değişmedi. Kabul edilmiş işlerin hız profilleri değiştirilmez.

İtibar penceresinde MODEL SEÇ düğmesi dört seçenekli bir menü açar. Seçim pencere metninde gösterilir; YENİ TUR son onaydır. Ayrı dört görsel kart yerine mevcut diyalog/menü kullanıldı; özel görsel kartlar/ikonlar bu aşamada yapılmadı. Şirket çekmecesinin alt açıklamasında etkin model veya ilk itibar kilidi görünür. İlk itibar onayında yeni turla birlikte model açılır; mevcut turda değiştirme yoktur. Açılışta mevcut model seçilir, iptal hiçbir ekonomik durumu değiştirmez.

Yeni turun ilk işi dahil aday kayıt seçilen modelle hazırlanır. Disk yazımı başarıya ulaşmadan canlı uzmanlık/itibar değişmez. Eski kayıtta alan yoksa Standart; bilinmeyen kimlik Standart; itibarsız kayıtta model Standard'a zorlanır. Eski yokluk bu nedenle geçmişe dönük yeni bonus kazanmaz. Sıfırlama Standart'a döner. Eski tur 220K hedefi ve hız alt sınırları korunur.

tools/test_company.ps1 artık 10 betik çalıştırır; tamamı geçti. Yeni tests/specialization.gd 4 model × 7 ilçe × 4 rol hız ve teklif matrisi, yan etkisiz aday hazırlama, başarısız/başarılı itibar atomikliği, ilk işin kayıtla eşleşmesi, yeniden açılış, eski şema, sıfırlama ve her modelde 4 saat tek/parçalı simülasyon para/RNG/teslimat eşliğini denetler. Mevcut diğer 9 betik de geçti. R6 donmuş kaynakla tam durum eşliği bu aşamada tekrar çalıştırılmadı; yeni alan nedeniyle doğrudan sözlük eşliği artık uygun değildir.

tools/capture_r7.gd gerçek Godot ile 480×800/1040 itibar görünümü üretir: build/ui-check/r7-prestige-*.png. Dar ekran kontrolünde uzun açıklamalar ve düğme metinleri kısaltıldı. Telefon performansı, fiziksel ses/titreşim, çoklu tur strateji dengesi ve kullanıcı anlaşılabilirliği henüz doğrulanmadı.

Kontrol için DUR. Sıradaki R7.3: çoklu tur model karşılaştırması; gerektiğinde katsayı revizyonu; kullanıcı onaylı özel ikonlar ve test APK'sı/cihaz kontrolü. Bu belge R7.1'in uygulama başlamadı durumunu günceller; bütün R7 tamamlanmış değildir.
