"""Original short, soft interface tones. No downloaded samples or external libs."""
import math
from pathlib import Path
import struct
import wave

root = Path(__file__).resolve().parents[1] / 'assets' / 'audio'
root.mkdir(parents=True, exist_ok=True)
rate = 22050
for name, notes, length in [
    ('delivery', [1046.50, 1318.51], .055),
    ('purchase', [523.25, 659.25, 783.99], .055),
    ('unlock', [659.25, 783.99, 1046.50], .085),
]:
    samples = []
    for frequency in notes:
        count = int(rate * length)
        for i in range(count):
            t = i / rate
            envelope = min(1, t / .008) * min(1, (length-t) / .012) * math.exp(-3*t/length)
            value = .22 * envelope * (math.sin(2*math.pi*frequency*t) + .12*math.sin(4*math.pi*frequency*t))
            samples.append(int(max(-1, min(1, value)) * 32767))
        samples.extend([0]*int(rate*.012))
    with wave.open(str(root / f'{name}.wav'), 'wb') as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(rate)
        output.writeframes(struct.pack('<'+'h'*len(samples), *samples))
    print(name, 'seconds=', round(len(samples)/rate,3), 'peak=',round(max(abs(x) for x in samples)/32767,3))
