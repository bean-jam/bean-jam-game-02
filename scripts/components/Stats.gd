extends Node
class_name Stats

# Base stats can be adjusted per BaseEntity instance in the inspector
@export var base_move_speed: float = 100.0
@export var base_attack_damage: int = 10
@export var base_attack_cooldown: float = 2.0


var move_speed: float
var attack_damage: int
var attack_cooldown: float

# This is ready to add upgrades to weapons later
var modifiers: Array = []


func _ready() -> void:
	_recalculate()

# This function takes the upgrade modifiers added to the entity and calculates
# the new stats. It requires the upgrades to all include:
# move_speed_mult, attack_damage_mult, attack_cooldown_mult
func _recalculate() -> void:
	var move_speed_mult: float = 1.0
	var attack_damage_mult: float = 1.0
	var attack_cooldown_mult: float = 1.0
	
	for modifier in modifiers:
		move_speed_mult *= modifier.move_speed_mult
		attack_damage_mult *= modifier.attack_damage_mult
		attack_cooldown_mult *= modifier.attack_cooldown_mult
	
	move_speed = base_move_speed * move_speed_mult
	attack_damage = int(round(base_attack_damage * attack_damage_mult))
	attack_cooldown = base_attack_cooldown * attack_cooldown_mult


func add_modifier(mod) -> void:
	modifiers.append(mod)
	_recalculate()

func remove_modifier(mod) -> void:
	modifiers.erase(mod)
	_recalculate()
