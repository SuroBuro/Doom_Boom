extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var death: Timer = $Death
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var accel = 3.0
@export var speed = 5.0
@export var attack_range:float = 10.0
@export var health:float = 90


@onready var player:CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead:bool = false
var in_range:bool = false


func ready():
	animated_sprite_3d.play("Idle")
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	
	set_movement_target(player.position)
	var distance = player.position - global_position
	try_to_kill(distance)
	
func set_movement_target(movement_target:Vector3):
	navigation_agent_3d.set_target_position(movement_target)


func _physics_process(_delta):
	
	if dead:
		return
		
	if navigation_agent_3d.is_navigation_finished():
		return
	var current_position:Vector3 = global_position
	var next_path_position:Vector3 = navigation_agent_3d.get_next_path_position()
	
	if !in_range:
		velocity = current_position.direction_to(next_path_position) * speed

	move_and_slide()
	
func update_target_location(target):
	navigation_agent_3d.target_position = target
	
func try_to_kill(distance):
	if distance >  attack_range:
		in_range = false
	else:
		in_range = true


func damage(weapon_damage):
	health -= weapon_damage
	if health <=0:
		kill()
	else:
		animated_sprite_3d.play("Hurt")
		await get_tree().create_timer(0.5).timeout
		animated_sprite_3d.play("Idle")
	
		

func kill():
	dead = true
	animated_sprite_3d.play("Dead")
	$CollisionShape3D.disabled = true
	death.start()
	audio_stream_player_3d.play()
	

func _on_death_timeout() -> void:
	queue_free()
