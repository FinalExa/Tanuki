class_name WardenController
extends EnemyController

@export var wardenCheck: WardenCheck
@export var wardenAlertArea: WardenAlertArea

func ReadyOperations():
	wardenCheck.wardenAlertArea = wardenAlertArea
	wardenAlertArea.wardenCheck = wardenCheck
	wardenCheck.RemoveArea()
