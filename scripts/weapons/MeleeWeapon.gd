extends Node2D
class_name MeleeWeapon
## This weapon automatically attacks with the entities base stats once the 
## cooldown has ended.

## Assign a BaseEntity as the holder of this weapon.
@export var holder: BaseEntity
## Extend how long your weapon hitbox stays active for.
@export var hitbox_duration: float = 0.2

## Find the HitboxComponent which should be a direct child of MeleeWeapon.
@onready var hitbox: HitboxComponent = $HitboxComponent

## Attack cooldown
var cooldown: float = 0.0

func _ready() -> void:
	if holder == null:
		print("Assign a holder for this weapon")
		return

## Runs every physics process to ensure holder is assigned and to reduce cooldown
## between attacks.
func _physics_process(delta: float) -> void:
	if holder == null or not is_instance_valid(holder):
		return

	cooldown = max(0.0, cooldown - delta)
	if cooldown <= 0.0:
		_perform_attack()


## Called once the attack cooldown reaches 0
## The function initialises the hitbox and then enables it for the set duration.
func _perform_attack() -> void:
	cooldown = holder.stats.attack_cooldown

	# Set damage from owner's stats
	hitbox.setup(holder.stats.attack_damage)
	
	# Enable hitbox for a short timed window
	_enable_hitbox_for(hitbox_duration)


## Enables a hitbox for the alloted duration period.
func _enable_hitbox_for(duration: float) -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(duration).timeout
	hitbox.monitoring = false
