extends Node

@onready var final_boss: Heart_boss = $"../FINAL_BOSS"
@onready var left_eye: Boss = $"../Left_eye"
@onready var right_eye: Boss = $"../Right_eye"
@onready var ui: Control = $"../Player/UI3D/SubViewport/UI"

func _ready():
	pass
	#left_eye.set_physics_process(true)
