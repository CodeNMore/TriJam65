extends Area2D

class_name Planet

onready var planetShapes = $PlanetShapes
onready var exclaim = $Exclaim

var charging = false
var energy = 1.0
var engergyDecreaseRate = 0.08
var chargeRate = 1.0

var disabled = false
var dieTimer = 0.0
var dead = false

func _ready():
	initShape()
	exclaim.visible = false
	
func _physics_process(delta):
	if dead:
		dieTimer += delta
		if dieTimer > 1.2:
			get_parent().remove_child(self)
			queue_free()
		return
		
	if !charging:
		energy -= engergyDecreaseRate * delta
	else:
		energy += chargeRate * delta
		if energy > 1.0:
			energy = 1.0
	planetShapes.modulate.g = 0.1 + energy * 0.9
	planetShapes.modulate.r = 0.1 + (1.0 - energy) * 0.9
	if energy <= 0.0:
		dead = true
		planetShapes.visible = false
		exclaim.visible = false
		$DieParts.emitting = true
		if !disabled:
			Globals.roundDeath()
			Globals.playDeath()
			disabled = true
	elif energy <= 0.4:
		exclaim.visible = true
	else:
		exclaim.visible = false
		
func disable():
	disabled = true
	
func initShape():
	randomize()
	var showIdx = randi() % planetShapes.get_child_count()
	var counter = 0
	for n in planetShapes.get_children():
		n.visible = false
		if counter == showIdx:
			n.visible = true
		counter += 1

func _on_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT):
			Globals.getPlayer().moveTo(self.position)

func _on_Area_area_entered(area):
	if area is Player:
		charging = true

func _on_Area_area_exited(area):
	if area is Player:
		charging = false
