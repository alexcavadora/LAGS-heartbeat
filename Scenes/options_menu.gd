extends CanvasLayer
class_name  OptionsMenu
@export var Enviroment : WorldEnvironment
@onready var brightnes = $Brightnes
@onready var contrast = $Contrast
@onready var saturation = $Saturation
@onready var toggle : int = 0
@onready var fullscreen = $Fullscreen
@onready var crt = $CRT
@onready var exclusive = $Exclusive
@export var CRTShader : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	brightnes.value = Enviroment.environment.adjustment_brightness
	contrast.value = Enviroment.environment.adjustment_contrast
	saturation.value = Enviroment.environment.adjustment_saturation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		showtoggle()
	
	Enviroment.environment.adjustment_brightness = brightnes.value
	Enviroment.environment.adjustment_contrast = contrast.value
	Enviroment.environment.adjustment_saturation = saturation.value

func showtoggle():
	if toggle < 1:
		get_tree().paused = true
		visible = true
		toggle += 1
	else:
		get_tree().paused = false
		visible = false
		toggle = 0
	print(toggle)

func _on_reset_pressed():
	brightnes.value = 1
	contrast.value = 1
	saturation.value = 1


func _on_fullscreen_toggled(toggled_on):
	if fullscreen.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		exclusive.visible = true
	elif fullscreen.button_pressed == true and exclusive.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		exclusive.visible = false
		exclusive.button_pressed = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		exclusive.visible = false
		exclusive.button_pressed = false


func _on_crt_toggled(toggled_on):
	if crt.button_pressed == true:
		CRTShader.visible = true
	else:
		CRTShader.visible = false


func _on_exclusive_toggled(toggled_on):
	if exclusive.button_pressed == true and exclusive.visible == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif exclusive.button_pressed == false and exclusive.visible == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		pass


func _on_back_pressed():
	showtoggle()


func _on_quit_pressed():
	get_tree().paused = false
	var INTRO_CINEMATIC = load("res://scenes/levels/TitleScreen/intro_cinematic.tscn")
	get_tree().change_scene_to_packed(INTRO_CINEMATIC)
