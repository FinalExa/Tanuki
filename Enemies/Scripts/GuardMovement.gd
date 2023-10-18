class_name GuardMovement
extends Node

signal reached_destination

@export var movement_speed = 0
var target: Node2D
@export var bodyRef: CharacterBody2D
@export var pathDesiredDistance = 0
@export var targetDesiredDistance = 0
var readyToMove: bool

@export var navigation_agent: NavigationAgent2D

func _ready():
	navmeshStartup()

func navmeshStartup():
	navigation_agent.path_desired_distance = pathDesiredDistance
	navigation_agent.target_desired_distance = targetDesiredDistance
	call_deferred("actor_setup")

func set_new_target(newTarget):
	target = newTarget

func actor_setup():
	await get_tree().physics_frame
	readyToMove = true

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta):
	if(target!= null && readyToMove == true):
		navigation()
		bodyRef.move_and_slide()

func navigation():
	if(target!=null):
		set_movement_target(target.position)
		navigation_agent.target_position = target.position
		if navigation_agent.is_navigation_finished():
			emit_signal("reached_destination")
			return

		var current_agent_position: Vector2 = bodyRef.global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * movement_speed
		bodyRef.velocity = new_velocity
	else:
		bodyRef.velocity = Vector2.ZERO
