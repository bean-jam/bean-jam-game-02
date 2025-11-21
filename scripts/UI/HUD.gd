extends Control

@onready var bar = $TextureProgressBar
@onready var enemy_count = $PanelContainer/EnemyCount

func _ready() -> void:
	SignalBus.player_health_changed.connect(_update_hp_bar)
	SignalBus.enemy_total_changed.connect(_display_enemy_info)
	
	# Initial display
	var killed = GameManager.enemies_killed_this_wave
	var total = GameManager.enemies_to_kill_this_wave
	_display_enemy_info(killed, total)
	
	
func _display_enemy_info(enemies_killed: int, total_enemies: int):
	var display_text =( 
	"Enemies left: " + str(enemies_killed) + "/" + str(total_enemies))
	enemy_count.text= display_text
	
func _update_hp_bar(current_hp, max_hp):
	set_health(current_hp, max_hp)

func set_health(new_hp: int, max_hp: int) -> void:
	bar.max_value = max_hp
	bar.value = clamp(new_hp, 0, max_hp)
	
