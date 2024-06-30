extends TransformationObjectPassive

@export var specialAttackGroup: String
@export var normalAttack: ExecuteAttack
@export var specialAttack: ExecuteAttack
var specialAttackAreas: Array[Area2D]

func _process(delta):
	CheckForAttackInput()

func CheckForAttackInput():
	if (transformationChangeRef.isTransformed && transformationChangeRef.playerRef.playerInputs.attackInput):
		if (specialAttackAreas.size() == 0 && !normalAttack.attackLaunched && !normalAttack.attackInCooldown):
			normalAttack.start_attack()
			return
		if (!specialAttack.attackLaunched && !specialAttack.attackInCooldown):
			specialAttack.start_attack()

func AssignExtraRefs():
	normalAttack.characterRef = characterRef
	specialAttack.characterRef = characterRef

func _on_area_entered(area):
	if (area.is_in_group(specialAttackGroup) && !specialAttackAreas.has(area)):
		specialAttackAreas.push_back(area)

func _on_area_exited(area):
	if (specialAttackAreas.has(area)):
		specialAttackAreas.erase(area)
