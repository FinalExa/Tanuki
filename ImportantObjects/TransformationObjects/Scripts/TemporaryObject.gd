extends StaticBody2D

@export var lifeTimer: float

func _process(delta):
	LifeTimer(delta)

func LifeTimer(delta):
	if (lifeTimer > 0):
		lifeTimer -= delta
		return
	Despawn()

func Despawn():
	queue_free()
