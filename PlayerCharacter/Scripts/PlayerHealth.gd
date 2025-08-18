class_name PlayerHealth
extends Node2D

@export var playerRef: PlayerCharacter
@export var maxHealth: int
@export var heartSpriteRef: AnimatedSprite2D
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

func SwapAnimation():
	if (heartSpriteRef.visible && !heartSpriteRef.is_playing()):
		heartSpriteRef.hide()
		heartSpriteRef.play("idle")
