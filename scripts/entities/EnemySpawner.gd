extends Node2D
class_name EnemySpawner
# EnemySpawner spawns any enemy scene that is put in the Enemy Scene variable.
# You can adjust the amount of enemies that spawn in a swarm.
# Can add a max amount variable and use the alive count to cap the enemies spawning.

@export var enemy_scene: PackedScene
@export var enemy_amount: int = 1          
@export var spawn_interval: float = 2.0 
@export var spawn_radius: float = 64.0


var alive_count: int = 0

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if enemy_scene == null:
		return


	for i in range(enemy_amount):
		var enemy: BaseEntity = enemy_scene.instantiate()
		
		# Spawn enemies in a circle area 
		var angle := randf() * TAU
		var distance := randf() * spawn_radius
		var offset := Vector2(cos(angle), sin(angle)) * distance

		enemy.global_position = global_position + offset

		get_parent().add_child(enemy)
		alive_count += 1

		# When each enemy dies, decrement the alive count
		if enemy.health:
			enemy.health.died.connect(func() -> void:
				alive_count -= 1
			)
