extends PuzzleObject

var trapsInArea: Array[InteractionObject]

func Deactivation():
	RemoveAllTrapsInArea()
	self.hide()
	collisionShapeRef.disabled = true

func _on_body_entered(body):
	if (body is InteractionObject && !trapsInArea.has(body)):
		body.activated = false
		trapsInArea.push_back(body)

func _on_area_entered(area):
	if (area is InteractionObject && !trapsInArea.has(area)):
		area.activated = false
		trapsInArea.push_back(area)

func RemoveAllTrapsInArea():
	for i in trapsInArea.size():
		trapsInArea[i].activated = true
	trapsInArea.clear()
