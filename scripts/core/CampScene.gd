extends Node2D
## The main CampScene where the player goes after each wave to rest and upgrade

@onready var next_wave_button = $Button

func _on_button_pressed() -> void:
	SignalBus.next_wave_started.emit()
