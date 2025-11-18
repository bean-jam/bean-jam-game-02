extends CharacterBody2D
class_name BaseEntity
# This base entity is a class for all character entities in the game

# Adjust the smoothness of movement
@export_range(0.0, 1.0) var lerp_amount: float = 0.2

# This is a direction for the entity to move in
var move_input: Vector2 = Vector2.ZERO

# BaseEntities need Stats and Health Nodes as children
@onready var stats = $StatsComponent
@onready var health = $HealthComponent

func _physics_process(delta: float) -> void:
	var target_velocity = move_input * stats.move_speed
	velocity = velocity.lerp(target_velocity, lerp_amount)
	move_and_slide()
