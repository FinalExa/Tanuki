extends TextureRect

@export var noTransformationTexture: Texture2D

func _on_ui_transformation_texture(trsTexturePath):
	if (trsTexturePath != ""):
		var image = Image.new()
		image = load(trsTexturePath)
		self.texture = image
	else:
		self.texture = noTransformationTexture
