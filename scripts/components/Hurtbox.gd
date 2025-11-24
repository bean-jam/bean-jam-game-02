extends Area2D
class_name HurtboxComponent
## HurtboxComponent attaches to a entity that takes damage to when it overlaps 
## with a HitboxComponent on another scene. 
## When using Hurtboxs and Hitboxs, ensure you set the collision layers
## in the inspector correctly

## Assign a HealthComponent to this Hurtbox
@export var health: HealthComponent

## Checks a HealthComponent has been assigned and throws an error
func _ready() -> void:
	if health == null:
		push_error("Hurtbox.health is not assigned!")

## Call apply_damage on the correct HealthComponent
func take_hit(amount: int) -> void:
	if health:
		health.apply_damage(amount)
