extends Node
class_name BasicEnemyController

# Assign the entity to the enemy you want to follow the target
@export var entity: BaseEntity
var target: Node2D   

# Target is the first node in the player group, which is only ever the player
func _ready() -> void:
	if target == null:
		target = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not entity or not target:
		return
	
	var direction: Vector2 = (target.global_position - entity.global_position).normalized()
	entity.move_input = direction
	
	if entity.health.current_hp <= 0:
		queue_free()
