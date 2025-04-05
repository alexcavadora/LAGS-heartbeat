
extends Node3D
class_name HexTemplate
@onready var animationp : AnimationPlayer = $AnimationPlayer

@export var Animations: HexAnimComponent
@export var Targets : Dictionary [String, HexTemplate]
@export var TargetToWall : Dictionary [HexTemplate, CollisionShape3D]


@onready var walls = $Hex/Wall/Walls
signal AnimToggle(NextAnim)
@export_group("Posible states")
@export var Downed : bool
@export var Up : bool
@export var GoUp : bool

@onready var wall_up_r = $Hex/Wall/Walls/WallUpR
@onready var wall_mid_r = $Hex/Wall/Walls/WallMidR
@onready var wall_low_r = $Hex/Wall/Walls/WallLowR
@onready var wall_low_l = $Hex/Wall/Walls/WallLowL
@onready var wall_mid_l = $Hex/Wall/Walls/WallMidL
@onready var wall_up_l = $Hex/Wall/Walls/WallUpL
@onready var lastwalltouched : CollisionShape3D
@onready var currenttarget : HexTemplate


func _ready():
	for target : HexTemplate in Targets.values()  :
		if target != null:
			#print(target.animationp)
			await target.ready
			print(target.animationp)
			#target.animationp.animation_finished.connect(shithappened)
			
		
	match Downed:
		true:
			AnimToggle.emit("Downed")
		false:
			pass

	match Up:
		true:
			AnimToggle.emit("Up")
		false:
			pass
	
	match GoUp:
		
		true:
			AnimToggle.emit("GoUp")
		false:
			pass


func shithappened():
	print("Done")
	

func lastwall(wall):
	lastwalltouched = wall
	print(lastwalltouched)

func activate(targetwall:CollisionShape3D):
	targetwall.position += Vector3(0.0, 0.0, 0.0)

func deactivate(targetwall:CollisionShape3D):
	targetwall.position +=  Vector3(0.0, -10.0, 0.0)




func _on_up_r_body_entered(body):
	if Targets["Target1"] != null:
		print("Entering1")
		currenttarget = Targets["Target1"]
		currenttarget.animationp.play("GoUp")
		TargetToWall.get_or_add(currenttarget, wall_up_r )
		print(TargetToWall.get_or_add(currenttarget, wall_up_r ))
		


func _on_up_r_body_exited(body):
	if Targets["Target1"] != null:
		print("Exiting1")
		#currenttarget = Targets["Target1"]
		currenttarget.animationp.pause()


func _on_mid_r_body_entered(body):
	if Targets["Target2"] != null:
		print("Entering2")
	
func _on_mid_r_body_exited(body):
	if Targets["Target2"] != null:
		print("Exiting2")


func _on_low_r_body_entered(body):
	if Targets["Target3"] != null:
		print("Entering3")

func _on_low_r_body_exited(body):
	if Targets["Target3"] != null:
		print("Exiting3")


func _on_up_l_body_entered(body):
	if Targets["Target4"] != null:
		print("Entering4")


func _on_up_l_body_exited(body):
	if Targets["Target4"] != null:
		print("Exiting4")

func _on_mid_l_body_entered(body):
	if Targets["Target5"] != null:
		print("Entering5")


func _on_mid_l_body_exited(body):
	if Targets["Target5"] != null:
		print("Exiting5")


func _on_low_l_body_entered(body):
	if Targets["Target6"] != null:
		print("Entering6")


func _on_low_l_body_exited(body):
	if Targets["Target6"] != null:
		print("Exiting6")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "GoUp":
		animationp.play("Up")
		
	elif anim_name == "Up":
		print("Acabao")
		if lastwalltouched != null:
			pass
		
