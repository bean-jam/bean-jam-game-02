extends Control

@onready var next_wave_button = $MainMenuContainer/VBoxContainer/Button

func _on_button_pressed() -> void:
	SignalBus.new_game_started.emit()
