extends KinematicBody2D

# stats
var score : int = 0
# physics
var speed : int = 200
var jumpForce : int = 700
var gravity : int = 800
var vel : Vector2 = Vector2()
var grounded : bool = false
var lives = 3
# components
onready var sprite = $Sprite


func _physics_process(delta):
	# reset horizontal velocity
	vel.x = 0
	# movement inputs
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
	# gravity
	vel.y += gravity * delta
	# jump input
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	
	# sprite direction
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
		
	collision()

func collision():
	if position.y > 800:
		if lives == 1:
			print("You Died")
			lives -= 1
		elif lives > 0:
			position.y = -72
			position.x = 282
			lives -= 1
	
	
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
