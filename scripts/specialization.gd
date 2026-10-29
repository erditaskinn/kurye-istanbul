extends RefCounted
const IDS := ["standard", "neighborhood", "express", "distribution"]
const TITLES := ["Standart Şirket", "Mahalle Ağı", "Ekspres Hat", "Dağıtım Merkezi"]
const DETAILS := ["Ek hız bonusu yok; mevcut şirket modeli.", "Yaya ve bisiklet hızı +%15. Diğer roller aynı.", "Motor hızı +%15. Diğer roller aynı.", "Araba hızı +%20. Diğer roller aynı."]

static func valid(value: Variant) -> String:
	return str(value) if str(value) in IDS else "standard"

static func apply(speeds: Array, model: String) -> Array:
	var result := speeds.duplicate()
	for role in 4:
		if (model == "neighborhood" and role < 2) or (model == "express" and role == 2): result[role] *= 1.15
		elif model == "distribution" and role == 3: result[role] *= 1.2
	return result
