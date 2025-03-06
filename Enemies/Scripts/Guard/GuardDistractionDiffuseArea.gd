class_name GuardDistractionDiffuseArea
extends Area2D

var activated: bool
var guardDistraction: GuardDistraction
var guardsInArea: Array[GuardController]
var activatedGuardsInArea: Array[GuardController]

func _ready():
	DeactivateDiffuseArea()

func _process(_delta):
	CallOtherGuards()

func CallOtherGuards():
	if (activated && guardsInArea.size() > 0):
		for i in guardsInArea.size():
			if (!activatedGuardsInArea.has(guardsInArea[i])):
				if (guardsInArea[i].guardDistraction.isDistracted):
					activatedGuardsInArea.push_back(guardsInArea)
				else:
					guardsInArea[i].guardDistraction.SetClosestDistractionSource(guardDistraction.closestSource)
					guardsInArea[i].guardDistraction.StartDistracted()
					activatedGuardsInArea.push_back(guardsInArea)

func ActivateDiffuseArea():
	activated = true
	show()

func DeactivateDiffuseArea():
	activatedGuardsInArea.clear()
	activated = false
	hide()

func _on_body_entered(body):
	if (body is GuardController && body != guardDistraction.guardController && !guardsInArea.has(body)):
		guardsInArea.push_back(body)

func _on_body_exited(body):
	if (body is GuardController):
		if (guardsInArea.has(body)):
			guardsInArea.erase(body)
		if (activatedGuardsInArea.has(body)):
			activatedGuardsInArea.erase(body)
