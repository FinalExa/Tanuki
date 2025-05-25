class_name ChefYokaiInteractable
extends GenericInteractable

@export var acceptedColdFoods: Array[String]
@export var coldFoodSprites: Array[Texture]
@export var acceptedHotFoods: Array[String]
@export var hotFoodSprites: Array[Texture]
@export var coldFoodRequest: Sprite2D
@export var coldFoodSprite: Sprite2D
@export var hotFoodRequest: Sprite2D
@export var hotFoodSprite: Sprite2D
var selectedColdFood: String
var selectedHotFood: String
var gotColdFood: bool
var gotHotFood: bool
var done: bool

func ReadyOperations():
	SelectFoods()

func SelectFoods():
	var randomColdInt: int = randi_range(0, acceptedColdFoods.size() - 1)
	selectedColdFood = acceptedColdFoods[randomColdInt]
	coldFoodSprite.texture = coldFoodSprites[randomColdInt]
	var randomHotInt: int = randi_range(0, acceptedHotFoods.size() - 1)
	selectedHotFood = acceptedHotFoods[randomHotInt]
	hotFoodSprite.texture = hotFoodSprites[randomHotInt]

func ExecuteRefEffect(receivedRef):
	if (receivedRef is PlayerCharacter && !done):
		CheckForRightMovable(receivedRef)

func CheckForRightMovable(playerRef: PlayerCharacter):
	var movableRef: MovableObject = playerRef.playerMoveObjects.currentObject
	if (selectedColdFood == movableRef.movableObjectName && !gotColdFood):
		playerRef.playerMoveObjects.DeleteLeftoverObject()
		coldFoodRequest.hide()
		gotColdFood = true
	if (selectedHotFood == movableRef.movableObjectName && !gotHotFood):
		playerRef.playerMoveObjects.DeleteLeftoverObject()
		hotFoodRequest.hide()
		gotHotFood = true
	if (gotColdFood && gotHotFood):
		ExecuteExtraEffect()
		FinalState()
		done = true
