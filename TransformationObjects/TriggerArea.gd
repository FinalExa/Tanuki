extends Area2D

var  playerIsIn

func _ready():
	print(playerIsIn)

func _on_body_entered(body):
	playerIsIn = true
	print(playerIsIn)

func _on_body_exited(body):
	playerIsIn = false
	print(playerIsIn)
