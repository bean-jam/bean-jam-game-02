extends Node

@export var starting_wave: int = 1
@export var base_enemies_to_kill: int = 6
@export var enemies_per_wave_increase: int = 3

var current_wave: int = 0
#  Timer system will be added as well
var enemies_killed_this_wave: int = 0
var enemies_to_kill_this_wave: int = 0

var scrap: int = 0

func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.enemy_died.connect(_on_enemy_died)
	
	start_new_run()

func start_new_run() -> void:
	current_wave = starting_wave
	_start_wave(current_wave)


func _start_wave(wave_index: int) -> void:
	current_wave = wave_index
	enemies_killed_this_wave = 0
	enemies_to_kill_this_wave = base_enemies_to_kill + (wave_index - 1) * enemies_per_wave_increase

	
	SignalBus.emit_signal("wave_started", current_wave)
	print("GameManager: started wave", current_wave, "- need kills:", enemies_to_kill_this_wave)

func _on_enemy_died(enemy: Node) -> void:
	enemies_killed_this_wave += 1
	print("GameManager: enemy died —", enemies_killed_this_wave, "/", enemies_to_kill_this_wave)

	if enemies_killed_this_wave >= enemies_to_kill_this_wave:
		_on_wave_completed()


func _on_wave_completed() -> void:
	print("GameManager: wave completed", current_wave)
	SignalBus.emit_signal("wave_completed", current_wave)
	
	# Possibly increment current_wave here

	go_to_camp()


# Camp and Battle scene loaders
func go_to_camp() -> void:
	var camp_path : String = "res://scenes/camp_scene.tscn"
	if ResourceLoader.exists(camp_path):
		get_tree().change_scene_to_file(camp_path)
	else:
		print("GameManager.go_to_camp: camp scene not found:", camp_path)


func go_to_battle() -> void:
	var battle_path : String = "res://scenes/battle_scene.tscn"
	if ResourceLoader.exists(battle_path):
		get_tree().change_scene_to_file(battle_path)
		_start_wave(current_wave)
	else:
		print("GameManager.go_to_battle: battle scene not found:", battle_path)



func _on_player_died() -> void:
	print("GameManager: player died - handle game over here")
	# Eventually add game over logic
