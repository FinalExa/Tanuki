extends InteractionObjectEffect

@export var playerSpeedWhileCaptured: float
@export var callGuardHitbox: CallGuardHitbox
var callGuardHitboxInstance: CallGuardHitbox
var playerHasBeenMoved: bool = false
var playerHasBeenCaptured: bool = false
var hitboxActive: bool = false

func _ready():
	remove_call_hitbox()

func execute_effect_normally(receivedBody, delta):
	if (receivedBody is PlayerCharacter):
		var playerRef: PlayerCharacter = receivedBody
		if (!hitboxActive):
			add_call_hitbox(playerRef)
		if (!playerHasBeenCaptured):
			playerRef.movementRef.set_max_speed(playerSpeedWhileCaptured)
			if (!playerHasBeenMoved):
				playerRef.global_position = self.get_parent().global_position
				playerHasBeenMoved = true
			playerHasBeenCaptured = true
		if (playerRef.transformationChangeRef.isTransformed):
			playerRef.transformationChangeRef.deactivate_transformation()
			playerRef.movementRef.set_max_speed(playerSpeedWhileCaptured)

func execute_negated_effect(receivedBody, _delta):
	if (receivedBody is PlayerCharacter):
		if (playerHasBeenCaptured):
			var playerRef: PlayerCharacter = receivedBody
			playerRef.movementRef.reset_max_speed()
			playerHasBeenCaptured = false

func execute_leave_effect(receivedBody):
	if (receivedBody is PlayerCharacter):
		var playerRef: PlayerCharacter = receivedBody
		playerRef.movementRef.reset_max_speed()
		playerHasBeenCaptured = false
		playerHasBeenMoved = false
		if (hitboxActive):
			remove_call_hitbox()

func remove_call_hitbox():
	if(callGuardHitboxInstance == null):
		callGuardHitboxInstance = callGuardHitbox
	remove_child(callGuardHitboxInstance)
	callGuardHitboxInstance = null
	hitboxActive = false

func add_call_hitbox(playerRef: PlayerCharacter):
	callGuardHitboxInstance = callGuardHitbox
	add_child(callGuardHitboxInstance)
	callGuardHitboxInstance.targetObject = playerRef
	hitboxActive = true
