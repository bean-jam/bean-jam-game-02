extends Node2D
class_name StaffWeapon
# This weapon automatically attacks with the players base stats once the cooldown
# has ended.

# Extend how long your staff swing stays active for.
# Eventually we will add an animation for the staff swing with a signal which
# emits a start and stop signal to tell the hitbox to be active for.
@export var hitbox_duration: float = 0.2

@onready var hitbox: HitboxComponent = $StaffHitbox
var holder: BaseEntity
var cooldown: float = 0.0

# This equips the staff to the player by default
func _ready() -> void:
	if holder == null:
		holder = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if holder == null or not is_instance_valid(holder):
		return

	cooldown -= delta
	if cooldown <= 0.0:
		_perform_attack()

func _perform_attack() -> void:
	print("attack performed")
	cooldown = holder.stats.attack_cooldown

	# Set damage from owner's stats
	hitbox.setup(holder, holder.stats.attack_damage)

	# Enable hitbox for a short timed window
	_enable_hitbox_for(hitbox_duration)

func _enable_hitbox_for(duration: float) -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(duration).timeout
	hitbox.monitoring = false
