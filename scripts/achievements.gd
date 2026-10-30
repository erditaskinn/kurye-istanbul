extends RefCounted
# Finite, untimed milestones. Rewards can only be collected once per company save.
const ITEMS := [
	["delivery10", "İlk Rotalar", "delivery", 10, 1],
	["delivery100", "Mahallenin Kuryesi", "delivery", 100, 2],
	["delivery1000", "Bin Teslimat", "delivery", 1000, 4],
	["delivery10000", "Şehrin Nabzı", "delivery", 10000, 8],
	["revenue1000", "İlk Kazanç", "revenue", 1000, 2],
	["revenue100000", "Büyüyen Şirket", "revenue", 100000, 4],
	["revenue1000000", "İstanbul Markası", "revenue", 1000000, 8],
	["album3", "Semt Kaşifi", "album", 3, 2],
	["album7", "İstanbul Koleksiyonu", "album", 7, 5],
	["prestige1", "Yeni Bir Başlangıç", "prestige", 1, 3],
	["prestige5", "Köklü Şirket", "prestige", 5, 8],
	["motivation1", "İyi Bir Ekip", "motivation", 1, 1],
	["motivation5", "Ekip Ruhu", "motivation", 5, 4]
]
static func progress(game: Control, item: Array) -> int:
	match str(item[2]):
		"delivery": return game.lifetime_deliveries
		"revenue": return game.total_earned
		"album": return game.album_unlocked.size()
		"prestige": return game.rebirth_count
		"motivation": return game.motivation_level
	return 0
static func available(game: Control) -> int:
	var count := 0
	for item in ITEMS:
		if not game.achievement_claimed.has(item[0]) and progress(game, item) >= int(item[3]): count += 1
	return count
