extends Area2D

@export var questRef: MapQuest
@export var removeTransformation: bool

func _on_body_entered(body):
	if (questRef != null && body is PlayerCharacter):
		if (removeTransformation): RemoveTransformation(body)
		questRef.AdvanceStage(false, false)
		self.queue_free()

func RemoveTransformation(playerRef: PlayerCharacter):
	playerRef.transformationChangeRef.SetNoTransformationExternal()
