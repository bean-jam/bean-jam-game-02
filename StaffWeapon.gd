extends Node2D
class_name StaffWeapon
# This weapon automatically attacks with the entities base stats once the cooldown
# has ended.

@export var holder: BaseEntity

@onready var staff_animation = $AnimatedSprite2D
@onready var hitbox: HitboxComponent = $HitboxComponent
var cooldown: float = 0.0


func _ready() -> void:
	if holder == null:
		print("Assign a holder for this weapon")
		return

func _physics_process(delta: float) -> void:
	if holder == null or not is_instance_valid(holder):
		return

	cooldown -= delta
	if cooldown <= 0.0:
		_perform_attack()

func _perform_attack() -> void:
	cooldown = holder.stats.attack_cooldown

	# Set damage from owner's stats
	hitbox.setup(holder, holder.stats.attack_damage)
	
	# Perform the staff swing and enable hitbox for duration of animation
	staff_animation.play("swing")
	hitbox.monitoring = true
	await staff_animation.animation_finished
	hitbox.monitoring = false
	
	
