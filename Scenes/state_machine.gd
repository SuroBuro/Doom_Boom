extends Node3D

enum {
	IDLE,
	ATTACK,
	HURT
}
@onready var animated_sprite_3d: AnimatedSprite3D = $"../AnimatedSprite3D"
@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"


var state = IDLE

func _process(delta: float):
	if navigation_agent_3d.is_navigation_finished():
		animated_sprite_3d.play("Attack")
