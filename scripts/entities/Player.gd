extends BaseEntity
class_name Player
## Player inherits all base behaviours from BaseEntity and handles it's 
## own movement and other unique behaviours

## Connect the health signals
func _ready() -> void:
	super()
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)

## Handle player specific movement, physics process happens on entity class
func _process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_input = input_vector

## Called everytime health changes to update the UI
func _on_health_changed(current_hp: int, max_hp: int) -> void:
	SignalBus.player_health_changed.emit(current_hp, max_hp)
	
## Called on player death.
## Emits a signal for the GameManager to handle Game Over logic
func _on_died() -> void:
	SignalBus.player_died.emit() 

## Called every time the player is damaged.
## Currently just a hit flash.
func _on_entity_damaged(amount: int):
	super(amount)
	# Play hit flash for player (not a very modular way of doing it)
	$AnimatedSprite2D/HitFlash.play("hit_flash")
