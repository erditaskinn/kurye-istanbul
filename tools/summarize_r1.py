from pathlib import Path
import csv
import json
import statistics

root = Path(__file__).resolve().parents[1]
data = json.loads((root/'build/balance/r1-company-v6.json').read_text(encoding='utf-8'))
io = json.loads((root/'build/balance/r1-io-baseline.json').read_text(encoding='utf-8'))
assert not data['failures'] and not io['failures']
assert len(data['policies']) == 9 and len(data['district_checks']) == 3

def fmt(value):
    return f'{value:.2f}'.rstrip('0').rstrip('.').replace('.', ',')

lines = ['# R1 — Şirket modeli gerçek simülasyon ölçümü',
'', 'Durum: tamamlandı. Ekonomi6 / şema7 / oyun0.18.0. Tarih2026-10-29. Oyun katsayıları, runtime kodları, APK ve telefon kaydı bu aşamada değiştirilmedi.',
'', '## Yöntem ve sınırlar',
'', f"Godot4.6.3 headless, Windows, {data['hardware']}. Gerçek main.gd/dispatch.gd üretim, satın alma, ilçe değiştirme ve prestige fonksiyonları kullanıldı. tools/r1_probe_game.gd yalnız oyuncu kayıt yüklemesini kapatır ve rutin kayıt isteklerini sayar; prestige gerçek commit yapar. Tüm yazılar tools/run_r1.ps1 ile geçici, izole APPDATA altında. Disk gecikmesi ayrı gerçek SaveStore yazmalarıyla ölçüldü.",
'', 'Dört politika × iki tohum(42/4242) × beş tur =40tur; ek olarak10dakikada bir karar veren dengeli politika ile5tur: toplam45tur. Karar penceresinde en fazla3alım. Dengeli politika pozitif katkılılar arasında alınabilir en iyi geri ödemeyi seçer; verim politikası en iyi seçeneğe para biriktirir. Hizmet/prim ve filo/hız tercihleri ilgili skorları1,8 ağırlıklandırır. Bütün politikalar o an açılmış ilçelerden tahmini en yüksek gelirliyi seçer; prestige hazırken son ilçeye geçer. Bunlar oyuncu davranışı veya matematiksel optimum değildir. Erken sürelere karar aralığı kadar gözlem payı eklenir. Tohum sayısı2 olduğu için istatistiksel güven aralığı verilmez.',
'', '## İlerleme süreleri',
'', '| Politika | Karar aralığı | 1. tur | 3. tur | 5. tur |', '|---|---:|---:|---:|---:|']
for policy in ['balanced','roi','service','fleet']:
    rows = [p for p in data['policies'] if p['policy']==policy and p['decision_cadence_seconds']==30]
    cells=[]
    for n in [0,2,4]:
        values=[p['tours'][n]['seconds']/60 for p in rows]
        cells.append(fmt(min(values)) if min(values)==max(values) else fmt(min(values))+'–'+fmt(max(values)))
    name={'balanced':'Dengeli/alınabilir','roi':'Verim için biriktir','service':'Hizmet/prim tercihi','fleet':'Filo/hız tercihi'}[policy]
    lines.append('| '+name+' |30sn| '+' dk | '.join(cells)+' dk |')
slow=data['policies'][-1]
lines.append('| Dengeli/seyrek karar |10dk| '+' dk | '.join(fmt(slow['tours'][i]['seconds']/60) for i in [0,2,4])+' dk |')
active=data['policies'][:8]
lines += ['', 'İlk satın alma30sn politikalarında1,5–3,5dk; ilk10dk tur cirosu407–819₺. İlk Beykoz açılışı8,5–12dk aralığında gözlendi. Seyrek karar örneğinde ilk Beykoz20dk gözleminde açılmıştı. Bu son örnek sadece30sn yerine10dk karar aralığıdır;4saat ara veren bir oyuncu profili değildir.',
'', '**Dış raporla karşılaştırma:** İlk tur89dk tahminiyle aynı büyüklükte, fakat gerçek koşular91–98dk. Beşinci tur40dk tahmini bu politikalarla doğrulanmadı:48–50dk; seyrek karar koşusunda110dk. Bu sayılar tasarım hedefi olarak otomatik kabul edilmez.',
'', '## Yatırım çeşitliliği',
'', '45turda seçilen araba sayısı0. Buna karşılık konfor ve operasyon alındı; “hiç kullanılmıyor” iddiası bu örneklerde doğru değil. Ancak hizmet/filo ağırlıkları çoğunlukla aynı seviyelere ve filo bileşimine yakınsıyor. Dolayısıyla farklı menü başlıkları henüz güçlü strateji farkı yaratmıyor. Bu sonuç arabanın bütün oyuncular için gereksiz olduğunu kanıtlamaz; seçici politikaların bu fiyat/talep düzeninde onu tercih etmediğini gösterir.',
'', 'Başlangıçta tüm alımların tahmini katkısı aynı kaynak durumunda karşılaştırıldı. Gerçek ek gelir, iki klon arasındaki toplam teslimat cirosu farkıdır; alış bedeli düşülmüş net kâr değildir. Klonlara yalnız alımı mümkün kılacak aynı test sermayesi verildi; bunlar doğal ilerleme süreleri değildir.',
'', '| Alım | Tahmini geri ödeme | 10dk gerçek ek ciro, boş kuyruk | 10dk gerçek ek ciro, dolu kuyruk |', '|---|---:|---:|---:|']
start={r['kind']+'_'+str(r['role']):r for r in data['marginal_probes'][0]['offers']}
queued={r['kind']+'_'+str(r['role']):r for r in data['marginal_probes'][-1]['offers']}
names={'worker_0':'Yaya','worker_1':'Bisiklet','worker_2':'Motor','worker_3':'Araba','service_0':'Hizmet','bonus_0':'Prim','comfort_0':'Konfor','operations_0':'Operasyon'}
for key,name in names.items():
    r=start[key]
    lines.append(f"| {name} | {fmt(r['payback_minutes'])}dk | {r['additional_revenue_at_seconds']['600']}₺ | {queued[key]['additional_revenue_at_seconds']['600']}₺ |")
lines += ['', 'Dolu kuyruk profili başlangıç şirketini1saat yatırım yapmadan çalıştırarak oluştu. Hizmet/prim/konfor/operasyonun ilk10dk katkısı0₺: kabul edilmiş30iş eski ücret ve hızlarını tutuyor. Bu alımlar sonsuza kadar etkisiz değil;60dk farkları sırasıyla461/90/39/85₺. Kuyruk boşken bile ilk60sn farkı küçük veya0olabilir. Buna karşılık çalışan eklemek bekleyen eski işleri de daha erken taşıyabilir.',
'', 'Talep doygun(4yaya/Şile) profilde tüm yeni çalışanlar, konfor ve operasyon için tahmini gelir katkısı0;60dk gerçek ek ciro da0. Hizmette7.seviyeden sonraki baz +25puan, mevcut çarpana göre yaklaşık%9,09;20.seviyede yaklaşık%4,17artış. Sabit “+%25” etiketi mevcut gelire%25artış anlamına gelmez.',
'', '## Yedi ilçe ve prestige şartı',
'', 'Verim politikası/tohum4242 için doğal olarak ulaşılan1./3./5.tur filoları yedi ilçede ayrı klonlarla sınandı. Eski işler ilçe değiştirirken korundu; ilk10dk ölçüldü,15dk daha yerleşme sonrası son10dk gelir ölçüldü. Rastgele sipariş mesafeleri yüzünden kısa örnekler tahmini ortalamayla birebir eşleşmez.',
'', '| İlçe | 1.tur sonu gerçek ₺/dk | 3.tur | 5.tur |', '|---|---:|---:|---:|']
district_names=['Şile','Beykoz','Üsküdar','Kadıköy','Beşiktaş','Şişli','Beyoğlu']
for index,name in enumerate(district_names):
    values=[fmt(c['districts'][index]['after_25m_settling_10m_income_per_minute']) for c in data['district_checks']]
    lines.append('| '+name+' | '+' | '.join(values)+' |')
gate=next(p for p in active if p['policy']=='roi' and p['seed']==4242)['tours'][0]
lines += ['', f"İlk tur örneğinde aynı filo için tahmini Beşiktaş geliri{fmt(gate['estimate']['income'])}₺/dk, Beyoğlu{fmt(gate['final_district_income'])}₺/dk: yaklaşık%{fmt(100*gate['income_drop_to_final']/gate['estimate']['income'])}düşüş. Gerçek10dk örneği de Beşiktaş lehine. Aktif son ilçe koşulu yüzünden hazır turu bitirmek için düşük getirili ilçeye geçmek gerekiyor. Bu aşamada şart değiştirilmedi; R4'te 'son ilçe açıldı + tur cirosu' alternatifi değerlendirilmelidir.",
'', '## Dört saat çevrim dışı işlem maliyeti',
'', '| Profil | 3tekrar batch süresi | Gerçek dönüş giriş fonksiyonu | Tamamlanan iş | Karşılanamayan talep |', '|---|---:|---:|---:|---:|']
for b in data['benchmarks']:
    values=b['three_batch_ms']
    name={'new_company':'Yeni şirket/Şile','last_district_understaffed':'Beyoğlu/1yaya','developed_fleet':'Beyoğlu/20çalışan'}[b['profile']]
    lines.append(f"| {name} | {fmt(min(values))}–{fmt(max(values))}ms | {fmt(b['offline_entry_ms'])}ms | {b['ending']['completed']} | {b['ending']['missed']} |")
lines += ['', 'Beyoğlu profilleri sentetik:1yaya veya[8yaya,6bisiklet,4motor,2araba]; gelişmiş profilde hizmet10,prim3,konfor5,operasyon5. Kazanç eşitliği üç tekrarda, tek4saat/30sn parçalı işlemede ve gerçek _apply_offline_income girişinde doğrulandı. Sıfır geçen süreli yeniden dönüş ek ödeme yapmadı. Uzun fonksiyon çağrısında gerçek dünya saati ilerleyebileceği için sıfır süre denetiminde zaman damgasına kısa gelecek sınırı verildi; yeni geçen1sn geliri çift ödeme diye sınıflanmadı.',
'', '**Bu bir Android sonucu değildir.** CPU süreleri masaüstünde headless ölçüldü; GPU/render/kullanıcı etkileşimi/AndroidPSS/pil/sıcaklık kapsam dışı. Bellek alanı JSON’da süreç statik tahsisi olarak vardır; telefon RAM/PSS ölçümü olarak yorumlanmaz. Düşük kapasiteli profil daha az işi kabul ettiğinden gelişmiş filodan daha ucuz hesaplanabilir.6458 karşılanamayan sipariş, kasadan kaybolan6458sipariş ücreti değildir.',
'', '## Kayıt sıklığı tabanı',
'', '| Profil | 5dk kayıt isteği | Tamamlanan iş | Sabit kayıt50yazma ortalaması | p95 |', '|---|---:|---:|---:|---:|']
for r in io['results']:
    lines.append(f"| {r['profile']} | {r['checkpoint_requests']} | {r['completed']} | {fmt(r['real_50_saves_mean_ms'])}ms | {fmt(r['real_50_saves_p95_ms'])}ms |")
lines += ['', 'Normal30sn kayıt teorik olarak5dk’da yaklaşık10kezdir. Gerçek _process(1/30) çağrısı yeni şirkette23, gelişmiş filoda134istek üretti. Aynı karede biten işler birleştirilebildiği için teslimat sayısı ile ek kayıt isteği tam eşit olmak zorunda değildir.50 gerçek SaveStore yazması geçici profil diski üzerinde sabit son durumla ayrı ölçüldü; tüm karelerde disk gecikmesi uygulanmadı. Android flash gecikmesi veya kare takılması bu sayılardan doğrudan çıkarılamaz. En büyük gözlenen tek yazma '+fmt(max(r['real_50_saves_max_ms'] for r in io['results']))+'ms.',
'', '## Sonuç ve sıradaki aşama',
'', 'R1 bitti; R2 henüz başlamadı. Sonuçların önceliği:',
'1. Kayıt isteklerini birleştirmek ve rota çiftlerini önbelleğe almak; kritik kayıtları koruyarak önce/sonra kıyaslamak(R2).',
'2. Yatırım kartlarında gerçek marjinal katkı ve kuyruk gecikmesini görünür yapmak(R3).',
'3. Arabanın kullanım alanı, birbirine yakınsayan yükseltme yolları ve aktif Beyoğlu prestige şartını ölçümlü revize etmek(R4).',
'4. Hedef ilk tur süresini kullanıcı tercihiyle belirlemek;91–98dk mevcut davranıştır, doğrulanmış ideal tasarım değildir.',
'', 'Sabit harita kararı korundu; görsel, ses, ekonomi, kayıt sözleşmesi veya APK değişikliği yapılmadı. Telefon kurulumu/testi yapılmadı. Kullanıcı kontrolü için DUR.',
'', '## Tekrar üretme',
'', 'tools/run_r1.ps1: izole APPDATA ve çıktı/log hata denetimi. tools/measure_r1.gd:45tur, marjinal alımlar ve7ilçe. tools/measure_r1_io.gd: kayıt istekleri ve gerçek disk yazması. tools/r1_probe_game.gd: yalnız ölçüm izolasyonu. tools/summarize_r1.py: bu rapor ve CSV.',
'', 'Ham sonuçlar: build/balance/r1-company-v6.json, r1-io-baseline.json. Politikalar ve marjinal örnekler CSV olarak aynı klasörde. Nihai koşu failures=[]; ilk geliştirme koşularındaki betik tür hataları ve sıfır-süre denetimi düzeltildikten sonra nihai koşu baştan tamamlandı. Oyun runtime dosyaları değiştirilmedi.']
(root/'docs/r1-olcum-raporu.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
with (root/'build/balance/r1-tours.csv').open('w',newline='',encoding='utf-8-sig') as f:
    writer=csv.writer(f)
    writer.writerow(['policy','seed','cadence_seconds','tour','tour_minutes','district','income_estimate_per_minute','final_district_estimate','missed','staff','service','bonus','comfort','operations'])
    for p in data['policies']:
        for t in p['tours']:
            writer.writerow([p['policy'],p['seed'],p['decision_cadence_seconds'],t['tour'],t['seconds']/60,t['district'],t['estimate']['income'],t['final_district_income'],t['missed'],str(t['staff']),t['service'],t['bonus'],t['comfort'],t['operations']])
print('R1 report generated:',root/'docs/r1-olcum-raporu.md')
with (root/'build/balance/r1-marginal.csv').open('w',newline='',encoding='utf-8-sig') as f:
    writer=csv.writer(f)
    writer.writerow(['profile','kind','role','cost','estimated_gain_per_minute','estimated_payback_minutes','actual_additional_revenue_60s','actual_additional_revenue_600s','actual_additional_revenue_3600s'])
    for profile in data['marginal_probes']:
        for offer in profile['offers']:
            writer.writerow([profile['profile'],offer['kind'],offer['role'],offer['cost'],offer['gain_per_minute'],offer['payback_minutes']]+[offer['additional_revenue_at_seconds'][str(s)] for s in [60,600,3600]])
