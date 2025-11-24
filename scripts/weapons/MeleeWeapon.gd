extends Node2D
class_name MeleeWeapon
# This weapon automatically attacks with the entities base stats once the cooldown
# has ended.

# Extend how long your weapon hitbox stays active for.
@export var hitbox_duration: float = 0.2
@export var holder: BaseEntity

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
	hitbox.setup(holder.stats.attack_damage)
	
	# Enable hitbox for a short timed window
	_enable_hitbox_for(hitbox_duration)

func _enable_hitbox_for(duration: float) -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(duration).timeout
	hitbox.monitoring = false
