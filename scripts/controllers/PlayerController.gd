extends Node
class_name PlayerController

@export var entity: BaseEntity

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	entity.move_input = input_vector
