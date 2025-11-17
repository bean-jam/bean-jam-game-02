extends CharacterBody2D

const SPEED = 300.0


func _physics_process(delta: float) -> void:

	# A normalised vector in the direction you press
	var input_vector = Input.get_vector("move_left", 
										"move_right", 
										"move_up", 
										"move_down") 
	
	# Multiply that vector by the speed you want to move
	velocity = input_vector * SPEED
	
	# Move and slide multiplies by delta internally
	move_and_slide()
