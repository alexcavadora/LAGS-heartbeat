extends Node
@onready var sprite_3d = $"../Sprite3D"
@onready var sub_viewport = $"../Sprite3D/SubViewport"


func _on_health_dead():
	sprite_3d.visible = true

func _unhandled_input(event):
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			# If the event is a mouse/touch event, then we can ignore it here, because it will be
			# handled via Physics Picking.
			return
	sub_viewport.push_input(event)
