class_name LocalAllowedItems
extends Area2D

@export var allowedObjects: Array[String]
var feedbacks: Array[LocalAllowedItemsFeedback]
var assignedObjects: Array[Node2D]
var playerRef: PlayerCharacter
var playerIsIn: bool

func _ready():
	AssignChildFeedbacks()
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
		if (playerRef.transformationChangeRef.isTransformed == true):
			AddItemToList(playerRef.transformationChangeRef)
		else:
			if (playerRef.transformationChangeRef.isTransformed == false):
				RemoveItemFromList(playerRef.transformationChangeRef)

func AssignChildFeedbacks():
	feedbacks.clear()
	for i in self.get_child_count():
		if (self.get_child(i) is LocalAllowedItemsFeedback):
			feedbacks.push_back(self.get_child(i))

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
		item.UnsetLocalZone()

func _on_player_character_give_self_reference(ref):
	playerRef = ref

func ActivateFeedbacks():
	for i in feedbacks.size():
		feedbacks[i].ActivateFeedback()

func DeactivateFeedbacks():
	for i in feedbacks.size():
		feedbacks[i].DeactivateFeedback()
