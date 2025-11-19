extends Node

# Game flow
signal wave_started(wave_index: int)
signal wave_completed(wave_index: int)

# Entities
signal enemy_died(enemy: Node)    # emit(self) from the enemy
signal player_died                # emit() from the Player

# Economy 
signal scrap_changed(new_amount: int)

# Upgrades
signal blueprint_found(id: String)
signal upgrade_purchased(id: String)
