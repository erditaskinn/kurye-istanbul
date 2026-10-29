extends SceneTree
func _initialize() -> void:
	var numbers = load("res://scripts/number_format.gd")
	for pair in [[0,"0"],[999,"999"],[1000,"1K"],[1250,"1,25K"],[1000000,"1M"],[2500000000,"2,5B"],[1000000000000,"1T"],[1000000000000000,"1Qa"],[999999,"1M"],[-1250,"-1,25K"]]:
		if numbers.compact(pair[0]) != pair[1]:
			push_error("Compact number mismatch: " + str(pair))
			quit(1)
			return
	assert(numbers.exact(1000000000000) == "1.000.000.000.000")
	assert(numbers.compact(24, 1) == "24,0")
	print("Number format passed: thresholds, rounding carry, Turkish decimals, large values, negative and exact labels")
	quit()
