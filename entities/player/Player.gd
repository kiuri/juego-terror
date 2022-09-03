extends KinematicBody2D


onready var sprite = $Sprite

export(int) var SPEED = 280
export(int) var MAX_SPEED = 300
export(int) var JUMP_FORCE = 300
#export(int) var SPEED_DASH = 50
export(int) var GRAVITY = 500
#export(int) var GRAVITY_WITH_COAT = 100
export (float) var FRICTION = 1.0
export (int) var SLOPE_MAX_ANGLE = deg2rad(45) #max angle to be slope

var isWithCoat = true
var isFallWithCoat  = false
var isOnFloor = true
var isDash = false
var isJustJumped = true
var isDoubleJumping = false

var snap = Vector2.ZERO
var velocity = Vector2.ZERO
var normal_rotation = Vector2.DOWN

# signals
signal hit_pass(pass_door)


func _ready():
	normal_rotation = rotation
func _physics_process(delta):	
	var input = get_input_vector()
	add_horizontal_force(input,delta)
	add_friction(input)
	update_snap_vector()
	jump_check()
	add_gravity(delta)
	control_animation(input)
	#update_velocity_rotation(input)	
	move()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector

func add_horizontal_force(input,delta):
	if(input.x != 0):
		velocity.x += input.x * (SPEED) * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
func add_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():		
		velocity.x = lerp(velocity.x, 0, FRICTION)	
		
func add_gravity(delta):
	velocity.y += delta * GRAVITY

func move():
	var wasInAir = not is_on_floor()	
	velocity = move_and_slide_with_snap(velocity.rotated(rotation),snap * 128, -transform.y, true, 4, SLOPE_MAX_ANGLE)
	velocity = velocity.rotated(-rotation)
	if(wasInAir and is_on_floor()):
		isDoubleJumping = true		

	if not wasInAir and not is_on_floor() and not isJustJumped:
		velocity.y = 0


func update_snap_vector():
	if is_on_floor():
		snap = transform.y
		
func jump(force):	
	velocity.y = -force
	snap = Vector2.ZERO

func jump_check():
	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
		if Input.is_action_just_pressed("ui_up"):
			jump(JUMP_FORCE)
			isJustJumped = true
	else:
		rotation = normal_rotation
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2:
			velocity.y = -JUMP_FORCE/2;
		
		if Input.is_action_just_pressed("ui_up") and isDoubleJumping == true:
			jump(JUMP_FORCE * .75)
			isDoubleJumping = false
	
func control_animation(input):
	var sprite_direction = sign(input.x)
	if sprite_direction != 0:
		var sprite_direction_bool = false if sprite_direction>0 else true
		sprite.flip_h = sprite_direction_bool
