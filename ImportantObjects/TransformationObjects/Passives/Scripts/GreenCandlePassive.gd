extends TransformationObjectPassive

@export var fireflySpot: Node2D
@export var fireflyHouseGroupName: String
var fireflyRef: String = "res://ImportantObjects/Interactables/Supplementary/firefly.tscn"
var currentFirefly: Firefly
var isGenerating: bool
var isAttachingOrDetaching: bool
var firefliesAround: Array[Firefly]
var fireflyHousesAround: Array[Node2D]

func _process(_delta):
	GreenCandleOperations()

func GreenCandleOperations():
	if (transformationChangeRef.isTransformed):
		if (currentFirefly == null && !isGenerating && !isAttachingOrDetaching):
			CheckForFireflies()
		return
	if (currentFirefly != null && !isAttachingOrDetaching):
		isAttachingOrDetaching = true
		call_deferred("DetachFirefly")

func CheckForFireflies():
	if (firefliesAround.size() > 0):
		FireflyAttachCheck()
		return
	if (fireflyHousesAround.size() > 0):
		isGenerating = true
		call_deferred("GenerateFirefly")

func FireflyAttachCheck():
	if (firefliesAround.size() == 1):
		isAttachingOrDetaching = true
		call_deferred("AttachFirefly", firefliesAround[0])
		return
	var lowestDistance: float
	var lowestDistanceId: int = 0
	for i in firefliesAround.size():
		var distance: float = self.global_position.distance_to(firefliesAround[i].global_position)
		if (i == 0):
			lowestDistance = distance
			continue
		if (distance < lowestDistance):
			lowestDistance = distance
			lowestDistanceId = i
	isAttachingOrDetaching = true
	call_deferred("AttachFirefly", firefliesAround[lowestDistanceId])

func AttachFirefly(firefly: Firefly):
	currentFirefly = firefly
	currentFirefly.global_position = fireflySpot.global_position
	currentFirefly.reparent(self)
	currentFirefly.DeactivateLifeTimer()
	currentFirefly.playerRef = characterRef
	isAttachingOrDetaching = false

func DetachFirefly():
	currentFirefly.reparent(currentFirefly.originalSceneRef)
	currentFirefly.ActivateLifeTimer()
	currentFirefly.playerRef = null
	currentFirefly = null
	isAttachingOrDetaching = false

func GenerateFirefly():
	currentFirefly = load(fireflyRef).instantiate()
	currentFirefly.originalSceneRef = get_tree().root.get_child(0).sceneSelector.currentScene
	currentFirefly.SetOriginalRotation()
	characterRef.add_child(currentFirefly)
	currentFirefly.global_position = fireflySpot.global_position
	isGenerating = false

func _on_body_entered(body):
	if (body.is_in_group(fireflyHouseGroupName) && !fireflyHousesAround.has(body)):
		fireflyHousesAround.push_back(body)

func _on_body_exited(body):
	if (body.is_in_group(fireflyHouseGroupName) && fireflyHousesAround.has(body)):
		fireflyHousesAround.erase(body)

func _on_area_entered(area):
	if (area is Firefly && !firefliesAround.has(area)):
		firefliesAround.push_back(area)

func _on_area_exited(area):
	if (area is Firefly && firefliesAround.has(area)):
		firefliesAround.erase(area)
