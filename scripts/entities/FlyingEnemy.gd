extends BaseEnemy
class_name FlyingEnemy
## FlyingEnemy inherits all base behaviours from BaseEnemy and handles it's 
## own movement

## This is currently only the player in this enemies case
var target: Node2D

## Sets target to player and connects the signals from BaseEntity and BaseEnemy
func _ready():
	super()
	# This behaviour might need changing in the future
	if target == null:
		target = get_tree().get_first_node_in_group("player")


## Gets the direction of the player and updates move_input every frame 
func _process(delta: float) -> void:
	if not target:
		return
	
	var direction: Vector2 = (target.global_position - global_position).normalized()
	move_input = direction
