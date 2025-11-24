extends Node
class_name HealthComponent
## The HealthComponent is used to add a health property to a scene.
## It has functions to heal and apply damage

# These signals are local to each scene
signal health_changed(new_hp: int, max_hp: int)
signal damaged(amount: int)
signal died

## Max health is the initial health of the entity
@export var max_hp: int = 100
var current_hp: int

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_hp
	emit_signal("health_changed", current_hp, max_hp)

## The apply damage function emits signals for damage and death.
## Damage signal can be used for things like: 
## audio triggers, sprite flashes, damage numbers and camera shake.
func apply_damage(amount: int) -> void:
	current_hp = clamp(current_hp - amount, 0, max_hp)
	emit_signal("damaged", amount)
	emit_signal("health_changed", current_hp, max_hp)
	if current_hp <= 0:
		emit_signal("died")

## A function to heal health when called by a consumable
func heal(amount: int) -> void:
	current_hp = clamp(current_hp + amount, 0, max_hp)
	emit_signal("health_changed", current_hp, max_hp)
