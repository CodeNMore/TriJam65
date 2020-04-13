extends Area2D

class_name Player

onready var spr = $Sprite
var scaleAnim = 0.0
var animThresh = 0.2
var animDir = 1

var moveTo = null

func _ready():
	pass
	
func _physics_process(delta):
	scaleAnim += delta * animDir * 0.5
	if scaleAnim > animThresh:
		animDir = -1
	elif scaleAnim < -animThresh:
		animDir = 1
	spr.scale.y = 1.0 + scaleAnim
	
	if moveTo != null:
		var lerpSpd = 0.15
		if position.distance_to(moveTo) < 20.0:
			lerpSpd = 0.3
		position = lerp(position, moveTo, lerpSpd)
		if position.distance_to(moveTo) < 1.0:
			moveTo = null

func moveTo(p):
	if moveTo == null:
		moveTo = p
		Globals.playJump()
