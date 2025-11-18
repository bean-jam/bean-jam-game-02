extends Area2D
class_name HitboxComponent

# Hitbox attaches to weapons and attacks to deal damage to entities when 
# it overlaps with a Hurtbox

var damage: int
var source_entity: BaseEntity

# This function is called in each weapon script where it assigns the owner
# and their damage to the hitbox in a perform_attack function.
func setup(source: BaseEntity, base_damage: int) -> void:
	source_entity = source
	damage = base_damage

# Use different collision layers in the inspector to ensure enemies
# don't cause damage to each other. Collision layers have been named so hover 
# over the numbers to see the names.
func _on_area_entered(area: HurtboxComponent) -> void:
	area.take_hit(damage, source_entity)
