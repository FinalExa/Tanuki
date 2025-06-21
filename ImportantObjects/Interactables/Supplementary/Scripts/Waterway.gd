class_name Waterway
extends Node2D

@export var objectsToFill: Array[Node2D]
var currentFillers: Array[Node2D]
var waterwayComponents: Array[WaterwayComponent]
var activated: bool

func _ready():
	GetComponents()

func GetComponents():
	waterwayComponents.clear()
	for i in self.get_child_count():
		if (self.get_child(i) is WaterwayComponent && !waterwayComponents.has(self.get_child(i))):
			waterwayComponents.push_back(self.get_child(i))
			get_child(i).SetNoWater()

func ActivateComponents():
	for i in waterwayComponents.size():
		waterwayComponents[i].SetWater()

func DeactivateComponents():
	for i in waterwayComponents.size():
		waterwayComponents[i].SetNoWater()

func Activate():
	if (currentFillers.size() > 0 && !activated):
		ActivateComponents()
		activated = true
		FillObjects()

func Deactivate():
	if (currentFillers.size() == 0 && activated):
		DeactivateComponents()
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
