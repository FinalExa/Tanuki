class_name Firefly
extends Area2D

@export var fireflyTag: String
@export var lifeDuration: float
@export var timerFeedback: TextureProgressBar
@export var timerMultiplier: float
var playerRef: PlayerCharacter
var originalSceneRef: Node2D
var originalRotation: float
var lifeTimer: float
var lifeTimerActive: bool
var containersInArea: Array[FireflyObjectContainer]

func _process(delta):
	LifeTimer(delta)
	KeepOriginalRotation()

func SetOriginalRotation():
	originalRotation = self.global_rotation_degrees

func KeepOriginalRotation():
	if (self.global_rotation_degrees != originalRotation):
		self.global_rotation_degrees = originalRotation

func ActivateLifeTimer():
	lifeTimer = lifeDuration
	lifeTimerActive = true
	timerFeedback.max_value = lifeDuration * timerMultiplier
	timerFeedback.value = timerFeedback.max_value
	timerFeedback.show()

func DeactivateLifeTimer():
	lifeTimerActive = false
	timerFeedback.hide()

func LifeTimer(delta):
	if (lifeTimerActive):
		if (lifeTimer > 0):
			lifeTimer -= delta
			timerFeedback.value = lifeTimer * timerMultiplier
			return
		timerFeedback.value = 0
		EndFirefly()

func EndFirefly():
	ReleaseBeforeDelete()
	self.queue_free()

func ReleaseBeforeDelete():
	var i: int = containersInArea.size() - 1
	if (i >= 0):
		while i >= 0:
			if (containersInArea[i] != null):
				containersInArea[i].UnregisterFirefly(self)
			containersInArea.remove_at(i)
			i -= 1

func _on_area_entered(area):
	if (area is FireflyObjectContainer && !containersInArea.has(area)):
		containersInArea.push_back(area)
		area.RegisterFirefly(self)

func _on_area_exited(area):
	if (area is FireflyObjectContainer && containersInArea.has(area)):
		containersInArea.erase(area)
		area.UnregisterFirefly(self)

func _on_body_entered(body):
	if (body is GenericInteractable):
		if (body.neededProperties.has(fireflyTag)):
			body.AttackInteraction(fireflyTag)
			EndFirefly()
