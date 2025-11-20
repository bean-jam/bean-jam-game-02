extends Node

# Game flow
signal wave_started(wave_index: int)
signal wave_completed(wave_index: int)
signal next_wave_started

# Entities
signal enemy_died(enemy: Node)    
signal player_died    
signal player_health_changed(current_hp: int, max_hp: int)            

# Economy 
signal scrap_changed(new_amount: int)

# Upgrades
signal blueprint_found(id: String)
signal upgrade_purchased(id: String)
