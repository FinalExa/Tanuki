extends TrapObjectEffect

@export var spriteRef: AnimatedSprite2D
@export var phaseDuration: float
@export var spikeOutTime: float
var spikeOutDoneForThisCycle: bool
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
		if (!spikeOutDoneForThisCycle && phaseTimer < spikeOutTime):
			spikeOutDoneForThisCycle = true
			if (!damagePhase):
				spriteRef.play("SpikesOut")
				return
			spriteRef.play("SpikesIn")
		return
	ChangePhase()

func ChangePhase():
	phaseTimer = phaseDuration
	damagePhase = !damagePhase
	spikeOutDoneForThisCycle = false
	if (!damagePhase):
		damagedPlayer = false

func NormalEffect(receivedBody: CharacterBody2D, _delta):
	if (receivedBody is PlayerCharacter && damagePhase && !damagedPlayer):
		damagedPlayer = true
		receivedBody.GameOver(self)

func OnLeaveEffect(_receivedBody: CharacterBody2D):
	damagedPlayer = false
