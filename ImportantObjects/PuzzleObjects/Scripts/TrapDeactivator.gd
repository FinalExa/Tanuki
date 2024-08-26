extends PuzzleObject

var trapsInArea: Array[InteractionObject]

func Activation():
	if (get_parent() == null):
		call_deferred("AddChild")

func Deactivation():
	call_deferred("RemoveChild")

func AddChild():
	parentRef.add_child(self)

func RemoveChild():
	RemoveAllTrapsInArea()
	parentRef.remove_child(self)

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
