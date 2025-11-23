extends Control

@onready var bar = $HPBar
@onready var enemy_count = $PanelContainer/EnemyCount
@onready var timer_display = $PanelContainer/TimeDisplay

var total_enemies: int
var seconds_left: int

func _ready() -> void:
	SignalBus.player_health_changed.connect(_update_hp_bar)
	SignalBus.enemy_total_changed.connect(_display_enemy_info)
	SignalBus.wave_started.connect(_wave_started)
	SignalBus.wave_timer_updated.connect(_update_time_display)
	SignalBus.wave_timer_done.connect(_wave_timer_done)
	
	# Initial display
	seconds_left = GameManager.seconds_left

	_update_time_display(seconds_left)
	
func _wave_started() -> void:
	enemy_count.visible = false
	timer_display.visible = true
	
	
func _update_time_display(seconds_left) -> void:
	var mm : int = seconds_left / 60
	var ss : int = seconds_left % 60
	timer_display.text = "%02d:%02d" % [mm, ss]
	
func _wave_timer_done() -> void:
	timer_display.visible = false
	# Display Enemy Count
	enemy_count.visible = true
	# Initial Display
	total_enemies = GameManager.enemies_left
	_display_enemy_info(total_enemies)
	
	
func _display_enemy_info(total_enemies: int):
	var display_text =( 
	"Enemies Remaining: " + str(total_enemies))
	enemy_count.text = display_text
	
func _update_hp_bar(current_hp, max_hp):
	set_health(current_hp, max_hp)

func set_health(new_hp: int, max_hp: int) -> void:
	bar.max_value = max_hp
	bar.value = clamp(new_hp, 0, max_hp)
	
