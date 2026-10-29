extends RefCounted
const UNITS := ["", "K", "M", "B", "T", "Qa", "Qi"]
static func compact(value: float, small_decimals: int = 0) -> String:
	var amount := absf(value)
	var tier := 0
	while amount >= 1000.0 and tier < UNITS.size() - 1:
		amount /= 1000.0
		tier += 1
	if tier == 0 and snappedf(amount, 0.1 if small_decimals > 0 else 1.0) >= 1000.0:
		amount /= 1000.0
		tier = 1
	if tier > 0 and snappedf(amount, 0.01) >= 1000.0 and tier < UNITS.size() - 1:
		amount /= 1000.0
		tier += 1
	var text := ("%.1f" % amount if small_decimals > 0 else "%.0f" % amount) if tier == 0 else "%.2f" % amount
	if tier > 0:
		while text.ends_with("0"): text = text.left(-1)
		if text.ends_with("."): text = text.left(-1)
	return ("-" if value < 0 else "") + text.replace(".", ",") + UNITS[tier]
static func exact(value: int) -> String:
	var digits := str(value).trim_prefix("-")
	var grouped := ""
	for i in digits.length():
		if i > 0 and (digits.length() - i) % 3 == 0: grouped += "."
		grouped += digits[i]
	return ("-" if value < 0 else "") + grouped
