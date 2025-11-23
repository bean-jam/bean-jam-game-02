extends Node

# Game flow
signal new_game_started
signal wave_started(wave_index: int)
signal wave_completed(wave_index: int)
signal next_wave_started
signal wave_timer_updated(seconds: int)
signal wave_timer_done

# Entities
signal player_died    
signal player_health_changed(current_hp: int, max_hp: int)   
signal enemy_died(enemy: Node)    
signal enemy_total_changed(enemies_left: int)        

# Economy 
signal scrap_changed(new_amount: int)

# Upgrades
signal blueprint_found(id: String)
signal upgrade_purchased(id: String)
