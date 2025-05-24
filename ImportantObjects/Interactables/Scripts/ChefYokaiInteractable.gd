class_name ChefYokaiInteractable
extends GenericInteractable

@export var acceptedColdFoods: Array[String]
@export var coldFoodSprites: Array[Texture]
@export var acceptedHotFoods: Array[String]
@export var hotFoodSprites: Array[Texture]
@export var coldFoodRequest: Sprite2D
@export var hotFoodRequest: Sprite2D
var selectedColdFood: String
var selectedHotFood: String

func ReadyOperations():
	SelectFoods()

func SelectFoods():
	selectedColdFood = acceptedColdFoods[randi_range(0, acceptedColdFoods.size() - 1)]
	selectedHotFood = acceptedHotFoods[randi_range(0, acceptedHotFoods.size() - 1)]
