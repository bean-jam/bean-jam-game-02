# Notes

Project settings currently 800x450px 

Might be worth expermimenting with 768×432px or 960×540px to change the sprites size 
whilst keeping pixels crisp

## Design Structure:
We are attempting to make the game as modular as possible using composition and 
inheritance where needed to structure the code. In the project settings there 
are two important scripts which autoload on the starting of the game: 
	- GameManager 
	- SignalBus
	
The game uses a wave timer system and when the wave timer is complete you must
kill the remaining spawned enemies to end the wave. We use Godot's grouping
system to add enemies to the "enemies" group on spawn and then remove them when 
they die. Using this group allows us to easily query the length of the group which
we need when we display the enemies remaining once the timer has finished.
 
We use a series of signals from the signal bus which allows the GameManager and HUD 
to communicate with each other and send and recieve data. The GameManager uses a 
timer to tick down the seconds and send this to the HUD. When this is complete a 
signal switches the wave_timer_done boolean flag in the GameManager and the
EnemySpawner instances. This then influences the behaviour such as stopping the 
spawning of enemies and starting the enemies remaining count. The HUD can just
use the signal to hide and show the necessary information.

## GameManager:
	There is a GameManager script that controls the flow of the game and manages
	the state of the game. It is responsible for loading and configuring the 
	Battle Scene and Camp Scene which is the main loop of the gameplay. 
	It will control variables as the game progresses such as the in game economy 
	and the difficulty/spawning behaviours as the game scales. It relies on 
	signals sent from other nodes and the SignalBus to pass information easily 
	between different layers of the game
	
## SignalBus:
	The SignalBus script is the hub for global signals. Anytime you need to connect
	something to another thing that feels multiple steps away from the current node,
	you can probably create a signal on the SignalBus which another node can 
	listen for. It's used heavily for UI elements as it's easy to send signals from 
	the game to the display elements.
	
	An example of how these work is that the GameManger connects to the 
	"next_wave_started" signal on the SignalBus. When the "start next wave" button is 
	pressed on the Camp Scene it sends the "next_wave_started" signal to the SignalBus,
	the GameManager "hears" this and calls the start_wave function which loads the next
	wave.
	
## A note on collisions:
	In project settings, the collision layers have been named so you can hover over
	the numbers in the inspector and you can see what layer they corrospond with.
	Layer is the layer of the collision shape you are on and mask is the layer that
	you're colliding with. For example, on the Player's Hurtbox collision layers, 
	you would set Layer to "Player Hurtbox" which is 3, and the Mask to "Enemy Hitbox"
	which is 4.

## Making entities:
	Currently there are nodes and classes that we have created in the scripts/components
	folder which can be put together to create make entities
	
	BaseEntity: This is the parent node of any entity scene. New more specific classes
	can be created that inherit this one, for example, Player innherits BaseEntity.
	For enemies there is a BaseEnemy script with more general enemy behaviours.
	Requires a CollisionShape2D which acts as it's body for physics with the world.
	Requires a AnimatedSprite2D.
	
	Health Component: Exposes Max HP to be adjusted in the inspector and sends signals to
	other nodes that need health information
	
	Stats Component: Exposes base Move Speed, Attack Damage and Attack Cooldown to the 
	inspector. Runs a function every tick to calculate the stats with modifiers such as 
	upgrades.
	
	Hurtbox: Requires you to attach the corrosponding Health Component in the inspector.
	Requires a CollisionShape2D as a child with the appropriate collision layer and mask..
	Attaches to the entity and listens for overlaps with other entities Hitbox.
	
	Hitbox: Requires you to connect the on_area_entered signal in the Node tab.
	Requires a CollisionShape2D as a child with the appropriate collision layer and mask.
	Attaches to the entity or weapon and listens for overlaps with other entities Hurtbox.
	
	There are also DeathParticles and HitFlash animation which is currently a
	work in progress that I am copying from one entity to another. 
	
	The BaseEnemy script calls the HitFlash every time damage is taken and it calls the
	DeathParticles on death.
	
## Spawning Entities:
	There is a EnemySpawner scene which can be configured to spawn enemies. It requires
	you to drag the enemies scene that you want to spawn into the inspector and then
	adjust the variables that have been exported. It allows you to spawn big batches
	of enemies at once to a set radius. Eventually it will be configured by the 
	GameManager script to handle progression through the waves. It will also eventually
	ensure no enemies spawn in the players view by never spawning in the camera regions.
	
## The great big TODO list:
	- Please make some notes here of everything that needs to be done


# Version Control:
	
## Branch naming conventions:

- `feature/...` → new gameplay systems or features

- `refactor/...` → reorganizing or cleaning code

- `fix/...` → bugfixes

- `content/...` → new enemies, maps, animations, etc.
