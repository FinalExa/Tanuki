extends Label

@export var transformationChosenText: String

func _on_ui_transformation_name(trsName):
	self.text = str(transformationChosenText, trsName)
