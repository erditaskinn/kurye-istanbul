# Şile evleri: görsel yön ve üretim promptu

## Kaynak sınırı

Şile evleri ve konumları oyun için kurgusal olarak tasarlandı. Bu paket gerçek Şile evlerinin doğrulanmış fotoğraf analizi değildir. Görsel dil sahil kasabası hissi için önerilmiştir.

## Oyun için görsel paket

Konsept sayfası: `assets/concepts/sile-houses-concept.png` (6 ev, şeffaf PNG). Bunlar doğrudan oyuna takılacak 40×40 sprite'lar değildir; ölçek, kamera açısı, piksel temizliği ve her evin ayrı PNG dosyasına çıkarılması gerekir.

Önerilen altı varyant:

1. Tek katlı beyaz sıvalı ev, kiremit çatı.
2. Krem renkli iki katlı ev, ahşap çerçeve ve küçük balkon.
3. Beyaz sahil evi, soluk turkuaz kepenkler.
4. Koyu ahşap kaplamalı kırsal ev.
5. Taş alt katlı, açık renk üst katlı ev.
6. Açık sarı, sade çıkmalı iki katlı ev.

Oyunda her varyant aynı çatı açısını, aynı ışık yönünü ve aynı taban ölçüsünü kullanmalı. Evler yol çizgilerine taşmamalı; Şile merkezde küçük çatı izleri, merkez dışındaki açık alanlarda daha büyük ev sprite'ları kullanılmalı.

## ChatGPT görsel üretme master promptu

```text
Create an ORIGINAL production concept sheet for six fictional low-rise houses for a 2D pixel-art courier idle game set in the coastal town of Şile near Istanbul. This is a stylized game interpretation, not a reproduction of real buildings or a map screenshot.

CAMERA AND SCALE: Orthographic near-top-down 3/4 view used in a top-down city map. Roofs occupy about 70% of each house silhouette. Only a narrow front wall strip is visible at the bottom. All six houses must use exactly the same camera angle, footprint, ground contact point, shadow direction, pixel scale and outline thickness. Each should read clearly when reduced to a 40x40-pixel game sprite.

SIX DISTINCT HOUSES: (1) modest one-story white plaster house with terracotta gable roof; (2) cream two-story house with dark timber trim and a small balcony; (3) white coastal house with muted teal shutters and orange clay-tile roof; (4) rural dark timber-clad cottage with a weathered red-brown roof; (5) house with a pale stone ground floor, cream upper wall and brick-red roof; (6) newer modest two-story pale-yellow house with red roof and simple bay window. Keep architectural details sparse and readable: one chimney, a few windows, simple door, small roof-tile clusters. No names or signage.

STYLE: Crisp hand-placed pixel clusters, hard edges, nearest-neighbor look, limited shared 16-20-color palette. Dark navy outline; warm terracotta roofs; cream and white plaster; muted teal shutters; restrained green plants. Daylight from upper left. Flat pixel shading only. Avoid photorealism, smooth gradients, anti-aliasing, painterly texture, excessive rooftop detail, isometric diamond bases and front-facing house elevations.

LAYOUT AND OUTPUT: Exactly six separate isolated houses in a strict 3-column by 2-row grid. Large transparent gutters around each house. Transparent PNG background with real alpha, no background color, ground, scenery, border, labels, text, logo or extra objects. Keep every sprite fully inside its own cell so it can be cut out cleanly. Prioritize a consistent game-ready silhouette over intricate illustration.
```

## Üretime alma kontrolü

Görsel modelinin çıktı boyutlarına birebir uyması garanti değildir. Konsept onaylandıktan sonra her ev ayrı şeffaf dosyaya çıkarılmalı, ortak 40×40 mantıksal kareye uyarlanmalı, kenar pikselleri temizlenmeli ve oyunun mevcut pixel filtresiyle telefonda kontrol edilmelidir.
