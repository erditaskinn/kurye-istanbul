# Şile yol ve zemin görsel paketi — tasarım önerisi

Konsept sayfası: `assets/concepts/sile-road-ground-concept.png`. Bu sayfa görsel yönü gösterir; doğrudan oyuna alınacak, kusursuz döşenen bir tile atlası değildir. Oyunun yeni yol ağı elde tasarlanmış seyrek ve bağlı çizgiler içerir. Kavşak sprite'larını doğrudan bu çizgilere yerleştirmek, açılı bağlantılarda boşluk ve kırık kenarlar oluşturur. Uygulama sırasında yol gövdesi bağlantı geometrisinden çizilmeli; dokular ve kaldırım kenarları bu geometriye bağlanmalıdır.

## Görsel dil

- Kamera: üstten, ev sprite'larıyla aynı açı. Sert piksel kenarı ve en yakın komşu filtreleme.
- Yol: mavi gri asfalt `#516571`; seyrek açık çizgiler `#e9c67d`; kaldırım/kıyı taşları `#d9c8a7`.
- Zemin: sıkışmış toprak `#b8aa88`, kıyı kumu `#e2cf9e`, açık çayır `#739b5d`, koruluk `#4f7d53`.
- Su: sığ `#348aa0`, derin `#12627f`. Şile haritasında su büyük düz bir blok gibi durmamalı; dalga ve kıyı geçişleri seyrek kullanılmalı.
- Tekrarlanan alanlarda detay yoğunluğu düşük tutulmalı. Öncelik rota ve evlerin okunmasıdır.

## Üretilecek parçalar

| Grup | Parçalar | Oyun içi kullanım |
| --- | --- | --- |
| Zemin | Sıkışmış toprak, kum, açık çim, koyu çim, çiçekli çim, taş meydan | 16×16 döşenen yüzeyler; en az iki varyasyonla tekrar kırılır |
| Su | Derin su, sığ su, küçük dalga, kıyı köpüğü | 16×16 yüzeyler ve kıyı boyunca geometriye bağlı geçiş |
| Yol | Ana asfalt, dar sokak, yol kenarı, kesik orta çizgi | Kurgusal haritanın bağlantıları boyunca çizilir; genişlik yol sınıfına göre değişir |
| Kavşak | T, dört yol, 90° dönüş, yaya geçidi | Yalnızca uygun açılı düğümlerde kullanılır; serbest açılı düğümlerde bağlantı şekli çizilir |
| Detay | Kaldırım kırığı, yol yaması, taş, ot kümesi | Seyrek ve deterministik dağıtılır; navigasyonu örtmez |

## Uygulama sırası

1. Zemin ve su yüzeyleri için oyun ölçüsünde gerçek 16×16 tekrar eden tile'lar üret.
2. Kıyı çizgisini kumdan sığ suya kısa geçişlerle oluştur; mevcut Şile kıyı geometrisini koru.
3. Yol bağlantılarını ortak asfalt ve açık kenar paletiyle çiz. Ana yollar 8 px, yan yollar 3 px mantıksal genişlikte kalır; ileride kamera ölçeğiyle birlikte gözden geçirilir.
4. Kavşak ve yaya geçitlerini sadece uygun noktalara ekle; teslimat rotası ve oyuncu bunların üstünde net görünmeli.
5. Telefonda uzak ve yakın kamera seviyelerinde tekrar, titreşim ve okunaklılığı kontrol et.

## Yeniden üretim promptu

```text
Design an ORIGINAL game-ready visual direction sheet for a 2D top-down pixel-art courier idle game in a fictionalized Şile coastal district near Istanbul. Match small cream-walled, terracotta-roof house sprites. Show separated modular groups for: (A) asphalt main road and narrow lane with pale stone sidewalk edging, straight segments, one curve, a T junction, four-way junction and crosswalk; (B) seamless-looking 16x16-style ground swatches for packed earth, beach sand, meadow grass, dark grove grass, flowered grass and stone square; (C) deep blue sea, shallow teal sea, sparse waves, sand-to-water shoreline; (D) one small assembled coastal street demonstration. Orthographic top-down, roads remain highly legible, sparse texture, large coherent pixel clusters, nearest-neighbor hard edges, flat shading, no gradients or antialiasing. Restrained shared palette: navy #172b3c, asphalt #516571, sidewalk #d9c8a7, sand #e2cf9e, earth #b8aa88, meadow #739b5d, grove #4f7d53, shallow sea #348aa0, deep sea #12627f, marking #e9c67d. No labels, lettering, logos, UI or characters. This is a concept sheet, not a promise of technically seamless production tiles.
```

Harita ve görseller temsili olarak tasarlanmıştır; gerçek Şile yollarının veya malzemelerinin kaydı değildir.
