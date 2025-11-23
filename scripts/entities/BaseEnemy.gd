extends BaseEntity
class_name BaseEnemy
# BaseEnemy class handles all recurring behavouir between enemy types
# Excludes movement control for example.
# The references to other nodes could be improved and made more modular.

@onready var body = $CollisionShape2D
@onready var hurtbox = $HurtboxComponent/CollisionShape2D
# Change to animated once we are using animations 
@onready var hit_flash = $Sprite2D/HitFlash
@onready var death_particles = $DeathParticles

func _ready() -> void:
	super()
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)

func _on_health_changed(current: int, max_hp: int) -> void:
	print("Enemy HP:", current, "/", max_hp)

func _on_died() -> void:
	# stop collision immediately so the corpse doesn't keep colliding
	body.set_deferred("disabled", true)
	stats.set_deferred("move_speed", 0.0)
	hurtbox.set_deferred("disabled", true)
	if death_particles:
		death_particles.emitting = true
	
	# Start a timer before deleting the enemy from the scene tree
	await get_tree().create_timer(0.4).timeout
	SignalBus.enemy_died.emit(self)
	queue_free()

func _on_entity_damaged(amount: int):
	super(amount)
	# Play hit flash for player (not a very modular way of doing it)
	if hit_flash:
		hit_flash.play("hit_flash")
