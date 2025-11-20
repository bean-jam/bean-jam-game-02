extends Control

@onready var bar = $TextureProgressBar

func _ready() -> void:
	SignalBus.player_health_changed.connect(_update_hp_bar)
	
	
func _update_hp_bar(current_hp, max_hp):
	set_health(current_hp, max_hp)

func set_health(new_hp: int, max_hp: int) -> void:
	bar.max_value = max_hp
	bar.value = clamp(new_hp, 0, max_hp)
	
