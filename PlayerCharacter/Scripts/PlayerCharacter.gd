class_name PlayerCharacter
extends CharacterBody2D

signal set_body_ref
signal set_temp_trs
signal unset_temp_trs
signal give_self_reference

func _ready():
	emit_signal("set_body_ref", self)

func _on_transformation_object_set_trs_ready(trsName, speed, properties):
	emit_signal("set_temp_trs", trsName, speed, properties)

func _on_transformation_object_set_trs_not_ready():
	emit_signal("unset_temp_trs")

func _on_guard_get_character_ref():
	emit_signal("give_self_reference", self)
