class_name ObjectSpawner
extends Node2D

@export var objectToSpawn: String

func SpawnObject():
	if (objectToSpawn != ""):
		var obj_scene = load(objectToSpawn)
		var obj = obj_scene.instantiate()
		obj.global_position = self.global_position
		obj.global_rotation = self.global_rotation
		get_tree().root.get_child(0).add_child(obj)
