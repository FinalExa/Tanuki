class_name UIHearts
extends Control

@export var fullHeartsArray: Array[TextureRect]
@export var emptyHeartsArray: Array[TextureRect]
@export var upgradeFullHeart: TextureRect
@export var upgradeEmptyHeart: TextureRect

func Refill():
	for i in fullHeartsArray.size():
		fullHeartsArray[i].show()
		emptyHeartsArray[i].hide()

func MakeHeartEmpty(id: int):
	fullHeartsArray[id].hide()
	emptyHeartsArray[id].show()

func AddExtraHearts():
	if (!fullHeartsArray.has(upgradeFullHeart)):
		fullHeartsArray.push_back(upgradeFullHeart)
	if (!emptyHeartsArray.has(upgradeEmptyHeart)):
		emptyHeartsArray.push_back(upgradeEmptyHeart)

func RemoveExtraHearts():
	upgradeFullHeart.hide()
	if (fullHeartsArray.has(upgradeFullHeart)):
		fullHeartsArray.erase(upgradeFullHeart)
	upgradeEmptyHeart.hide()
	if (emptyHeartsArray.has(upgradeEmptyHeart)):
		emptyHeartsArray.erase(upgradeEmptyHeart)
