extends Node3D
@onready var camera_3d = $Player/Camera3D

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		

func _ready():
	print(camera_3d.global_position)
	
