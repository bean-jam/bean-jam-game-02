extends Node2D
class_name StaffWeapon
## This is the Player's base weapon. It automatically attacks with the entities 
## base stats once the cooldown has ended.

## Assign the holder of the weapon
@export var holder: BaseEntity

@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var staff_animation = $AnimatedSprite2D
@onready var staff_swing_sfx = $StaffSwingSFX


var rng = RandomNumberGenerator.new()

var cooldown: float = 0.0

## Ensures holder has been assigned
func _ready() -> void:
	if holder == null:
		print("Assign a holder for this weapon")
		return

## Similar to the MeleeWeapon function but it uses a different _perform_attack
func _physics_process(delta: float) -> void:
	if holder == null or not is_instance_valid(holder):
		return

	cooldown -= delta
	if cooldown <= 0.0:
		_perform_attack()

## Includes the StaffWeapon unique properties such as the animation and 
## the SFX
func _perform_attack() -> void:
	cooldown = holder.stats.attack_cooldown
	
	# Set damage from owner's stats
	hitbox.setup(holder.stats.attack_damage)
	
	# Randomise the pitch of the swing sound each hit
	staff_swing_sfx.pitch_scale = randf_range(0.9, 1.5)
	
	# Perform the staff swing and enable hitbox for duration of animation
	staff_animation.play("swing")
	staff_swing_sfx.play()
	hitbox.monitoring = true
	await staff_animation.animation_finished
	hitbox.monitoring = false
	
	
