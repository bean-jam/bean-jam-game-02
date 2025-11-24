extends Node
class_name StatsComponent
## The StatsComponent contains all of the stats for each entity it is a child of.


## Adjust the movement speed.
@export var base_move_speed: float = 100.0
## Adjust the attack damage.
@export var base_attack_damage: int = 10
## Adjust the attack cooldown.
@export var base_attack_cooldown: float = 2.0


var move_speed: float
var attack_damage: int
var attack_cooldown: float

# This is ready to add upgrades to weapons later
var modifiers: Array = []


## Calls recalculate every time it loads into a scene.
func _ready() -> void:
	_recalculate()

## This function takes the upgrade modifiers added to the entity and calculates
## the new stats. It requires the upgrades to all include:
## move_speed_mult, attack_damage_mult, attack_cooldown_mult.
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

## Add modifiers to the array and instantly recalculate stats.
## Call stats.add_modifier() on the upgrade pickup or the camp menu
func add_modifier(mod) -> void:
	modifiers.append(mod)
	_recalculate()

## Remove modifiers to the array and instantly recalculate stats
func remove_modifier(mod) -> void:
	modifiers.erase(mod)
	_recalculate()
