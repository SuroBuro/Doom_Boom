extends State
class_name Chase

@export var animated_sprite:AnimatedSprite3D
@export var enemy:CharacterBody3D
@export var speed:float = 3
@export var accel:float = 10
@export var navigation_agent_3d:NavigationAgent3D 
var dead:bool = false
var player: CharacterBody3D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(_delta: float):
	if dead:
		return
		
	if navigation_agent_3d.is_navigation_finished():
		return
	var current_position:Vector3 = enemy.position
	var next_path_position:Vector3 = navigation_agent_3d.get_next_path_position()
	
	enemy.velocity = current_position.direction_to(next_path_position) * speed
	

func ready():
	animated_sprite.play("Idle")
	
	navigation_agent_3d.path_desired_distance = 0.5
	navigation_agent_3d.target_desired_distance = 0.5
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(player.position)
	
func set_movement_target(movement_target:Vector3):
	navigation_agent_3d.set_target_position(movement_target)

func _physics_process(_delta):
	pass
	

	
func update_target_location(target):
	navigation_agent_3d.target_position = target
	
