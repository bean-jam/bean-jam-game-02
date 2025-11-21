extends BaseEnemy
class_name FlyingEnemy
# The flying enemy movement needs to be improved

var target: Node2D

func _ready():
	super()
	# Find the player to move towards
	if target == null:
		target = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	# Move towards the player
	if not target:
		return
	
	var direction: Vector2 = (target.global_position - global_position).normalized()
	move_input = direction
