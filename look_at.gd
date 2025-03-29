extends CharacterBody2D

var angle = 0
func _physics_process(delta: float) -> void:
	angle = get_angle_to(get_global_mouse_position())
	angle -= PI/4
	rotate(snappedf(angle, 0.4 * PI))
	#if 
