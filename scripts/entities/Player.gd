extends BaseEntity
class_name Player

func _ready() -> void:
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)

func _on_health_changed(current: int, max_hp: int) -> void:
	print("Player HP:", current, "/", max_hp)

func _on_died() -> void:
	print("Player died!")
	# SignalBus.player_died.emit() (Once signal bus is set up)
	# Later: pause game, show game over, etc.
