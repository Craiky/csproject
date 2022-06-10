extends Control

onready var player = get_node("/root/MainScene/Player")
onready var scoreText = get_node("ScoreText")

func _process(_delta):
	rect_position.y = -1500
	rect_position.x = 0
	
	if player.position.x-1280 > 0:
		rect_position.x = player.position.x-1280
	
	if player.position.y-750 < -1500:
		rect_position.y = player.position.y-750

func _ready ():
	scoreText.text = "x0"

func set_score_text (score):
	scoreText.text = "x"+str(score)
