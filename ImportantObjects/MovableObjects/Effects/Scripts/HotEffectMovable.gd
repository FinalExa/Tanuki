extends Area2D

@export var movableRef: MovableObject
@export var hotDuration: float
@export var newTags: Array[String]
@export var effectGraphics: Sprite2D
@export var progressBar: TextureProgressBar
@export var barMultiplier: float
@export var heatSourceGroup: String
var heatSourcesInArea: Array[Node2D]
var oldTags: Array[String]
var hotTimer: float

func _ready():
	StartupOldTags()
	StartupTimer()

func _process(delta):
	CheckForHeatSourcesAndExecuteTimer(delta)

func StartupOldTags():
	oldTags.clear()
	for i in movableRef.movableObjectProperties.size():
		oldTags.push_back(movableRef.movableObjectProperties[i])

func StartupTimer():
	hotTimer = 0
	progressBar.value = 0
	progressBar.max_value = hotDuration * barMultiplier
	effectGraphics.hide()
	progressBar.hide()

func SetTagsToMovable(tags: Array[String]):
	movableRef.movableObjectProperties = tags

func SetTimerToMax():
	hotTimer = hotDuration
	progressBar.value = hotTimer * barMultiplier
	effectGraphics.show()
	SetTagsToMovable(newTags)

func CheckForHeatSourcesAndExecuteTimer(delta):
	if (hotTimer < hotDuration && heatSourcesInArea.size() > 0):
		SetTimerToMax()
		return
	if (hotTimer > 0):
		hotTimer -= delta
		progressBar.value = hotTimer * barMultiplier
		if (hotTimer <= 0):
			hotTimer = 0
			progressBar.value = 0
			effectGraphics.hide()
			SetTagsToMovable(oldTags)

func _on_body_entered(body):
	if (body.is_in_group(heatSourceGroup)):
		heatSourcesInArea.push_back(body)

func _on_body_exited(body):
	if (heatSourcesInArea.has(body)):
		heatSourcesInArea.erase(body)

func OnAttach():
	progressBar.show()

func OnAttachEnd():
	progressBar.hide()

func OnForceDetach():
	StartupTimer()
	SetTagsToMovable(oldTags)
