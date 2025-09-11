class_name PlayerHealth
extends Node2D

@export var playerRef: PlayerCharacter
@export var maxHealth: int
@export var heartSpriteRef: AnimatedSprite2D
@export var playerSprite: AnimatedSprite2D
@export var invincibilityTime: float
@export var invincibilityFlicker: float
var invincibilityTimer: float
var invincibilityFlickerTimer: float
var currentHealth: int

func _ready():
	Startup()

func Startup():
	heartSpriteRef.play("idle")
	heartSpriteRef.hide()
	playerRef.playerHUD.uIHearts.Refill()
	SetHealthToMax()

func _process(delta):
	SwapAnimation()
	InvincibilityTimer(delta)

func InvincibilityTimer(delta):
	if (invincibilityTimer > 0):
		if (!playerRef.invincibilityFrames): playerRef.invincibilityFrames = true
		invincibilityTimer -= delta
		Flicker(delta)
		if (invincibilityTimer < 0):
			playerRef.invincibilityFrames = false
			playerSprite.show()

func Flicker(delta):
	invincibilityFlickerTimer += delta
	if (invincibilityFlickerTimer >= invincibilityFlicker):
		invincibilityFlickerTimer -= invincibilityFlicker
		if (playerSprite.visible): playerSprite.hide()
		else: playerSprite.show()

func UpdateMaxHealth(value: int):
	maxHealth += value
	for i in value:
		call_deferred("SpawnSprite")

func SetHealthToMax():
	currentHealth = maxHealth

func ReceiveDamage(damageReceived: int):
	if (currentHealth > 0):
		heartSpriteRef.show()
		heartSpriteRef.play("lost_heart")
		currentHealth -= damageReceived
		playerRef.playerHUD.uIHearts.MakeHeartEmpty(currentHealth)
		if (currentHealth == 0):
			playerRef.ForceGameOver()
			return
		playerRef.invincibilityFrames = true
		invincibilityTimer = invincibilityTime
		invincibilityFlickerTimer = 0

func SwapAnimation():
	if (heartSpriteRef.visible && !heartSpriteRef.is_playing()):
		heartSpriteRef.hide()
		heartSpriteRef.play("idle")
