class_name UIHearts
extends Control

@export var fullHeartsArray: Array[TextureRect]
@export var emptyHeartsArray: Array[TextureRect]

func Refill():
	for i in fullHeartsArray.size():
		fullHeartsArray[i].show()
		emptyHeartsArray[i].hide()

func MakeHeartEmpty(id: int):
	fullHeartsArray[id].hide()
	emptyHeartsArray[id].show()
