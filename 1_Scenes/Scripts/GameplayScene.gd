class_name GameplayScene
extends Node2D

@export var playerSpawnPoint: Node2D

func SetPlayerSpawn(playerRef: PlayerCharacter):
	playerRef.global_position = playerSpawnPoint.global_position
