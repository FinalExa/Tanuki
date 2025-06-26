class_name CleanerBossRotator
extends EnemyRotator

var playerRef: PlayerCharacter

func _ready():
	playerRef = get_tree().root.get_child(0).playerRef

func LookAtTarget(delta):
	execute_rotation(playerRef.global_position, delta)
