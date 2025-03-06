extends InteractionObjectEffect

@export var playerSpeedWhileCaptured: float
@export var callGuardHitbox: CallGuardHitbox
var playerHasBeenMoved: bool = false
var playerHasBeenCaptured: bool = false
var hitboxActive: bool = false

func _ready():
	remove_call_hitbox()

func execute_effect_normally(receivedBody, _delta):
	if (receivedBody is PlayerCharacter):
		SlowAndKeepToCenter(receivedBody)

func SlowAndKeepToCenter(playerRef: PlayerCharacter):
	if (!hitboxActive):
		add_call_hitbox()
	if (!playerHasBeenCaptured):
		playerRef.movementRef.set_max_speed(PCMovement.SpeedTier.SLOW)
		if (!playerHasBeenMoved):
			playerRef.global_position = self.get_parent().global_position
			playerHasBeenMoved = true
		playerHasBeenCaptured = true
	if (playerRef.transformationChangeRef.isTransformed):
		playerRef.transformationChangeRef.DeactivateTransformation()
		playerRef.movementRef.set_max_speed(PCMovement.SpeedTier.SLOW)

func execute_negated_effect(receivedBody, _delta):
	if (receivedBody is PlayerCharacter):
		LetPlayerMove(receivedBody)

func LetPlayerMove(playerRef: PlayerCharacter):
	if (playerHasBeenCaptured):
		playerRef.movementRef.reset_max_speed()
		playerHasBeenCaptured = false

func execute_leave_effect(receivedBody):
	if (receivedBody is PlayerCharacter):
		PlayerLeftArea(receivedBody)

func PlayerLeftArea(playerRef: PlayerCharacter):
	playerRef.movementRef.reset_max_speed()
	playerHasBeenCaptured = false
	playerHasBeenMoved = false
	if (hitboxActive):
		remove_call_hitbox()

func remove_call_hitbox():
	callGuardHitbox.SetInactive()
	hitboxActive = false

func add_call_hitbox():
	callGuardHitbox.SetActive()
	hitboxActive = true
