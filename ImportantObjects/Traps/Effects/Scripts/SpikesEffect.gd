extends TrapObjectEffect

@export var spriteRef: AnimatedSprite2D
@export var phaseDuration: float
var phaseTimer: float
var damagePhase: bool
var damagedPlayer: bool

func _ready():
	phaseTimer = phaseDuration
	spriteRef.play("SpikesIn")

func _process(delta):
	PhaseTimer(delta)

func PhaseTimer(delta):
	if (phaseTimer > 0):
		phaseTimer -= delta
		return
	ChangePhase()

func ChangePhase():
	phaseTimer = phaseDuration
	damagePhase = !damagePhase
	if (!damagePhase):
		damagedPlayer = false
		spriteRef.play("SpikesIn")
		return
	spriteRef.play("SpikesOut")

func NormalEffect(receivedBody: CharacterBody2D, _delta):
	if (receivedBody is PlayerCharacter && damagePhase && !damagedPlayer):
		damagedPlayer = true
		receivedBody.GameOver(self)

func OnLeaveEffect(_receivedBody: CharacterBody2D):
	damagedPlayer = false
