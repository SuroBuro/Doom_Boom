extends State
class_name Attack

@export var animated_sprite:AnimatedSprite3D
@export var enemy:CharacterBody3D
@export var navigation_agent_3d:NavigationAgent3D 
@export var timer:Timer 
@export var area3d:Area3D

var player
var has_attacked:bool = false

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):

	if navigation_agent_3d.is_navigation_finished():
		animated_sprite.play("Attack")
		timer.start()
		has_attacked = true
		
		
		#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("Kuch toh huya")
	#if body:
		#print("Wow,nice")
		#

#func attack():
	#animated_sprite.play("Attack")
	#timer.start()
	#has_attacked = true
	

func _on_hurt_timeout() -> void:
	if player:
		player.kill()
		has_attacked = false
