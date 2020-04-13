extends Node

onready var root = $"/root/"
onready var audJump: AudioStreamPlayer = $"/root/".find_node("Audio", true, false).find_node("Jump", true, false)
onready var audDeath: AudioStreamPlayer = $"/root/".find_node("Audio", true, false).find_node("Die", true, false)

func getPlayer() -> Player:
	return root.find_node("Player", true, false)

func roundDeath():
	root.find_node("Main", true, false).roundDeath()

func playJump():
	audJump.playing = true

func playDeath():
	audDeath.playing = true
