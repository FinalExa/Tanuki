extends GenericInteractable

@export var captureDuration: float


func _on_capture_boss_area_body_entered(body):
	if (body is Hyottoko)
