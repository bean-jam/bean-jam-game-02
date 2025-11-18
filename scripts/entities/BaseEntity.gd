extends CharacterBody2D
class_name BaseEntity

# This is a direction for the entity to move in
var move_input: Vector2 = Vector2.ZERO

# BaseEntities need Stats and Health Nodes as children
@onready var stats = $Stats
@onready var health = $Health

func _physics_process(delta: float) -> void:
	velocity = move_input * stats.move_speed
	move_and_slide()
