class_name GuardMovement
extends Node

signal reached_destination

@onready var navReg = $"../../NavigationRegion2D"
var map
var path = []

@export var guardPatrol: GuardPatrol
@export var bodyRef: CharacterBody2D
@export var navigation_agent: NavigationAgent2D

@export var default_movement_speed: float
var current_movement_speed
var target: Node2D
var locationTarget: Vector2
var locationTargetEnabled: bool
var lastPosition: Vector2

func _ready():
	call_deferred("setup_navserver")

func setup_navserver():
	current_movement_speed = default_movement_speed
	map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(map, true)
	
	var region = NavigationServer2D.region_create()
	NavigationServer2D.region_set_transform(region, Transform2D())
	NavigationServer2D.region_set_map(region, map)
	
	var navigation_poly = NavigationMesh.new()
	navigation_poly = $"../../NavigationRegion2D".navigation_polygon
	NavigationServer2D.region_set_navigation_polygon(region, navigation_poly)
	guardPatrol.set_current_patrol_routine()

func _update_navigation_path(start_position, end_position):
	path = NavigationServer2D.map_get_path(map, start_position, end_position, true)
	path.remove_at(0)
	lastPosition = end_position
	set_process(true)

func _process(delta):
	if((target != null || locationTargetEnabled == true)):
		navigation()
		navigate_on_path(delta)

func navigate_on_path(delta):
	var movement_speed = current_movement_speed * delta
	move_along_path(movement_speed)

func move_along_path(distance):
	var last_point = bodyRef.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if (distance <= distance_between_points):
			bodyRef.position = last_point.lerp(path[0],distance / distance_between_points)
			return
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	bodyRef.position = last_point
	emit_signal("reached_destination")

func set_new_target(newTarget):
	target = newTarget
	locationTarget = Vector2.ZERO
	locationTargetEnabled = false
	navigation()

func set_location_target(locTarget: Vector2):
	locationTarget = locTarget
	target = null
	locationTargetEnabled = true
	navigation()

func navigation():
	if(target != null):
		_update_navigation_path(bodyRef.position, target.position)
	else:
		if (locationTargetEnabled == true):
			_update_navigation_path(bodyRef.position, locationTarget)
		else:
			_update_navigation_path(bodyRef.position, bodyRef.position)

func set_movement_speed(newMovementSpeed: float):
	current_movement_speed = newMovementSpeed

func reset_movement_speed():
	current_movement_speed = default_movement_speed
