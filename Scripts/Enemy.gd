extends KinematicBody2D

const gravity = 30
const maxSpeed = 400

var velocity = Vector2()
export var dir = -1 #  -1 = left, 1 = right

func _ready():
	$ray.position.x = $CollisionShape2D.shape.get_extents().x*dir

func _physics_process(_delta):
	velocity.y += gravity
	
	velocity.x = maxSpeed*dir
		
	if is_on_wall() || !$ray.is_colliding() && is_on_floor():
		dir *= -1
		$ray.position.x = $CollisionShape2D.shape.get_extents().x*dir
	
	velocity = move_and_slide(velocity,Vector2.UP)
