extends Node2D

export var detail = 20;
export var distance = 90;
export(bool) var  draggable = 0;

var rays = {}
onready var polynode = $poly.polygon

func _ready():
	#scaling
	$poly.texture_offset = Vector2(distance,distance)
	$poly.texture_scale = Vector2(256.0/distance,256.0/distance)
	print(256.0/distance)
	#raycast spawning
	var angle = 0;
	var seperation = (PI * 2)/detail
	for i in detail:
		var pos = polar2cartesian(distance, angle)
		angle += seperation
		
		rays[i] = RayCast2D.new()
		rays[i].cast_to = pos
		rays[i].collide_with_areas = true
		rays[i].collide_with_bodies = true
		add_child(rays[i])
		rays[i].enabled = true


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		visible = !visible
	
	if draggable:
		position = get_global_mouse_position()
	
	var polygondata = []
	for i in detail:
		if rays[i].is_colliding():
			polygondata.insert(i,rays[i].get_collision_point() - global_position)
		else:
			polygondata.insert(i,rays[i].cast_to)
	$poly.polygon = polygondata

