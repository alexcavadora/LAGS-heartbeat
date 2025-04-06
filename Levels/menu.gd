extends Node3D
@onready var play_s = $Control/Play/PlayS
@onready var options_s = $Control/Options/OptionsS
@onready var quit_s = $Control/Quit/QuitS
const MAP_TEMPLATE = preload("res://Levels/MapTemplate.tscn")
@onready var options : OptionsMenu = $Control/Sprite2D
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var as3d : AnimatedSprite3D = $OtherIntro
@onready var other_intro : AnimatedSprite3D = $OtherIntro
@onready var once : bool = false
@onready var jelly_intro = $JellyIntro
@onready var play = $Control/Play


func _input(event):
	if Input.is_anything_pressed():
		if once == false:
			once = true
			jelly_intro.stop()
			as3d.frame = 186
			animation.play("ButtonFade")
			animation.seek(8.0)
			play.grab_focus()
		


func _on_play_pressed():
	get_tree().change_scene_to_packed(MAP_TEMPLATE)


func _on_options_pressed():
	options.showtoggle()


func _on_quit_pressed():
	get_tree().quit()


func _on_play_mouse_entered():
	play_s.play("HoverIn")
	await play_s.animation_finished
	play_s.play("Loop")


func _on_play_mouse_exited():
	await play_s.animation_looped
	play_s.play("HoverOut")
	await play_s.animation_finished
	play_s.play("default")


func _on_options_mouse_entered():
	options_s.play("HoverIn")
	await options_s.animation_finished
	options_s.play("Loop")


func _on_options_mouse_exited():
	await options_s.animation_looped
	options_s.play("HoverOut")
	await options_s.animation_finished
	options_s.play("default")



func _on_quit_mouse_entered():
	quit_s.play("HoverIn")
	await quit_s.animation_finished
	quit_s.play("Loop")


func _on_quit_mouse_exited():
	await quit_s.animation_looped
	quit_s.play("HoverOut")
	await quit_s.animation_finished
	quit_s.play("default")


func _on_jelly_intro_animation_finished():
	jelly_intro.stop()
	other_intro.play("Intro")
	animation.play("ButtonFade")
	play.grab_focus()
	
