extends CharacterBody3D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var shoot_sound: AudioStreamPlayer = $"Shotgun Sound"
@onready var pistol_sound: AudioStreamPlayer = $"Pistol Sound"
@onready var bob_anim:AnimationPlayer = $CanvasLayer/GunBase/AnimationPlayer
@onready var camera:Camera3D = $Camera3D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $CanvasLayer/GunBase/AnimatedSprite2D2
@onready var omni_light_3d: SpotLight3D = $OmniLight3D
@onready var hurt_screen: ColorRect = $CanvasLayer/HurtScreen
@onready var label_2: Label = $CanvasLayer/Control/Label2
@onready var label: Label = $CanvasLayer/Control/Label



const SPEED:float = 10
const SENSITIVIY = 0.08
const BOB_AMPLITUDE:float = 0.1 
const BOB_FREQUENCY:float = 2
const ROTATE_HEAD:float = deg_to_rad(20)

var shotgun_damage:float = 50
var shotgun_shells:int = 500
var pistol_damage:float = 15
var player_health:float = 120
var pistol_active:bool = true
var can_shoot:bool = true
var dead:bool = false
var bob_factor:float

func _ready():
	Engine.set_max_fps(60)
	Input.mouse_mode =Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	animated_sprite_2d_2.animation_finished.connect(shoot_anim_done)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)  

func _input(event: InputEvent):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * SENSITIVIY
	
func _process(_delta):
	
	label_2.text = "Player health: " + str(player_health)
	label.text = "Shotgun Shells " + str(shotgun_shells)
	
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
		
	if dead:
		return
	if Input.is_action_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed(&"Shotgun") and  shotgun_shells > 0:
		pistol_active = false
		set_weapon(pistol_active)
	elif shotgun_shells <= 0:
		if animated_sprite_2d.is_playing() == false:
			pistol_active = true
			set_weapon(true)
		
	if Input.is_action_just_pressed(&"Shotgun") and shotgun_shells <=0:
		pistol_active = true
		set_weapon(pistol_active)
	elif Input.is_action_just_pressed(&"Pistol"):
		pistol_active = true
		set_weapon(pistol_active)

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
	omni_light_3d.show()
	
	if pistol_active == true:
		animated_sprite_2d_2.play("Shoot")
		pistol_sound.play()
		damager(pistol_damage)
	else:
		animated_sprite_2d.play("Shoot")
		shoot_sound.play()
		damager(shotgun_damage)
		shotgun_shells -= 2
	
	await get_tree().create_timer(0.1).timeout
	omni_light_3d.hide() 
	
	
	
func shoot_anim_done():
	can_shoot = true
	

func kill():
	if dead:
		return
	
	player_health -= 1
	hurt_screen.show()
	await get_tree().create_timer(1).timeout
	hurt_screen.hide()
	if player_health <= 0:
		dead = true
		$CanvasLayer/DeathScreen.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func damager(damage):
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("damage"):
		ray_cast_3d.get_collider().damage(damage)


func set_weapon(pistol:bool):
	if pistol:
		animated_sprite_2d_2.show()
		animated_sprite_2d.hide()
		ray_cast_3d.target_position.z = -50
	else:
		animated_sprite_2d.show()
		animated_sprite_2d_2.hide()
		ray_cast_3d.target_position.z = -20
		
