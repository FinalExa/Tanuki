extends Node2D

signal transformation_name
signal timer_value


func _on_transformation_change_send_transformation_name(trsName):
	emit_signal("transformation_name", trsName)


func _on_transformation_change_send_transformation_active_info(status, timer, duration):
	emit_signal("timer_value", status, timer, duration)# Replace with function body.
