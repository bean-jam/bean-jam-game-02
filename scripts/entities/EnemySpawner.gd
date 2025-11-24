extends Node2D
class_name EnemySpawner
## EnemySpawner spawns any enemy scene that is put in the EnemyScene variable.
## You can adjust the amount of enemies that spawn in a swarm.

## Add the scene with the Enemy you want to spawn
@export var enemy_scene: PackedScene
## Adjust how many of that enemy spawns each time
@export var enemy_amount: int = 1     
## Adjust how quickly enemies spawn     
@export var spawn_interval: float = 2.0 
## Adjust the size of the spawn radius (Can be used for randomness or swarms)
@export var spawn_radius: float = 64.0

# This could be used for limiting the amount of enemies but it not used 
# currently. There is also a signal on the SignalBus which could achieve the
# same effect but for total amount of enemies instead of a per enemy type. 
var alive_count: int = 0

var wave_timer_done: bool

## The spawn rate timer
@onready var spawn_timer: Timer = $Timer

## Connects the wave timer signals and initialises the spawn timer
func _ready() -> void:
	wave_timer_done = false
	SignalBus.wave_timer_done.connect(_wave_timer_done)

	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


## This functions run each time the spawn timer reaches 0.
## It spawns the amonut of enemies specified in the radius specified.
## It stops spawning once the wave timer reaches 0.
func _on_spawn_timer_timeout() -> void:
	if enemy_scene == null:
		return
	
	if wave_timer_done:
		return
	else:
		for i in range(enemy_amount):
			var enemy: BaseEntity = enemy_scene.instantiate()
			
			# Circular spawn zone
			var angle := randf() * TAU
			var distance := randf() * spawn_radius
			var offset := Vector2(cos(angle), sin(angle)) * distance

			enemy.global_position = global_position + offset

			get_parent().add_child(enemy)
			alive_count += 1

			# When each enemy dies, decrement the alive count of that type of
			# enemy (Not used yet)
			if enemy.health:
				enemy.health.died.connect(func() -> void:
					alive_count -= 1
				)


## Called when the GameManager sends the wave timer done signal
func _wave_timer_done() -> void:
	wave_timer_done = true
