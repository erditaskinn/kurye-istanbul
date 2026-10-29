extends RefCounted

# A8 economy. Legacy values remain available for one-time save migration.
const VERSION := 7
const STARTING_CASH := 60
const SPEEDS := [90.0, 145.0, 205.0, 275.0]
const COSTS := [0, 100, 800, 2500]
const COMPANY_COST := 0
const LEGACY_COMPANY_COST := 9000
const STAFF_COSTS := [150, 300, 900, 2400]
const ROLE_SPEED := [10.0, 12.5, 20.0, 25.0]
const COMPANY_ROLE_SPEED := [10.0, 14.0, 23.0, 36.0]
const COMPANY_STAFF_COSTS := [150, 260, 500, 650]
# Effective multi-drop productivity, not literal road speed.
const CAR_DISTRICT_FACTOR := [0.55, 0.60, 0.65, 0.80, 1.0, 1.15, 1.35]
const COMFORT_ROLE_BONUS := [0.06, 0.05, 0.02, 0.01]
const OPERATIONS_ROLE_BONUS := [0.01, 0.02, 0.05, 0.06]
const LEGACY_ROLE_SPEED := [4.0, 6.5, 10.0, 14.0]
const DEMAND_PER_MINUTE := [3.0, 5.0, 7.0, 10.0, 14.0, 20.0, 28.0]
const LEGACY_DEMAND := [1.0, 2.0, 3.0, 5.0, 7.0, 9.0, 12.0]
const REFERENCE_DISTANCE := 300.0
const PICKUP_SHARE := 0.30
const MAX_SERVICE_LEVEL := 50
const OFFLINE_LIMIT_SECONDS := 4 * 60 * 60
const OFFLINE_RATE_PER_MINUTE := [5, 7, 9, 11]
const LEGACY_DISTRICT_THRESHOLDS := [0, 2500, 8000, 22000, 50000, 90000, 140000]
const A6_DISTRICT_THRESHOLDS := [0, 500, 2000, 6500, 18000, 50000, 120000]
const DISTRICT_THRESHOLDS := [0, 550, 2000, 6500, 18000, 50000, 120000]
const DISTRICT_DISTANCE := [300.0, 360.0, 330.0, 345.0, 375.0, 420.0, 450.0]
const LEGACY_REBIRTH_THRESHOLD := 220000
const REBIRTH_THRESHOLD := 650000
const REPUTATION_BONUS := 0.25
const LEGACY_REPUTATION_BONUS := 0.10

static func service_cost(level: int) -> int:
	return int(ceil(100.0 * pow(1.55, clampi(level, 0, MAX_SERVICE_LEVEL))))

static func hire_cost(role: int, count: int, version: int = VERSION) -> int:
	var costs: Array = COMPANY_STAFF_COSTS if version >= 7 else STAFF_COSTS
	return int(ceil(minf(1.0e15, costs[role] * pow(1.60, maxi(0, count))) - 0.0000001))

static func company_speeds(district: int, comfort: int, operations: int, version: int = VERSION, floors: Array = []) -> Array:
	var speeds: Array = (COMPANY_ROLE_SPEED if version >= 7 else ROLE_SPEED).duplicate()
	for role in 4:
		if version >= 7:
			if role == 3: speeds[role] *= CAR_DISTRICT_FACTOR[clampi(district, 0, 6)]
			speeds[role] *= (1.0 + COMFORT_ROLE_BONUS[role] * comfort) * (1.0 + OPERATIONS_ROLE_BONUS[role] * operations)
			if floors.size() == 4: speeds[role] = maxf(float(speeds[role]), float(floors[role]))
		elif version >= 6:
			speeds[role] *= (1.0 + 0.03 * comfort) * (1.0 + 0.05 * operations)
	return speeds

static func service_multiplier(level: int) -> float:
	return 1.0 + 0.25 * clampi(level, 0, MAX_SERVICE_LEVEL)

static func reputation_multiplier(count: int, economy_version: int = VERSION) -> float:
	return 1.0 + maxi(0, count) * (REPUTATION_BONUS if economy_version >= 4 else LEGACY_REPUTATION_BONUS)

static func team_bonus_cost(level: int) -> int:
	return int(ceil(120.0 * pow(1.6, clampi(level, 0, 20))))
static func operations_cost(level: int, version: int = VERSION) -> int:
	return int(ceil((180.0 if version >= 7 else 300.0) * pow(1.6 if version >= 7 else 1.7, clampi(level, 0, 20))))

static func comfort_cost(level: int) -> int:
	return int(ceil(100.0 * pow(1.65, clampi(level, 0, 20))))
