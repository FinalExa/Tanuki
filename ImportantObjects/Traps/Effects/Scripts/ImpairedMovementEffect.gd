extends TrapObjectEffect

@export var playerSpeedWhileCaptured: float
@export var callGuardHitbox: CallGuardHitbox
@export var effectSpeedTier: PCMovement.SpeedTier
var hitboxActive: bool = false

func _ready():
	DeactivateCall()

func NormalEffect(receivedBody, _delta):
	if (receivedBody is PlayerCharacter):
		SlowAndKeepToCenter(receivedBody)

func SlowAndKeepToCenter(playerRef: PlayerCharacter):
	playerRef.movementRef.set_max_speed(effectSpeedTier)
	if (!hitboxActive):
		ActivateCall()
	if (playerRef.transformationChangeRef.isTransformed):
		playerRef.transformationChangeRef.transformationActivation.DeactivateTransformation()

func NegatedEffect(receivedBody, _delta):
	if (receivedBody is PlayerCharacter):
		LetPlayerMove(receivedBody)

func LetPlayerMove(playerRef: PlayerCharacter):
		playerRef.movementRef.reset_max_speed()

func OnEnterEffect(receivedBody):
	if (receivedBody is PlayerCharacter):
		MoveToCenter(receivedBody)

func MoveToCenter(playerRef: PlayerCharacter):
	playerRef.global_position = self.get_parent().global_position

func OnLeaveEffect(receivedBody):
	if (receivedBody is PlayerCharacter):
		PlayerLeftArea(receivedBody)

func PlayerLeftArea(playerRef: PlayerCharacter):
	playerRef.movementRef.reset_max_speed()
	if (hitboxActive):
		DeactivateCall()

func DeactivateCall():
	callGuardHitbox.SetInactive()
	hitboxActive = false

func ActivateCall():
	callGuardHitbox.SetActive()
	hitboxActive = true
