class_name PlayerAttack
extends ExecuteAttack

@export var playerRef: PlayerCharacter

func _process(_delta):
	check_for_attack_input()

func check_for_attack_input():
	if (!attackLaunched && Input.is_action_just_pressed("attack") && !characterRef.transformationChangeRef.isTransformed):
		playerRef.playerMovement.DisableMovement()
		start_attack()

func FinalizeAttack():
	playerRef.playerMovement.EnableMovement()
	attackLaunched = false

func StartCooldown():
	attackInCooldown = true
	attackFrame = 0
	playerRef.playerMovement.EnableMovement()
