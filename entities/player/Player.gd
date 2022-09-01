extends KinematicBody2D


export(int) var SPEED = 20
export(int) var JUMP_FORCE = 20
export(int) var SPEED_DASH = 50
export(int) var GRAVITY = 80
export(int) var GRAVITY_WITH_COAT = 100

var isWithCoat = true
var isFallWithCoat  = false
var isOnFloor = true
var isDash = false
var isJumping = false

var snap = Vector2.ZERO
var velocity = Vector2.ZERO
var floorDirection = Vector2.UP

var n_jumps = 0


func _physics_process(delta):
	velocity = Vector2.ZERO
	
	add_gravity(delta)
	move()
	

func add_gravity(delta):
	velocity.y += delta * GRAVITY

func move():
	snap = Vector2.DOWN * 128 if !isJumping else Vector2.ZERO
	move_and_slide_with_snap(velocity,snap,floorDirection,true)
	
	
