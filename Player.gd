extends KinematicBody2D

const gravity = 20
const acceleration = 50
const maxSpeed = 300
const jumpHeight = -800

var canJump = true;
var jumpWasPressed = false;
var motion = Vector2()
var score = 0;
var lives = 3;

onready var sprite = $AnimatedSprite


func _physics_process(delta):
	
	motion.y += gravity
	var friction = false
	sprite.animation = "walking"
	
	if Input.is_action_pressed("move_left"):
		motion.x = max(motion.x-acceleration, -maxSpeed)
		sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		motion.x = min(motion.x+acceleration, maxSpeed)
		sprite.flip_h = false
	else:
		sprite.animation = "idle"
		friction = true
		
	if is_on_floor():
		canJump = true
		if jumpWasPressed:
			motion.y = jumpHeight
		if friction == true:
			motion.x = lerp(motion.x,0,0.2)
	else:
		coyoteTime()
		if friction == true:
			motion.x = lerp(motion.x,0,0.05)
			
	if Input.is_action_pressed("jump"):
		jumpWasPressed = true
		rememberJump()
		if canJump == true:
			motion.y = jumpHeight
			canJump = false
			
	if Input.is_action_pressed("down"):
		canJump = false
		fall_through()		
	elif Input.is_action_just_released("down"):
		cancel_fall_through()
	
	motion = move_and_slide(motion, Vector2.UP)
	isDead()
	
func coyoteTime():
	yield(get_tree().create_timer(.15),"timeout")
	canJump = false
	
func rememberJump():
	yield(get_tree().create_timer(.1),"timeout")
	jumpWasPressed = false
	
func fall_through():
	if is_on_floor():
		set_collision_mask_bit(1, false)
		
func cancel_fall_through():
	if get_collision_mask_bit(1) == false:
		set_collision_mask_bit(1, true)

func isDead():
	if position.y > 800:
		position.y = -80
		position.x = 200
		print("you died")
