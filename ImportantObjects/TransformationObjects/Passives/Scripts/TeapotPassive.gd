extends TransformationObjectPassive

@export var maxHeatValue: float
@export var chargedHeatValue: float
@export var heatIncreasePerSecondPerSource: float
@export var heatDecreasePerSecondPerSource: float
@export var heatGroup: String
@export var heatedProperty: String
@export var heatedSprite: Sprite2D
@export var heatedAttackColor: Color
@export var coldAttackColor: Color
var attackHitboxSprites: Array[AnimatedSprite2D]
var coldProperty: String
var currentHeatValue: float
var nearHeatSources: Array[Node2D]
var teapotWeapon: TransformObjectAttack

func AssignExtraRefs():
	currentHeatValue = 0
	teapotWeapon = transformationChangeRef.currentAttack
	coldProperty = teapotWeapon.attackTag
	GetAttackHitboxSprites()
	SetAttackHitboxSprites(coldAttackColor)

func ReadyOperations():
	heatedSprite.hide()

func _process(delta):
	HeatTeapot(delta)

func HeatTeapot(delta):
	if (transformationChangeRef.isTransformed):
		if (nearHeatSources.size() > 0):
			currentHeatValue = clamp(currentHeatValue + (heatIncreasePerSecondPerSource * delta * nearHeatSources.size()), 0, maxHeatValue)
		else:
			if (nearHeatSources.size() == 0 && currentHeatValue > 0):
				currentHeatValue = clamp(currentHeatValue - (heatDecreasePerSecondPerSource * delta), 0, maxHeatValue)
		if (currentHeatValue > chargedHeatValue): TeapotIsHot()
		else: TeapotIsCold()
	else:
		if (heatedSprite.visible):
			heatedSprite.hide()
	if (!transformationChangeRef.isTransformed && currentHeatValue > 0):
		currentHeatValue = 0
		ChangeWeaponTag(coldProperty)

func TeapotIsHot():
	if (!heatedSprite.visible):
		heatedSprite.show()
	heatedSprite.global_rotation_degrees = characterRef.global_rotation_degrees
	heatedSprite.flip_h = transformationChangeRef.transformationSprite.flip_h
	ChangeWeaponTag(heatedProperty)

func TeapotIsCold():
	if (heatedSprite.visible):
		heatedSprite.hide()
	ChangeWeaponTag(coldProperty)

func ChangeWeaponTag(newTag):
	if (teapotWeapon.attackTag != newTag):
		teapotWeapon.attackTag = newTag
		teapotWeapon.SetAttackTag()
		if (newTag == heatedProperty):
			SetAttackHitboxSprites(heatedAttackColor)
			return
		SetAttackHitboxSprites(coldAttackColor)

func GetAttackHitboxSprites():
	for i in teapotWeapon.attackHitboxes.size():
		if (teapotWeapon.attackHitboxes[i] is ObjectAttackHitbox):
			for y in teapotWeapon.attackHitboxes[i].get_child_count():
				if (teapotWeapon.attackHitboxes[i].get_child(y) is AnimatedSprite2D):
					attackHitboxSprites.push_back(teapotWeapon.attackHitboxes[i].get_child(y))

func SetAttackHitboxSprites(color: Color):
	for i in attackHitboxSprites.size():
		attackHitboxSprites[i].modulate = color

func _on_teapot_weapon_on_attack_end():
	transformationChangeRef.transformationTimer = transformationChangeRef.transformationDuration

func _on_teapot_absorb_heat_body_entered(body):
	if (body.is_in_group(heatGroup) && !nearHeatSources.has(body)):
		nearHeatSources.push_back(body)

func _on_teapot_absorb_heat_body_exited(body):
	if (nearHeatSources.has(body)):
		nearHeatSources.erase(body)
