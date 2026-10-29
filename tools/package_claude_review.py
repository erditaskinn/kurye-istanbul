"""Create an auditable source/art handoff without SDKs, keys or player saves."""
from pathlib import Path
import hashlib
import json
import zipfile

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build' / 'claude-handoff'
OUT.mkdir(parents=True, exist_ok=True)
ZIP = OUT / 'istanbul-kurye-claude-0.18.0.zip'
GUIDE = '''# İstanbul Kurye — Claude inceleme paketi

Güncel sürüm: 0.18.0-pixel-hud / Android code18. Motor: Godot4.6.3, GDScript, Compatibility. Mobil Android, portre480×800 ve uzun ekranlara uyumlu. Paket oluşturma tarihi:2026-10-29.

## Önce bunları oku
1. Bu dosya: güncel durum, sınırlar ve inceleme kapsamı.
2. CLAUDE-PROJE-INCELEME.md: runtime kodları, güncel tasarım ve temel testleri tek metinde içerir. ZIP okunamıyorsa bu Markdown ayrıca yüklenebilir.
3. docs/sirket-modeli-v2.md: güncel mekanik sözleşmesi.
4. docs/idle-arastirma-notlari.md: kullanıcı araştırması ve tasarım hedefleri.
5. docs/gelistirme-plani.md: kronolojik ilerleme; en sondaki kontrol noktaları en günceldir.
6. build/ui-check/company-*.png: mevcut Godot oyunundan ekran görüntüleri.

## Şu an nasıl oynanıyor?
Oyuncu şirketine2–24 karakterlik ad verir ve9 logodan birini seçer.60₺ ve1 gerçek yaya çalışanla başlar. Yaya/bisiklet/motor/araba filoya eklenir. Ayrı kişisel kurye yoktur; çalışanlar otomatik sipariş taşır. Para tamamlanan teslimattan gelir. ₺/sn tahmini ortalamadır; her saniye doğrudan ödeme değildir. Talep ve taşıma kapasitesi gerçek darboğazdır. Otomasyon baştan vardır; tekrar tekrar dokunma veya manuel kurye sürme istenmez.

Alt çubuk: Geliştir(hizmet/prim), Motivasyon(konfor), Şirket(filo/operasyon/ad-logo), Ayarlar. Harita sabittir; kurye simgesi üzerinde hareket etmez. Yedi İstanbul ilçesi, tematik görseller, dokunulabilir konumlar ve albüm bulunur. Çevrim dışı üretim en fazla4saattir. Prestige(itibar/yeni tur) kalıcı güç sağlar. Kayıt şeması7, ekonomi sürümü6; eski kayıttan göç vardır.

## En son değişiklikler ve doğrulama
0.18 üst HUD: kasa/ciro/teslimat/ilçe için ayrı tam panel dokuları ve gerçek Tiny5 piksel font. Oyuncunun adı/logo ve sayıları dinamiktir. Türkçe ÇçĞğİıÖöŞşÜü ve₺ glifleri doğrulandı. Font lisansı assets/fonts/Tiny5-OFL.txt. Alt çubuk dört eşit basılabilir bölüm, onaylı yazısız ikonlar, pirinç ayraçlar ve aktif turkuaz çizgi kullanır. Kaynak varlıkların eski varyantları tarihsel olarak tutuldu; her varlık canlı arayüzde kullanılmıyor.

Güncel tools/test_company.ps1 beş betiği geçti: company_model, company_layout, number_format, save_store, isometric_projection. Büyük sayı sığması ve480×800/1040 yerleşimi kontrol edildi. 0.18 SamsungA50 test paketine veri silmeden yüklendi; kurulum ve sürüm doğrulandı. Bu kurulum sonrası yeni görsel sürümün uzun cihaz performansı/oynanışı ayrıca test edilmiş sayılmaz. Eski A9 performans verileri daha eski sürüme aittir. Eski testler ve A1–A9 raporları tarihsel kişisel kurye kuralları içerebilir; tests/README.md ayrımı açıklar. Yeni ekonomi katsayıları henüz kullanıcı oturumlarıyla tam dengelenmedi.

## İnceleme için önerilen istek
Bu projeyi bir mobil idle oyun olarak incele. Önce mevcut davranışı koddan doğrula. Güçlü tarafları, hataları, UX/görsel tutarsızlıklarını, ekonomi risklerini ve performans/kayıt risklerini dosya referanslarıyla raporla. Bulguları kesin hata, tasarım riski ve öneri olarak ayır. Mevcut otomatik idle döngüsünü ve İstanbul temasını koruyacak uygulanabilir öncelik sırası öner. Kod değişikliği yerine önce inceleme ve yol haritası sun; kullanıcı ayrıca isterse uygula. Eski dokümanların tüm maddelerini güncel mekanik sanma.

## Kaynak haritası
- project.godot, scenes/Main.tscn: proje ve giriş sahnesi.
- scripts/main.gd: oyun akışı, HUD, ekonomi bağları, çevrim dışı süre, kayıt/göç ve Android yaşam döngüsü.
- scripts/company_ui.gd: şirket kurulumu, filo/yatırım çekmeceleri, alt çubuk.
- scripts/economy.gd, dispatch.gd, save_store.gd, number_format.gd ve diğer scripts dosyaları: modüller; tam liste manifestte.
- assets/: tüm oyun haritaları, simgeler, UI ve font lisansı.
- docs/: güncel tasarım, araştırma ve tarihsel uygulama raporları.
- tests/: güncel ve tarihsel testler; önce tests/README.md.
- tools/: geliştirme, test, yakalama ve paketleme araçları.

## Çalıştırma
Godot4.6.3 ile project.godot dosyasını içe aktar, projeyi çalıştır. .godot önbelleği ilk açılışta yeniden oluşur. Harici eklenti/MCP gerekmez. Test betiğinin GodotPath parametresini kendi kurulumuna göre ver. Testler izole APPDATA kullanır; gerçek oyuncu kaydına karşı test çalıştırma.

Android yeniden derleme için yerel Android SDK/JDK17/Godot Android şablonu ve geliştiricinin kendi imzalama ayarı gerekir. export_presets.cfg ve build araçları eski makinenin yollarını içerir; yeni ortamda uyarlanmalıdır. İmzalama anahtarı paylaşılmadığından aynı imzayla mevcut uygulamayı güncelleme bu paketle tek başına mümkün değildir. Android test paket adı com.erditaskinn.istanbulkurye.a9test; asıl eski uygulama ayrıdır. İnceleme için APK gerekli değildir ve boyut nedeniyle eklenmedi.

## Paket dışında kalanlar
.tools(SDK/JDK/anahtarlar), .godot(önbellek), kişisel cihaz kayıtları/yedekleri, adb yetkilendirme dosyaları, derleme günlükleri, APK, orijinal teslimat ZIP'i ve onun kopya projesi. Yerel araç yolları kaynak kodu/dokümanda görünebilir; çalıştırmadan uyarlanmalıdır. Kaynaklar ve sanat dosyaları tamdır; bu paket bir inceleme anlık görüntüsüdür.

DOSYA-MANIFESTI.json her arşiv girdisi için boyut ve SHA256 içerir. ZIP bütünlüğü paketleme sonunda doğrulanır.
'''

files = {}
for folder in ['assets', 'scenes', 'scripts', 'docs', 'tests', 'tools', 'feature_profiles', 'script_templates', 'text_editor_themes']:
    for p in sorted((ROOT / folder).rglob('*')):
        if p.is_file() and '__pycache__' not in p.parts and p.suffix not in ['.pyc', '.pyo']:
            files[p.relative_to(ROOT).as_posix()] = p.read_bytes()
for name in ['project.godot', 'export_presets.cfg', 'README.md', '.gitignore']:
    files[name] = (ROOT / name).read_bytes()
for p in sorted((ROOT / 'build' / 'ui-check').glob('company-*.png')):
    files[p.relative_to(ROOT).as_posix()] = p.read_bytes()
for p in sorted((ROOT / 'build' / 'design-reviews').rglob('*')):
    if p.is_file() and (p.suffix == '.md' or p.name.startswith('header-preview-')):
        files[p.relative_to(ROOT).as_posix()] = p.read_bytes()
# Kept only as design history; live art is already under assets/.
for name in ['nav-icons-v1.png', 'top-hud-v1.png']:
    p = ROOT / 'build' / 'design-reviews' / name
    if p.exists():
        files[p.relative_to(ROOT).as_posix()] = p.read_bytes()

selected = ['project.godot', 'scenes/Main.tscn', 'export_presets.cfg',
            'docs/sirket-modeli-v2.md', 'docs/idle-arastirma-notlari.md',
            'tests/README.md', 'tools/test_company.ps1']
selected += [p.relative_to(ROOT).as_posix() for p in sorted((ROOT / 'scripts').glob('*.gd'))]
selected += ['tests/' + name + '.gd' for name in ['company_model', 'company_layout', 'number_format', 'save_store', 'isometric_projection']]
combined = GUIDE + '\n\n# Güncel tasarım ve kaynak dosyaları\n'
for name in selected:
    body = files[name].decode('utf-8-sig')
    combined += f'\n\n## DOSYA: {name}\n\n~~~~\n{body}\n~~~~\n'
files['CLAUDE-ONCE-OKU.md'] = GUIDE.encode('utf-8')
files['CLAUDE-PROJE-INCELEME.md'] = combined.encode('utf-8')
for name in ['CLAUDE-ONCE-OKU.md', 'CLAUDE-PROJE-INCELEME.md']:
    (OUT / name).write_bytes(files[name])
for name in files:
    assert not any(part in {'.tools', '.godot', 'device-backup', 'device-check'} for part in Path(name).parts), name
    assert Path(name).suffix.lower() not in {'.keystore', '.jks', '.apk', '.pem', '.key'}, name
manifest = {name: {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()} for name, data in files.items()}
files['DOSYA-MANIFESTI.json'] = json.dumps(manifest, ensure_ascii=False, indent=2).encode('utf-8')
with zipfile.ZipFile(ZIP, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
    for name, data in files.items():
        archive.writestr('istanbul-kurye/' + name, data)
with zipfile.ZipFile(ZIP) as archive:
    assert archive.testzip() is None, 'Archive CRC failure'
    for name, info in manifest.items():
        assert hashlib.sha256(archive.read('istanbul-kurye/' + name)).hexdigest() == info['sha256'], name
digest = hashlib.sha256(ZIP.read_bytes()).hexdigest()
(OUT / (ZIP.name + '.sha256')).write_text(digest + '\n', encoding='ascii')
print(json.dumps({'zip': str(ZIP), 'files': len(files), 'MiB': round(ZIP.stat().st_size/1024**2, 2), 'text_bytes': len(files['CLAUDE-PROJE-INCELEME.md']), 'sha256': digest, 'integrity': 'CRC and per-file SHA256 verified'}, ensure_ascii=False))
