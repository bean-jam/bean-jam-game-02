extends BaseEntity
class_name BasicEnemy
# The BasicEnemy class listens to the signals from it's health component

func _ready() -> void:
	print("BasicEnemy ready, health node:", health)
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)

func _on_health_changed(current: int, max_hp: int) -> void:
	print("Enemy HP:", current, "/", max_hp)

func _on_died() -> void:
	print("Enemy died!")
	queue_free()
