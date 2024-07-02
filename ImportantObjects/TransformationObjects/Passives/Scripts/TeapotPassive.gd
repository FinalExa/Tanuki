extends TransformationObjectPassive

@export var teapotWeapon: ExecuteAttack
@export var teapotAura: TeapotAura
@export var maxHeatValue: float
@export var chargedHeatValue: float
@export var heatIncreasePerSecondPerSource: float
@export var heatDecreasePerSecondPerSource: float
@export var heatGroup: String
var currentHeatValue: float
var nearHeatSources: Array[Node2D]

func AssignExtraRefs():
	teapotWeapon.characterRef = characterRef
	currentHeatValue = 0

func _process(delta):
	SetPlayerInvulnerable()
	CheckForAttackInput()
	HeatTeapot(delta)

func CheckForAttackInput():
	if (transformationChangeRef.isTransformed && characterRef.playerInputs.attackInput && !teapotWeapon.attackLaunched):
		teapotWeapon.start_attack()

func SetPlayerInvulnerable():
	if (transformationChangeRef.isTransformed && !transformationChangeRef.playerRef.transformationInvincibility):
		transformationChangeRef.playerRef.transformationInvincibility = true

func HeatTeapot(delta):
	if (transformationChangeRef.isTransformed):
		if (nearHeatSources.size() > 0):
			currentHeatValue = clamp(currentHeatValue + (heatIncreasePerSecondPerSource * delta * nearHeatSources.size()), 0, maxHeatValue)
			if (!teapotAura.auraActive && currentHeatValue >= chargedHeatValue): teapotAura.SetAuraActive()
			if (currentHeatValue >= maxHeatValue): characterRef.ForceGameOver()
		else:
			if (nearHeatSources.size() == 0 && currentHeatValue > 0):
				currentHeatValue = clamp(currentHeatValue - (heatDecreasePerSecondPerSource * delta), 0, maxHeatValue)
				if (!teapotAura.auraActive && currentHeatValue >= chargedHeatValue): teapotAura.UnsetAuraActive()
	if (!transformationChangeRef.isTransformed && currentHeatValue > 0):
		currentHeatValue = 0
		teapotAura.UnsetAuraActive()

func TransformationInvincibilityInteracted(receivedNode: Node2D):
	if (!teapotWeapon.attackLaunched):
		characterRef.playerRotator._on_movement_movement_direction(receivedNode.global_position.direction_to(characterRef.global_position))
		teapotWeapon.start_attack()

func _on_teapot_weapon_on_attack_end():
	transformationChangeRef.transformationTimer = transformationChangeRef.transformationDuration

func _on_teapot_absorb_heat_body_entered(body):
	if (body.is_in_group(heatGroup) && !nearHeatSources.has(body)):
		nearHeatSources.push_back(body)

func _on_teapot_absorb_heat_body_exited(body):
	if (nearHeatSources.has(body)):
		nearHeatSources.erase(body)
