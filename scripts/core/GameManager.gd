extends Node

@export var starting_wave: int = 1
@export var base_enemies_to_kill: int = 20
@export var enemies_per_wave_increase: int = 10

# Timer system will be added as well
var current_wave: int = 0
var wave_timer : Timer = Timer.new()

# Initial time of wave in seconds
var initial_wave_length: int = 15
# Wave timer increase per wave
var added_wave_length: int = 15
var seconds_left: int

# These variables are also used in the HUD
var enemies_left: int
var scrap: int = 0

var wave_timer_done: bool = false

func _ready() -> void:
	# Intialise RNG
	randomize()
	# Signal for start of new game from main menu
	SignalBus.new_game_started.connect(_start_game)
	# Signal on player death for game over logic
	SignalBus.player_died.connect(_on_player_died)
	# Signal on enemy death for wave logic
	SignalBus.enemy_died.connect(_on_enemy_died)
	# Signal from camp scene button to start next wave
	SignalBus.next_wave_started.connect(_start_next_wave)
	# Signal for wave timer done so UI can switch time to enemies left
	SignalBus.wave_timer_done.connect(_on_wave_timer_done)
	
	# Initialise wave timer
	add_child(wave_timer)
	wave_timer.wait_time = 1.0
	wave_timer.one_shot = false
	wave_timer.timeout.connect(_on_timer_tick)
	

# Might want some features in the future before the start button in the 
# main menu and the run beginning
func _start_game() -> void:
	start_new_run()
	
func start_new_run() -> void:
	current_wave = starting_wave
	seconds_left = initial_wave_length
	_start_wave(current_wave)
	# Wait until next idle frame
	call_deferred("go_to_battle")


func _start_wave(wave_index: int) -> void:
	current_wave = wave_index 
	wave_timer_done = false
	
	# Start wave countdown
	wave_timer.start()

	SignalBus.emit_signal("wave_started", current_wave)
	SignalBus.emit_signal("wave_timer_updated", seconds_left)

func _on_timer_tick() -> void:
	if wave_timer_done == false:
		seconds_left = max(0, seconds_left - 1)
		SignalBus.emit_signal("wave_timer_updated", seconds_left)
	if seconds_left <= 0:
		wave_timer.stop()
		SignalBus.emit_signal("wave_timer_done")
		
func _on_wave_timer_done() -> void:
	wave_timer_done = true
	# Send the total enemies left to the display
	enemies_left = get_tree().get_nodes_in_group("enemies").size()
	SignalBus.emit_signal("enemy_total_changed", enemies_left)
	
func _start_next_wave() -> void:
	# Set up the next wave.
	# Extend timer  each round (Currently resets to initial value and adds secs
	seconds_left = initial_wave_length + (current_wave * added_wave_length)
	# Increment wave count and extend timer
	current_wave += 1
	_start_wave(current_wave)
	# Wait until next idle frame
	call_deferred("go_to_battle")
	

func _on_enemy_died(enemy: Node) -> void:
	# General enemy death is handled in the BaseEnemy class.
	# This just handles the post timer enemy logic.
	if wave_timer_done:
		enemy.remove_from_group("enemies")
		enemies_left = get_tree().get_nodes_in_group("enemies").size()
		SignalBus.emit_signal("enemy_total_changed", enemies_left)
		if enemies_left <= 0:
			_on_wave_completed()


func _on_wave_completed() -> void:
	print("GameManager: wave completed", current_wave)
	SignalBus.emit_signal("wave_completed", current_wave)
	
	# Wait until next idle frame
	call_deferred("go_to_camp")


# Camp and Battle scene loaders
func go_to_camp() -> void:
	var camp_path : String = "res://scenes/core/camp_scene.tscn"
	if ResourceLoader.exists(camp_path):
		get_tree().change_scene_to_file(camp_path)
	else:
		print("GameManager.go_to_camp: camp scene not found:", camp_path)


func go_to_battle() -> void:
	var battle_path : String = "res://scenes/core/battle_scene.tscn"
	if ResourceLoader.exists(battle_path):
		get_tree().change_scene_to_file(battle_path)
	else:
		print("GameManager.go_to_battle: battle scene not found:", battle_path)



func _on_player_died() -> void:
	print("GameManager: player died - handle game over here")
	# Eventually add game over logic
