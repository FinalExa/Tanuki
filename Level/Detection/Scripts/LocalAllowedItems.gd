extends Area2D

signal check_if_object
signal check_if_object_exit

@export var allowedObjects: Array[String]
@export var assignedObjects: Array[Node2D]
var playerRef: PlayerCharacter
var playerIsIn: bool

func _process(delta):
	player_inside_area_checks()

func _on_body_entered(body):
	if (body == playerRef):
		playerIsIn = true
	else:
		emit_signal("check_if_object", body)

func _on_body_exited(body):
	if (body == playerRef):
		playerIsIn = false
		remove_item_from_current_list(playerRef.transformationChangeRef)
	else:
		emit_signal("check_if_object_exit", body)

func player_inside_area_checks():
	if (playerIsIn == true):
		if (playerRef.transformationChangeRef.isTransformed == true):
			add_item_to_current_list(playerRef.transformationChangeRef)
		else:
			if (playerRef.transformationChangeRef.isTransformed == false):
				remove_item_from_current_list(playerRef.transformationChangeRef)

func add_item_to_current_list(item: Node2D):
	if (!assignedObjects.has(item)):
		assignedObjects.push_back(item)
		print(str("Added: ", item.name))

func remove_item_from_current_list(item: Node2D):
	if (assignedObjects.has(item)):
		assignedObjects.erase(item)
		print(str("Removed: ", item.name))

func _on_player_character_give_self_reference(ref):
	playerRef = ref

func _on_transformation_object_confirm_to_be_sent(receivedObj: Node2D):
	add_item_to_current_list(receivedObj)

func _on_transformation_object_2_confirm_to_be_sent_exit(receivedObj: Node2D):
	remove_item_from_current_list(receivedObj)


func _on_transformation_object_confirm_to_be_sent_exit():
	pass # Replace with function body.
