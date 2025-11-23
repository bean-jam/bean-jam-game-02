extends Node2D
class_name EnemySpawner
# EnemySpawner spawns any enemy scene that is put in the Enemy Scene variable.
# You can adjust the amount of enemies that spawn in a swarm.
# Can add a max amount variable and use the alive count to cap the enemies spawning.

@export var enemy_scene: PackedScene
@export var enemy_amount: int = 1          
@export var spawn_interval: float = 2.0 
@export var spawn_radius: float = 64.0

# This could be used for limiting the amount of enemies but it not used 
# currently. There is also a signal on the SignalBus which could achieve the
# same effect but for total amount of enemies instead of a per enemy type. 
var alive_count: int = 0

var wave_timer_done: bool

@onready var spawn_timer: Timer = $Timer

func _ready() -> void:
	# Set the flag back to false at the start of every round when 
	# this scene loads
	wave_timer_done = false
	
	# Check if the wave timer is finished running
	SignalBus.wave_timer_done.connect(_wave_timer_done)
	
	# Initialise spawn timer
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	if enemy_scene == null:
		return
	
	# Stop spawning when timer runs out
	if wave_timer_done:
		return
	else:
		# Multiple enemy spawner
		for i in range(enemy_amount):
			var enemy: BaseEntity = enemy_scene.instantiate()
			
			# Spawn enemies in a circle area 
			var angle := randf() * TAU
			var distance := randf() * spawn_radius
			var offset := Vector2(cos(angle), sin(angle)) * distance

			enemy.global_position = global_position + offset

			get_parent().add_child(enemy)
			enemy.add_to_group("enemies")
			alive_count += 1

			# When each enemy dies, decrement the alive count
			if enemy.health:
				enemy.health.died.connect(func() -> void:
					alive_count -= 1
				)
			
func _wave_timer_done() -> void:
	wave_timer_done = true
