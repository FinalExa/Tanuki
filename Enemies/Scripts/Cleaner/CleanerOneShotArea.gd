extends Area2D

var playerRef: PlayerCharacter
var hitboxOff: bool

func _process(_delta):
	AttackPlayer()

func AttackPlayer():
	if (playerRef != null && !hitboxOff):
		ActivateGameOver()

func SetHitboxOff():
	hitboxOff = true
	self.hide()

func SetHitboxOn():
	hitboxOff = false
	self.show()

func ActivateGameOver():
	hitboxOff = true
	playerRef.GameOver(self)

func _on_body_entered(body):
	if (body is PlayerCharacter):
		playerRef = body

func _on_body_exited(body):
	if (body is PlayerCharacter):
		playerRef = null
