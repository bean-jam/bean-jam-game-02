extends Node

# Game flow
signal wave_started(wave_index: int)
signal wave_completed(wave_index: int)
signal next_wave_started

# Entities
signal player_died    
signal player_health_changed(current_hp: int, max_hp: int)   
signal enemy_died(enemy: Node)    
signal enemy_total_changed(enemies_killed: int, total_enemies: int)             

# Economy 
signal scrap_changed(new_amount: int)

# Upgrades
signal blueprint_found(id: String)
signal upgrade_purchased(id: String)
