extends BaseEntity
class_name BaseEnemy
## BaseEnemy class handles all recurring behaviours between enemy types.
## Shared behaviour for enemy scenes: health handling, death VFX, and 
## group registration.
## Enemies add themselves to the "enemies" group on enter and emit 
## global death via SignalBus.
## Movement and other unique behaviours are found in the sub classes 
## e.g BasicEnemy

@onready var body = $CollisionShape2D
@onready var hurtbox = $HurtboxComponent/CollisionShape2D
@onready var hit_flash = $Sprite2D/HitFlash
@onready var death_particles = $DeathParticles

## Handles how long the enemy stays on screen before being removed
@export var death_time: float = 0.4

## Add to the enemy group for counting when added to the game scene
func _enter_tree() -> void:
	add_to_group("enemies")

## remove from the enemy group for counting when removed from the game scene
func _exit_tree() -> void:
	if is_in_group("enemies"):
		remove_from_group("enemies")

## Connect local health signals and call super() to connect damage signals
## from the BaseEntity _ready()
func _ready() -> void:
	super()
	if health:
		health.health_changed.connect(_on_health_changed)
		health.died.connect(_on_died)


## Receives the current and max HP from the HealthComponent
func _on_health_changed(current: int, max_hp: int) -> void:
	print("Enemy HP:", current, "/", max_hp)


## Handles the enemies death.
## Disables the enemies physics and switches off movement before performing
## any death animations 
func _on_died() -> void:
	body.set_deferred("disabled", true)
	stats.set_deferred("move_speed", 0.0)
	hurtbox.set_deferred("disabled", true)
	if death_particles:
		death_particles.emitting = true
	
	# Start a timer before deleting the enemy from the scene tree
	await get_tree().create_timer(death_time).timeout
	remove_from_group("enemies")
	SignalBus.enemy_died.emit(self)
	queue_free()

## A function to handle what should happen every time the entity is damaged
## For example, hit flash animations and floating damage numbers
func _on_entity_damaged(amount: int) -> void:
	super(amount)
	if hit_flash:
		hit_flash.play("hit_flash")
