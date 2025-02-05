extends CharacterBody3D

@onready var animated_sprite_2d: AnimatedSprite2D = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var bob_anim:AnimationPlayer = $CanvasLayer/GunBase/AnimationPlayer

const SPEED:float = 7.5
const SENSITIVIY = 0.2
const BOB_AMPLITUDE:float = 0.1 
const BOB_FREQUENCY:float = 2

var can_shoot:bool = true
var dead:bool = false
var bob_factor:float

func _ready():
	Engine.set_max_fps(60)
	Input.mouse_mode =Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)  

func _input(event: InputEvent):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * SENSITIVIY
	
func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
		
	if dead:
		return
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	#animated_sprite_2d.position.y = sin(  * 0.3) 

func _physics_process(_delta):

	if dead:
		return
		
	var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_front", &"move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		bob_anim.play("Gun Bob")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		bob_anim.stop()
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	move_and_slide()

func restart():
	get_tree().reload_current_scene()
	
func shoot():
	if !can_shoot:
		return
	can_shoot = false
	animated_sprite_2d.play("Shoot")
	shoot_sound.play()
	
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()
		
	
	
	
func shoot_anim_done():
	can_shoot = true

func kill():
	dead = true
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func gun_bob(time: float) -> Vector2:
	var pos = Vector2.ZERO
	pos.y = BOB_AMPLITUDE * sin(BOB_FREQUENCY * time)
	pos.x = BOB_AMPLITUDE * cos(BOB_FREQUENCY/2 * time)
	return pos
	pass
