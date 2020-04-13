extends Node2D

onready var startScreen = $CV/StartScreen
onready var planets = $Planets
onready var player = $Player
onready var lblTime = $CV/LblTime
onready var btnStartNext = $CV/BtnStartNext
onready var planetProto = preload("res://Planet.tscn")

var showingStart = true
var roundNum = 0
var roundDeaths = 0
var roundTimeRemaining = 0

func _ready():
	startScreen.visible = true
	showingStart = true
	
func _process(delta):
	if showingStart or btnStartNext.visible:
		return
	
	roundTimeRemaining -= delta
	lblTime.text = str(stepify(roundTimeRemaining, 0.1))
	
	if roundTimeRemaining <= 0.0:
		clearRound()
		btnStartNext.visible = true

func roundDeath():
	roundDeaths += 1
	$CV/LblDeath.text = "Deaths: " + str(roundDeaths) + " / 3"
	if roundDeaths > 3:
		reset()

func placePlanets(numPlanets, minSpacing, maxSpacing):
	var planet = planetProto.instance()
	planet.position.y = -200
	planets.add_child(planet)
	var counter = 1
	# This is probably a sin doing it this way...suuuper inefficient
	# But it was less than 3 hours and late :P
	# Also, at a high enough round #, this will lock up...haha
	while counter < numPlanets:
		var pos = getRandomPos()
		while !isValidPos(pos, minSpacing, maxSpacing):
			pos = getRandomPos()
		planet = planetProto.instance()
		planet.position = pos
		planets.add_child(planet)
		counter += 1
		
func isValidPos(p, minSpacing, maxSpacing):
	var ret = false
	for n in planets.get_children():
		var dst = n.position.distance_to(p)
		if dst >= minSpacing and dst <= maxSpacing:
			ret = true
		elif dst < minSpacing:
			return false
	return ret
		
func getRandomPos():
	return Vector2(rand_range(-2000, 2000),
					rand_range(-2000, 2000))

func generateRound():
	roundNum += 1
	var numPlanets = 6 * sqrt(roundNum / 2.0)
	$CV/LblRound.text = "Round " + str(roundNum) + " (" + str(int(numPlanets) + 1) + " planets)"
	clearRound()
	placePlanets(numPlanets, 175, 325)
	roundTimeRemaining = 20 * sqrt(roundNum / 2.0)
	
func clearRound():
	roundDeaths = 0
	$CV/LblDeath.text = "Deaths: " + str(roundDeaths) + " / 3"
	player.position.x = 0
	player.position.y = 0
	for n in planets.get_children():
		n.disable()
		planets.remove_child(n)
		n.queue_free()
	
func reset():
	showingStart = true
	startScreen.visible = true
	$CV/StartScreen/DiedAlready.visible = true
	clearRound()

func _on_Button_pressed():
	showingStart = false
	startScreen.visible = false
	roundNum = 0
	generateRound()

func _on_BtnStartNext_pressed():
	btnStartNext.visible = false
	generateRound()
