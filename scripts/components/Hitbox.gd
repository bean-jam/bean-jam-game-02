extends Area2D
class_name HitboxComponent
## HitboxComponent attaches to weapons and attacks to deal damage to entities 
## when it overlaps with a HurtboxComponent on another scene. 
## When using Hitboxs and Hurtboxs, ensure you set the collision layers
## in the inspector correctly

## This is calculated in setup()
var damage: int

## This function is called in each weapon script where it assigns the owner
## and their damage to the hitbox in a perform_attack function.
func setup(base_damage: int) -> void:
	damage = base_damage

## This function is called when a Hitbox overlaps with a Hurtbox
## Ensure that the signal is connected correctly in the sidebar
func _on_area_entered(area: HurtboxComponent) -> void:
	area.take_hit(damage)
