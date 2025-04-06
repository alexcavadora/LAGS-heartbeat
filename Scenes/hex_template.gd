extends Node3D
class_name HexTemplate
@onready var animationp : AnimationPlayer = $AnimationPlayer

@export var Animations: HexAnimComponent


@onready var walls = $Hex/Wall/Walls
signal AnimToggle(NextAnim)
@export_group("Posible states")
@export var Downed : bool
@export var Up : bool
@export var GoUp : bool
@export var Deactivate : bool
@onready var detector : Area3D = $Detector

@onready var wall_up_r = $Hex/Wall/Walls/WallUpR
@onready var wall_mid_r = $Hex/Wall/Walls/WallMidR
@onready var wall_low_r = $Hex/Wall/Walls/WallLowR
@onready var wall_low_l = $Hex/Wall/Walls/WallLowL
@onready var wall_mid_l = $Hex/Wall/Walls/WallMidL
@onready var wall_up_l = $Hex/Wall/Walls/WallUpL
@onready var progress_count = $ProgressCount
@export var ui: Control
@onready var currenttarget : HexTemplate
var touched_area : Area3D

signal finished(idx)

func _ready():
	if ui != null:
		connect("finished", ui._update_minimap)
	check()

func check ():
	match Downed:
		true:
			AnimToggle.emit("Downed")
			detector.monitoring = true
		false:
			pass

	match Up:
		true:
			AnimToggle.emit("Up")
			detector.queue_free()
		false:
			pass
	
	match GoUp:
		
		true:
			AnimToggle.emit("GoUp")
		false:
			pass
			
	match Deactivate:
		true:
			detector.monitoring = false
		false:
			pass




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GoUp":
		progress_count.visible = false
		await progress_count.visible
		Downed = false
		Up = true
		check()
		finished.emit(int(name.substr(8,-1)))
	
		

	elif anim_name == "Up":
		if detector != null:
			detector.queue_free()
		
		


func _on_area_3d_body_entered(body):
	if body is Eye and Deactivate == false:
		progress_count.visible = true
		#print(str("Entering:", self.name))
		animationp.play("GoUp")


func _on_area_3d_body_exited(body):
	if body is Eye and Deactivate == false:
		#print(str("Exiting:", self.name))
		if animationp.current_animation == "GoUp":
			animationp.pause()
