extends CharacterBody3D
class_name necromancer

var eye = preload("res://Scenes/eye.tscn")

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var death: Timer = $Death
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var speed:float = 3
@export var accel:float = 10
@export var attack_range:float = 1.0
@export var health:float = 60

@onready var player:CharacterBody3D = get_tree().get_first_node_in_group("Player")
var dead:bool = false



func ready():
	animated_sprite_3d.play("Idle")
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(player.position)
	
func set_movement_target(movement_target:Vector3):
	navigation_agent_3d.set_target_position(movement_target)

func _physics_process(_delta):
	
	if dead:
		return
	if navigation_agent_3d.is_navigation_finished():
		return
	var current_position:Vector3 = global_position
	var next_path_position:Vector3 = navigation_agent_3d.get_next_path_position()
	
	velocity = current_position.direction_to(next_path_position) * speed

	move_and_slide()
	
	
func update_target_location(target):
	navigation_agent_3d.target_position = target
	

func damage(weapon_damage) -> bool:
	health -= weapon_damage
	if health <= 0:
		kill()
	elif health > 0 :
		animated_sprite_3d.play("Hurt")
	
	return true
	
func kill():
	dead = true
	animated_sprite_3d.play("Dead")
	$CollisionShape3D.disabled = true
	death.start()
	audio_stream_player_3d.play()
	
	
func _on_death_timeout() -> void:
	queue_free()
