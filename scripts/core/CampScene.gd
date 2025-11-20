extends Node2D

@onready var next_wave_button = $Button

func _on_button_pressed() -> void:
	SignalBus.next_wave_started.emit()
