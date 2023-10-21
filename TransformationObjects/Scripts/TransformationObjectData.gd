class_name  TransformationObjectData
extends StaticBody2D

signal set_trs_ready
signal set_trs_notReady
signal confirm_to_be_sent
signal confirm_to_be_sent_exit

@export var transformedName: String
@export var transformedMaxSpeed: float
@export var transformedProperties: Array[String]

func _on_trigger_area_set_change_trs_available(status):
	if (status == true):
		emit_signal("set_trs_ready", transformedName, transformedMaxSpeed, transformedProperties)
	else:
		emit_signal("set_trs_notReady")


func _on_local_allowed_items_check_if_object(body: Node2D):
	if (body == self):
		emit_signal("confirm_to_be_sent", self)


func _on_local_allowed_items_check_if_object_exit(body: Node2D):
	if (body == self):
		emit_signal("confirm_to_be_sent_exit", self)
