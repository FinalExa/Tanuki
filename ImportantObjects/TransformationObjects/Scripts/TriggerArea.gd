extends Area2D

@export var transformationObjectData: TransformationObjectData

func _on_body_entered(body):
	if (body is PlayerCharacter):
		transformationObjectData.RegisterAvailableTransformation(body)

func _on_body_exited(body):
	if (body is PlayerCharacter):
		transformationObjectData.RemoveAvailableTransformation(body)
