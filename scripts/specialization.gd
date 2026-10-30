extends RefCounted
const IDS := ["standard", "neighborhood", "express", "distribution"]
const TITLES := ["Standart Şirket", "Mahalle Ağı", "Ekspres Hat", "Dağıtım Merkezi"]
const DETAILS := ["Ek hız vermez. Normal şirket düzeni.", "Yaya ve bisikletliler %35 hızlanır.", "Motorlu kuryeler %35 hızlanır.", "Arabalı kuryeler %40 hızlanır."]

static func valid(value: Variant) -> String:
	return str(value) if str(value) in IDS else "standard"

static func apply(speeds: Array, model: String) -> Array:
	var result := speeds.duplicate()
	for role in 4:
		if (model == "neighborhood" and role < 2) or (model == "express" and role == 2): result[role] *= 1.35
		elif model == "distribution" and role == 3: result[role] *= 1.4
	return result
