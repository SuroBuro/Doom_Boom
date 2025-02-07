extends State
class_name Idle

@export var animated_sprite_3d: AnimatedSprite3D
@export var enemy : CharacterBody3D

var player:CharacterBody3D
var direction = Vector3.ZERO

func Enter():
	await get_tree().process_frame  # Ensures all nodes exist before searching
	player = get_tree().get_first_node_in_group("Player")

	if player == null:
		print("ERROR: Player not found in scene tree!")
		return  # Stop execution if player is null

	#direction = player.position - enemy.global_position

func Update(_delta: float):
	animated_sprite_3d.play("Idle")

func  Physics_Update(_delta:float):
	if direction.length() < 20:
		Transistioned.emit(self, "Chase") 
		
