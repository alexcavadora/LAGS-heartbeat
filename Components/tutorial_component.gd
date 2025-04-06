extends Node3D
class_name TutorialComponent
@export var Dialog : DialogComponent
@onready var Buttonspressed : Array = ["Up", "Down", "Left", "Right"]

func _process(delta):
	pass
	#print(Buttonspressed, Buttonspressed.size())

func _input(event):
	if Dialog.linecount >= 1:
		if Input.is_action_just_pressed("ui_up"):
			Buttonspressed.pop_back()
		if Input.is_action_just_pressed("ui_down"):
			Buttonspressed.pop_back()
		if Input.is_action_just_pressed("ui_left"):
			Buttonspressed.pop_back()
		if Input.is_action_just_pressed("ui_right"):
			Buttonspressed.pop_back()
	
	if Buttonspressed.size() == 0:
		Dialog.InputSTOP = false
	
		


func _on_dialog_box_done():
	match Dialog.linecount:
		0:
			pass
		1:
			Dialog.InputSTOP = true
		2:
			pass
		3:
			pass
		
