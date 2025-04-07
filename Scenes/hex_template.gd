extends Node3D
class_name HexTemplate
@onready var animationp : AnimationPlayer = $AnimationPlayer

@export var Animations: HexAnimComponent

const SPAWENR_3 = preload("res://spawner/spawenr3.tscn")
const SPAWNER_1 = preload("res://spawner/spawner1.tscn")
const SPAWNER_2 = preload("res://spawner/spawner2.tscn")
const SPAWNER_4 = preload("res://spawner/spawner4.tscn")
const SPAWNER_5 = preload("res://spawner/spawner5.tscn")

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

@export var spawn_scene : PackedScene = null
@onready var idx = int(name.substr(8,-1))
@onready var is_outer = idx > 6
var instance
signal finished(idx)

var finish_status = false
var spawnerarray : Array = [SPAWNER_1, SPAWNER_2,SPAWENR_3,SPAWNER_4,SPAWNER_5]
@export var override = false

func _ready():
	if override == false:
		spawn_scene = spawnerarray[randi_range(0,4)]

	#print(is_outer, idx)
	if ui != null:
		connect("finished", ui._update_minimap)
		ui.connect("berlin_drop", _on_berlin_free)
		ui.connect("spawn", spawn)
		ui.connect("unlock", all_clear)
		ui.connect("lock", fighting)
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
			finish_status = true
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
		finished.emit(idx)
		finish_status = true

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

func _on_berlin_free():
	if not is_outer:
		return
	print("freeing ", idx)
	Deactivate = false
	Up = false
	GoUp = false
	Downed = true
	check()


func spawn(indexes):
	print("spawn", indexes)
	if idx in indexes and spawn_scene != null:
		instance = spawn_scene.instantiate()
		instance.position.x = position.x
		instance.position.z = position.z
		instance.position.y = 1.5
		get_parent().get_parent().add_child(instance)
		instance.connect("tile_finished", hex_cleared)

func fighting(indexes):
	if idx in indexes:
		Deactivate = true
		
func hex_cleared():
	ui.fighting.erase(idx)
	print(ui.fighting)
	if ui.fighting.size() == 0:
		ui.unlock.emit(ui.available)

func all_clear(indexes):
	if idx in indexes:
		#print(indexes, idx)
		Deactivate = false
