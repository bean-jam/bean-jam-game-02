extends Node
## GameManager manages wave progression, timers and global enemy counts.
## Emits/receives global signals via SignalBus to coordinate the UI 
## and scene transitions.


## Wave system set up
var starting_wave: int = 1
var current_wave: int = 0
var initial_wave_length: int = 15
var wave_timer : Timer = Timer.new()
var added_wave_length: int = 15

# These variables are used in the HUD
var seconds_left: int
var enemies_left: int
var scrap: int = 0

## This flag controls whether the display time or enemy count signals
## get sent to the HUD
var wave_timer_done: bool = false


## Initialises RNG and the wave timer.
## Also connects all the signals used to control the flow of the game.
func _ready() -> void:
	randomize()
	SignalBus.new_game_started.connect(_start_game)
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.enemy_died.connect(_on_enemy_died)
	SignalBus.next_wave_started.connect(_start_next_wave)
	SignalBus.wave_timer_done.connect(_on_wave_timer_done)
	

	add_child(wave_timer)
	wave_timer.wait_time = 1.0
	wave_timer.one_shot = false
	wave_timer.timeout.connect(_on_timer_tick)
	

## Runs when the main menu start button is pressed.
func _start_game() -> void:
	start_new_run()
	# Might want some features in the future before the start button in the 
	# main menu and the run beginning

## Initialises a new run
func start_new_run() -> void:
	current_wave = starting_wave
	seconds_left = initial_wave_length
	_start_wave(current_wave)
	# Wait until next idle frame
	call_deferred("go_to_battle")

## Starts the wave timer and sends the signals.
func _start_wave(wave_index: int) -> void:
	current_wave = wave_index 
	wave_timer_done = false
	
	wave_timer.start()

	SignalBus.emit_signal("wave_started", current_wave)
	SignalBus.emit_signal("wave_timer_updated", seconds_left)

## Runs everytime the timer reaches 0.
## It is used to update the HUD
func _on_timer_tick() -> void:
	if wave_timer_done == false:
		seconds_left = max(0, seconds_left - 1)
		SignalBus.emit_signal("wave_timer_updated", seconds_left)
	if seconds_left <= 0:
		wave_timer.stop()
		SignalBus.emit_signal("wave_timer_done")

## Sends the initial enemies left this wave to the display.
func _on_wave_timer_done() -> void:
	wave_timer_done = true
	
	enemies_left = get_tree().get_nodes_in_group("enemies").size()
	SignalBus.emit_signal("enemy_total_changed", enemies_left)
	if enemies_left <= 0:
			_on_wave_completed()

## Set up the next wave. 
func _start_next_wave() -> void:
	# Set up the next wave.
	# Extend timer (Currently resets to initial value and adds secs)
	seconds_left = initial_wave_length + (current_wave * added_wave_length)

	current_wave += 1
	_start_wave(current_wave)
	# Wait until next idle frame
	call_deferred("go_to_battle")
	

## Handles post timer enemy count logic.
## General enemy death is handled in the BaseEnemy class.
func _on_enemy_died(enemy: Node) -> void:
	if wave_timer_done:
		enemies_left = get_tree().get_nodes_in_group("enemies").size()
		SignalBus.emit_signal("enemy_total_changed", enemies_left)
		if enemies_left <= 0:
			_on_wave_completed()

## Emits the wave complete signal and loads the camp scene
func _on_wave_completed() -> void:
	print("GameManager: wave completed", current_wave)
	SignalBus.emit_signal("wave_completed", current_wave)
	
	# Wait until next idle frame
	call_deferred("go_to_camp")


## CampScene loader.
func go_to_camp() -> void:
	var camp_path : String = "res://scenes/core/camp_scene.tscn"
	if ResourceLoader.exists(camp_path):
		get_tree().change_scene_to_file(camp_path)
	else:
		print("GameManager.go_to_camp: camp scene not found:", camp_path)

## BattleScene loader.
func go_to_battle() -> void:
	var battle_path : String = "res://scenes/core/battle_scene.tscn"
	if ResourceLoader.exists(battle_path):
		get_tree().change_scene_to_file(battle_path)
	else:
		print("GameManager.go_to_battle: battle scene not found:", battle_path)

## Handles game over logic.
func _on_player_died() -> void:
	print("GameManager: player died - handle game over here")
	# Eventually add game over logic
