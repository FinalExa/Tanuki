class_name MultipleDoorManager
extends Node2D

@export var doors: Array[DoorOpenClose]

func OpenAll():
	for i in doors.size():
		doors[i].OpenDoor()

func CloseAll():
	for i in doors.size():
		doors[i].CloseDoor()
