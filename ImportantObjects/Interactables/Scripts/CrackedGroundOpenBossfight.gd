extends GenericInteractable

@export var captureDuration: float
@export var bossPosition: Node2D
var armorAdded: int = 0
var bossRef: HyottokoBossController
var captureTimer: float

func _process(delta):
	CapturedTimer(delta)

func ExecuteRefEffect(receivedRef):
	if (receivedRef is PlayerCharacter):
		AddArmorPiece(receivedRef)

func AddArmorPiece(playerRef: PlayerCharacter):
	if (playerRef.playerMoveObjects.currentObject is BrokenPartMovable && bossRef != null && armorAdded < bossRef.armorPieces.size()):
		armorAdded += 1
		bossRef.armorPieces[playerRef.playerMoveObjects.currentObject.partID].show()
		playerRef.playerMoveObjects.DeleteLeftoverObject()
		captureTimer = 0
		if (armorAdded == bossRef.armorPieces.size()):
			ExecuteExtraEffect()
			FinalState()
		else:
			bossRef.UnsetCaptured()

func CapturedTimer(delta):
	if (captureTimer > 0):
		if (bossRef.global_position != bossPosition.global_position):
			bossRef.global_position = bossPosition.global_position
		captureTimer -= delta
		if (captureTimer <= 0):
			bossRef.UnsetCaptured()
			bossRef = null

func SetCaptured(hyottokoBoss: HyottokoBossController):
	if (hyottokoBoss.isRepelled):
		bossRef = hyottokoBoss
		captureTimer = captureDuration
		bossRef.SetCaptured()

func _on_capture_boss_area_body_entered(body):
	if (body is HyottokoBossController):
		SetCaptured(body)
