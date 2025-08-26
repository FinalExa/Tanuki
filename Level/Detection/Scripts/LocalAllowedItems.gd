class_name LocalAllowedItems
extends Area2D

@export var allowedObjects: Array[String]
var assignedObjects: Array[Node2D]
var playerRef: PlayerCharacter
var playerIsIn: bool

func _ready():
	DeactivateFeedbacks()
	AssignToGameplayScene()

func _process(_delta):
	player_inside_area_checks()

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body
		playerIsIn = true
	else:
		if (body is TransformationObjectData):
			AddItemToList(body)

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerIsIn = false
		RemoveItemFromList(playerRef.transformationChangeRef)
	else:
		if (body is TransformationObjectData):
			RemoveItemFromList(body)

func player_inside_area_checks():
	if (playerIsIn == true):
		if (playerRef.transformationChangeRef.isTransformed):
			AddItemToList(playerRef.transformationChangeRef)
		else:
			if (!playerRef.transformationChangeRef.isTransformed):
				RemoveItemFromList(playerRef.transformationChangeRef)

func AssignToGameplayScene():
	var sceneMaster: SceneMaster = get_tree().root.get_child(0)
	sceneMaster.sceneSelector.currentScene.localAllowedItems.push_back(self)

func AddItemToList(item: Node2D):
	if (!assignedObjects.has(item)):
		assignedObjects.push_back(item)
		item.SetLocalZone(self)

func RemoveItemFromList(item: Node2D):
	if (assignedObjects.has(item)):
		assignedObjects.erase(item)
		if (item is TransformationChange):
			item.UnsetLocalZone(self)
			return
		item.UnsetLocalZone()

func _on_player_character_give_self_reference(ref):
	playerRef = ref

func ActivateFeedbacks():
	self.show()

func DeactivateFeedbacks():
	self.hide()
