extends TransformationObjectPassive

@export var maxHeatValue: float
@export var chargedHeatValue: float
@export var heatIncreasePerSecondPerSource: float
@export var heatDecreasePerSecondPerSource: float
@export var heatGroup: String
@export var heatedProperty: String
var coldProperty: String
var currentHeatValue: float
var nearHeatSources: Array[Node2D]
var teapotWeapon: TransformObjectAttack

func AssignExtraRefs():
	currentHeatValue = 0
	teapotWeapon = transformationChangeRef.currentAttack
	coldProperty = teapotWeapon.attackTag

func _process(delta):
	HeatTeapot(delta)

func HeatTeapot(delta):
	if (transformationChangeRef.isTransformed):
		if (nearHeatSources.size() > 0):
			currentHeatValue = clamp(currentHeatValue + (heatIncreasePerSecondPerSource * delta * nearHeatSources.size()), 0, maxHeatValue)
		else:
			if (nearHeatSources.size() == 0 && currentHeatValue > 0):
				currentHeatValue = clamp(currentHeatValue - (heatDecreasePerSecondPerSource * delta), 0, maxHeatValue)
		if (currentHeatValue > chargedHeatValue):
			ChangeWeaponTag(heatedProperty)
		else:
			ChangeWeaponTag(coldProperty)
	if (!transformationChangeRef.isTransformed && currentHeatValue > 0):
		currentHeatValue = 0
		ChangeWeaponTag(coldProperty)

func ChangeWeaponTag(newTag):
	if (teapotWeapon.attackTag != newTag):
		teapotWeapon.attackTag = newTag
		teapotWeapon.SetAttackTag()

func _on_teapot_weapon_on_attack_end():
	transformationChangeRef.transformationTimer = transformationChangeRef.transformationDuration

func _on_teapot_absorb_heat_body_entered(body):
	if (body.is_in_group(heatGroup) && !nearHeatSources.has(body)):
		nearHeatSources.push_back(body)

func _on_teapot_absorb_heat_body_exited(body):
	if (nearHeatSources.has(body)):
		nearHeatSources.erase(body)
