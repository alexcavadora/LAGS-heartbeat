extends Node3D
class_name TutorialComponent
@export var Dialog : DialogComponent3D
@onready var movecounter : int = 12
@export var movetut : bool = true
@onready var startbut : bool = false

@onready var attcounter : int = 200
@export var attut : bool = true
@onready var startattack : bool = false
@onready var first_ring = $"../../FirstRing"

@onready var hacked : bool = false
@onready var donehacking : bool = false

@export var tutoskip : bool

func _ready():
	if SavedVars.tutodone == true:
		tutoskip = SavedVars.tutodone
	
	match tutoskip:
		true:
			tutorial_done()
			Dialog.Timerstart = false
		false:
			pass

func tutorial_done():
	unlockring()

func unlockring():
	var hexes = first_ring.get_children()
	for i : HexTemplate in hexes:
		if i.Deactivate == true:
			i.Deactivate = false
		i.check()
		hacked = true

func _process(delta):
	if movecounter <= 0:
		#print("Done WASD")
		if movetut == true:
			Dialog.InputSTOP = false
			Dialog.clearcenter()
			movetut = false
			startbut = false
	if attcounter <= 0:
		print("Done Attack")
		if attut == true:
			Dialog.InputSTOP = false
			Dialog.clearcenter()
			attut = false
			startattack = false
		
	if hacked == true:
		var hexes = first_ring.get_children()
		for i : HexTemplate in hexes:
			if i.Up == true and donehacking == false:
				Dialog.InputSTOP = false
				Dialog.clearcenter()
				print("Tutorial Clear!!!!")
				donehacking = true
				
	

		

	#print(Buttonspressed, Buttonspressed.size())

func _input(event):
	if startbut == true:
		if Input.is_action_just_pressed("ui_up"):
			movecounter -= 1
		if Input.is_action_just_pressed("ui_down"):
			movecounter -= 1
		if Input.is_action_just_pressed("ui_left"):
			movecounter -= 1
		if Input.is_action_just_pressed("ui_right"):
			movecounter -= 1
	if startattack == true:
		if Input.is_action_pressed("pull_spring"):
			attcounter -= 1
			print(attcounter)


func _on_dialog_box_done():
	match Dialog.linecount:
		0:
			pass
		1:
			Dialog.InputSTOP = true
			startbut = true
			print("StartCounting")
			
		2:
			pass
		3:
			pass
		4:
			Dialog.InputSTOP = true
			startattack = true
			print("StartCounting")
		9:
			Dialog.InputSTOP = true
			unlockring()
			
		12:
			SavedVars.tutodone = true
			
			
		
