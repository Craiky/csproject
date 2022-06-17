extends KinematicBody2D

const gravity = 30
const maxSpeed = 300

var velocity = Vector2()
export var dir = -1 #  -1 = left, 1 = right, 0 = no move
export var hasG = true

onready var ui = get_node("/root/MainScene/UI")

func _ready():
	$ray.position.x = $CollisionShape2D.shape.get_extents().x*dir

func _physics_process(_delta):
	
	if is_on_wall() || !$ray.is_colliding() && is_on_floor():
		dir *= -1
		$ray.position.x = $CollisionShape2D.shape.get_extents().x*dir
	
	if hasG:
		velocity.y += gravity
	
	velocity.x = maxSpeed*dir
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.jump(0.7)
		body.collect_coin(10)
		dir =0
		hasG = true
		scale.y = 0.01
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(2, false)
		$Area2D.set_collision_layer_bit(2, false)
		$Area2D.set_collision_mask_bit(2, false)
		$damage.set_collision_layer_bit(2, false)
		$damage.set_collision_mask_bit(2, false)
		yield(get_tree().create_timer(5),"timeout")
		queue_free()


func _on_damage_body_entered(body):
	if body.name == "Player":
		body.lives -= 1
		body.score = 0
		ui.set_lives_text(body.lives)
		ui.set_score_text(body.score)
		if body.lives == -1:
			get_tree().change_scene("res://UI/Lose.tscn")
		body.position.x = 601
		body.position.y = -667
		
