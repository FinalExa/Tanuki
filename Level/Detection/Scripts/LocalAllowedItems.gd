class_name LocalAllowedItems
extends Area2D

@export var allowedObjects: Array[String]
@export var assignedObjects: Array[Node2D]
var playerRef: PlayerCharacter
var playerIsIn: bool

func _process(_delta):
	player_inside_area_checks()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerIsIn = true
	else:
		if (body is TransformationObjectData):
			add_item_to_current_list(body)

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerIsIn = false
		remove_item_from_current_list(playerRef.transformationChangeRef)
	else:
		if (body is TransformationObjectData):
			remove_item_from_current_list(body)

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
		item.set_local_zone(self)
		print(str("Added: ", item.name))

func remove_item_from_current_list(item: Node2D):
	if (assignedObjects.has(item)):
		assignedObjects.erase(item)
		item.unset_local_zone()
		print(str("Removed: ", item.name))

func _on_player_character_give_self_reference(ref):
	playerRef = ref
