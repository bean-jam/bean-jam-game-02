extends CharacterBody2D
class_name BaseEntity
## This BaseEntity node is a class for all character entities in the game to 
## to inherit from.
## It handles the physics process and the movement but receives the move input 
## from it's sub classes.


## Adjust the smoothness of movement
@export_range(0.0, 1.0) var lerp_amount: float = 0.2

# Knockback settings
## Turn Knockback on and off per entity
@export var knockback: bool = true
## Adjust the Knockback speed
@export var knockback_speed: float = 600.0
## Adjust the Knockback amount
@export var knockback_amount: float = 0.13
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var knockback_cooldown: float = 0.0

# This is a direction for the entity to move in
var move_input: Vector2 = Vector2.ZERO

# BaseEntities need Stats and Health Nodes as children
@onready var stats = $StatsComponent
@onready var health = $HealthComponent

## Ensure the components are added correctly
func _ready() -> void:
	if health:
		health.damaged.connect(_on_entity_damaged)
	if not stats:
		print("Entities require a StatsComponent")


## Handles the process of physics during frames
func _physics_process(delta: float) -> void:
	var target_velocity
	
	if knockback and knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer = max(0.0, knockback_timer - delta)
	else:
		# Move normally
		target_velocity = move_input * stats.move_speed
		# Make enemies snap back instead of lerping
		if knockback_cooldown > 0:
			knockback_cooldown = max(0.0, knockback_cooldown - delta)
			velocity = target_velocity / 1.5
		else:
			velocity = velocity.lerp(target_velocity, lerp_amount)
	move_and_slide()


## Handles the Knockback effect on a per entity basis.
## Hit flash is handled on the sub classes incase it isn't universally used.
func _on_entity_damaged(amount: int):
	# Knockback
	if knockback:
		knockback_timer = knockback_amount
		knockback_cooldown = knockback_amount * 2
		knockback_velocity = (-move_input.normalized()) * knockback_speed

	
		
		 

	
