extends StaticBody2D

signal set_trs_ready
signal set_trs_notReady

@export var transformedName = ""
@export var transformedMaxSpeed = 0
@export var transformedProperties = []


func _on_trigger_area_set_change_trs_available(status):
	if (status == true):
		emit_signal("set_trs_ready", transformedName, transformedMaxSpeed, transformedProperties)
	else:
		emit_signal("set_trs_notReady")
