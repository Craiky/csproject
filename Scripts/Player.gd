extends KinematicBody2D

const gravity = 45
const acceleration = 30
const maxSpeed = 800
const jumpHeight = -1550

var canJump = true;
var jumpWasPressed = false;
var motion = Vector2()
var score = 0;
var lives = 3;

onready var ui = get_node("/root/MainScene/UI")

func _process(delta):
	$BetterPlayer.rotation_degrees += 30*delta

func _physics_process(_delta):
	motion.y += gravity
	var friction = false
	var targetSpeed = 0;
	var speedDiff = 0;
	
	if Input.is_action_pressed("move_left"):
		targetSpeed = -maxSpeed
		speedDiff = 1-motion.x/targetSpeed
		motion.x = max(motion.x-acceleration*speedDiff, -maxSpeed)
	elif Input.is_action_pressed("move_right"):
		targetSpeed = maxSpeed
		speedDiff = 1-motion.x/targetSpeed
		motion.x = min(motion.x+acceleration*speedDiff, maxSpeed)
	else:
		friction = true
	
	
		
	if is_on_floor():
		canJump = true
		if jumpWasPressed:
			jump(1)
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
			jump(1)
	
	if Input.is_action_just_released("jump") && motion.y < -100:
		motion.y = -100;
	
	if Input.is_action_pressed("down"):
		canJump = false
		if is_on_floor():
			fall_through()	
	if Input.is_action_just_released("down"):
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
	set_collision_mask_bit(1, false)
		
func cancel_fall_through():
	if get_collision_mask_bit(1) == false:
		set_collision_mask_bit(1, true)

func isDead():
	if position.y > 800:
		lives -= 1
		score = 0
		ui.set_lives_text(lives)
		ui.set_score_text(score)
		if lives == -1:
			get_tree().change_scene("res://UI/Lose.tscn")
		position.x = 601
		position.y = -667

func collect_coin(value):
	score += value
	ui.set_score_text(score)
	
func jump(value):
	motion.y = jumpHeight*value
	canJump = false
