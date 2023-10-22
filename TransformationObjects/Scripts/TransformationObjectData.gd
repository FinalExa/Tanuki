class_name  TransformationObjectData
extends StaticBody2D

signal set_trs_ready
signal set_trs_notReady

@export var transformedName: String
@export var transformedMaxSpeed: float
@export var transformedProperties: Array[String]

var localAllowedItemsRef: LocalAllowedItems

func _on_trigger_area_set_change_trs_available(status):
	if (status == true):
		emit_signal("set_trs_ready", transformedName, transformedMaxSpeed, transformedProperties)
	else:
		emit_signal("set_trs_notReady")

func set_local_zone(localRef: LocalAllowedItems):
	localAllowedItemsRef = localRef

func unset_local_zone():
	localAllowedItemsRef = null
