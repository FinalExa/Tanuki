extends Area2D

@export var dirtyFloorInteractable: GenericInteractable

var playerRef: PlayerCharacter
var hitboxesInRange: Array[ObjectAttackHitbox]

func _process(_delta):
	CheckForRightTransformationTag()
	HitboxesInRange()

func CheckForRightTransformationTag():
	if (playerRef != null): 
		if (playerRef.transformationChangeRef.isTransformed):
			var selectedProperty: String
			for i in playerRef.transformationChangeRef.currentTransformationObject.transformedProperties.size():
				if (dirtyFloorInteractable.neededProperties.has(playerRef.transformationChangeRef.currentTransformationObject.transformedProperties[i])):
					selectedProperty = playerRef.transformationChangeRef.currentTransformationObject.transformedProperties[i]
					break
			if (selectedProperty != ""):
				dirtyFloorInteractable.AttackInteraction(selectedProperty)
				return
			else:
				playerRef.transformationChangeRef.transformationActivation.DeactivateTransformation()
		playerRef.transformationChangeRef.SetNoTransformationExternal()

func HitboxesInRange():
	for i in hitboxesInRange.size():
		if (hitboxesInRange[i].activated && hitboxesInRange[i].attackTag != ""):
			dirtyFloorInteractable.AttackInteraction(hitboxesInRange[i].attackTag)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null

func _on_area_entered(area):
	if (area is ObjectAttackHitbox && !hitboxesInRange.has(area)):
		hitboxesInRange.push_back(area)

func _on_area_exited(area):
	if (area is ObjectAttackHitbox && hitboxesInRange.has(area)):
		hitboxesInRange.erase(area)
