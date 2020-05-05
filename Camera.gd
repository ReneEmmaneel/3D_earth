#All code for the camara and update for camera information is located
#in this file

extends Camera

var total_move = Vector2(0,0)
var zoom = 3
var mouse_position

func _ready():
	look_at(Vector3(0,0,0), Vector3(0, 1, 0))

#Get the movement direction and scroll events,
#then call move_camera and update_label
func _process(delta):
	var movement = Vector2(0,0)
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	if Input.is_action_pressed("ui_down"):
		movement.y -= 1
	if Input.is_action_pressed("ui_up"):
		movement.y += 1

	var scroll = 0
	if Input.is_action_just_released("scroll_up"):
		scroll -= 1
	if Input.is_action_just_released("scroll_down"):
		scroll += 1
	if scroll != 0:
		zoom += scroll * 0.5
	
	if Input.is_action_pressed("reset"):
		total_move = Vector2(0,0)
		zoom = 3

	if Input.is_action_pressed("mouse"):
		var new_position = get_viewport().get_mouse_position()
		if mouse_position != null:
			var direction = mouse_position - new_position
			move_camera(direction / Vector2(100, -60))
		mouse_position = new_position
	else:
		mouse_position = null

	move_camera(movement * 3, delta)
	update_label()

func print_vector3(name, v):
	return "{0}: ({1},{2},{3})\n".format([name, "%0.3f" % v.x, "%0.3f" % v.y, "%0.3f" % v.z])

func update_label():
	var label = $"../ColorRect/Label"
	label.text = "tot_move: ({0},{1})\n".format(["%0.3f" % total_move.x, "%0.3f" % total_move.y])
	label.text += print_vector3("Cam pos", translation)
	label.text += print_vector3("Cam rot", rotation)
	
	label.text += "\n" + "Move with WASD or with mouse\nreset with R"

#First bound the height by [-max_h, max_h]
#Then rotate around the y-axis, and set the correct height
#Mutliply with zoom variable, and call look_at to look at the earth
func move_camera(movement, delta = 1):
	total_move += movement * delta
	var max_h = 1
	if total_move.y >= max_h:
		total_move.y = max_h
	elif total_move.y <= -max_h:
		total_move.y = -max_h

	var trans_x = Vector3(sin(total_move.x), 0, cos(total_move.x))
	var height = Vector3(0, total_move.y, 0)
	translation = trans_x + height
	translation *= zoom
	look_at(Vector3(0,0,0), Vector3(0, 1, 0))
