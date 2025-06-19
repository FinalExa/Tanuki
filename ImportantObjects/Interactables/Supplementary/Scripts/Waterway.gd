class_name Waterway
extends Node2D

@export var objectsToFill: Array[Node2D]
var currentFillers: Array[Node2D]
var activated: bool

func _ready():
	self.hide()

func Activate():
	if (currentFillers.size() > 0 && !activated):
		self.show()
		activated = true
		FillObjects()

func Deactivate():
	if (currentFillers.size() == 0 && activated):
		self.hide()
		activated = false
		RemoveFillObjects()

func AddFiller(filler):
	if (!currentFillers.has(filler)):
		currentFillers.push_back(filler)
		Activate()

func RemoveFiller(filler):
	if (currentFillers.has(filler)):
		currentFillers.erase(filler)
		Deactivate()

func FillObjects():
	for i in objectsToFill.size():
		objectsToFill[i].GetFilled(self)

func RemoveFillObjects():
	for i in objectsToFill.size():
		objectsToFill[i].GetUnfilled(self)
