extends AudioStreamPlayer
class_name MusicManager
const BOSSFIGHT = preload("res://assets/musics/bossfight.mp3")
#const MENU_PAUSA = preload("res://assets/musics/menu-pausa.mp3")
const RING_1 = preload("res://assets/musics/ring 1.mp3")
const RING_2 = preload("res://assets/musics/ring 2.mp3")
const RING_3 = preload("res://assets/musics/ring 3.mp3")
const TUTORIAL = preload("res://assets/musics/tutorial.mp3")
@onready var tutorial_component : TutorialComponent = $"../BegginingStugg/TutorialComponent"
@onready var ui = $"../Player/UI3D/SubViewport/UI"

func playmusic(music):
	stream = music
	play()
	
func _ready():
	if tutorial_component.tutoskip == true:
		playmusic(RING_1)
	else:
		playmusic(TUTORIAL)



func _on_tutorial_component_tutorialdone():
	playmusic(RING_1)


func _on_ui_firstcomplete():
	playmusic(RING_2)


func _on_ui_secondcomplete():
	playmusic(RING_3)
