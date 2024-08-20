class_name GameplayScene
extends Node2D

@export var playerSpawnPoint: Node2D
@export var travelingAreas: Array[TravelingArea]

func SetPlayerSpawn(playerRef: PlayerCharacter):
	if (playerRef.isTraveling && travelingAreas.size() > 0):
		playerRef.global_position = travelingAreas[playerRef.travelId].spawnLocation.global_position
		return
	playerRef.global_position = playerSpawnPoint.global_position
