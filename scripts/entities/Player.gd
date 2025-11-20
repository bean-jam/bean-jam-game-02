extends BaseEntity
class_name Player


func _ready() -> void:
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)

func _on_health_changed(current_hp: int, max_hp: int) -> void:
	print("Player HP:", current_hp, "/", max_hp)
	SignalBus.player_health_changed.emit(current_hp, max_hp)

func _on_died() -> void:
	SignalBus.player_died.emit() 
	# Later: pause game, show game over, etc.

# Handle player specific movement, physics process happens on entity class
func _process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_input = input_vector
