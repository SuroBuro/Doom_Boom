extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var death: Timer = $Death

@export var speed:float = 10.0
@export var attack_range:float = 1.0


@onready var player:CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead:bool = false


func _physics_process(_delta: float):
	if dead:
		return
	if player == null:
		return
	
	var direction = player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
	try_to_kill()
	
func try_to_kill():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line,1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		player.kill()
	

	
func kill():
	dead = true
	animated_sprite_3d.play("Dead")
	$CollisionShape3D.disabled = true
	death.start()
	
	


func _on_death_timeout() -> void:
	queue_free()
