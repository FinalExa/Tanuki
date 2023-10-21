extends Area2D

signal check_if_object

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
		remove_player_from_current_list()

func player_inside_area_checks():
	if (playerIsIn == true):
		if (playerRef.transformationChangeRef.isTransformed == true && !assignedObjects.has(playerRef.transformationChangeRef)):
			add_player_to_current_list()
		else:
			if (playerRef.transformationChangeRef.isTransformed == false && assignedObjects.has(playerRef.transformationChangeRef)):
				remove_player_from_current_list()

func add_player_to_current_list():
	assignedObjects.push_back(playerRef.transformationChangeRef)
	print("Added Player")

func remove_player_from_current_list():
	assignedObjects.erase(playerRef.transformationChangeRef)
	print("Removed Player")

func _on_player_character_give_self_reference(ref):
	playerRef = ref


func _on_transformation_object_confirm_to_be_sent(receivedObj):
	print(receivedObj.name)
