extends Node
class_name Hurtbox 

@export var health: Health

# The error means that the Health node in the entity scene hasn't been assigned
# in the inspector. Drag and drop the health node into the health section 
# in the inspector.
func _ready() -> void:
	if health == null:
		push_error("Hurtbox.health is not assigned!")

func take_hit(amount: int, source = null) -> void:
	if health:
		health.apply_damage(amount)
