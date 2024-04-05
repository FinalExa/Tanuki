extends Area2D

@export var transformation_object_data: TransformationObjectData

func _on_body_entered(body):
	if (body is PlayerCharacter):
		transformation_object_data.set_change_trs_available(true, body)

func _on_body_exited(body):
	if (body is PlayerCharacter):
		transformation_object_data.set_change_trs_available(false, body)
