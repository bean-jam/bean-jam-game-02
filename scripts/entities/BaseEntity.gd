extends CharacterBody2D
class_name BaseEntity
# This base entity is a class for all character entities in the game

# Adjust the smoothness of movement and knockback effects
@export_range(0.0, 1.0) var lerp_amount: float = 0.2
@export var knockback: bool = true
@export var knockback_speed = 600.0
@export var knockback_amount = 0.13
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var knockback_cooldown: float = 0.0

# This is a direction for the entity to move in
var move_input: Vector2 = Vector2.ZERO

# BaseEntities need Stats and Health Nodes as children
@onready var stats = $StatsComponent
@onready var health = $HealthComponent

func _ready() -> void:
	health.damaged.connect(_on_entity_damaged)

func _physics_process(delta: float) -> void:
	var target_velocity
	
	if knockback == true and knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
	else:
		# Move normally
		target_velocity = move_input * stats.move_speed
		# Make enemies snap back instead of lerping
		if knockback_cooldown > 0:
			knockback_cooldown -= delta
			velocity = target_velocity / 1.5
		else:
			velocity = velocity.lerp(target_velocity, lerp_amount)
	move_and_slide()
		
func _on_entity_damaged(amount: int):
	if knockback == true:
		knockback_timer = knockback_amount
		knockback_cooldown = knockback_amount * 2
		knockback_velocity = (-move_input.normalized()) * knockback_speed
	

	
		
		 

	
