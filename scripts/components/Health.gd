extends Node
class_name Health # class_name creates a custom Node

signal damaged(amount: int)
signal died

# Export max health so it can be set in the inspector for each BaseEntity instance
@export var max_hp: int = 100
var current_hp: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_hp


# Take damage function which emits signals for damage and death
# Damage signal can be used for things like: 
# audio triggers, sprite flashes, damage numbers and camera shake
func apply_damage(amount: int) -> void:
	current_hp -= amount
	emit_signal("damaged", amount)
	if current_hp <= 0:
		emit_signal("died")
