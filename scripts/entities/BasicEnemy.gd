extends BaseEntity
class_name BasicEnemy
# The BasicEnemy class listens to the signals from it's health component

var target: Node2D  

func _ready() -> void:
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	
	# Find the player to move towards
	if target == null:
		target = get_tree().get_first_node_in_group("player")

func _on_health_changed(current: int, max_hp: int) -> void:
	print("Enemy HP:", current, "/", max_hp)

func _on_died() -> void:
	SignalBus.enemy_died.emit(self)
	queue_free()

func _process(delta: float) -> void:
	if not target:
		return
	
	var direction: Vector2 = (target.global_position - global_position).normalized()
	move_input = direction
	
	if health.current_hp <= 0:
		queue_free()
