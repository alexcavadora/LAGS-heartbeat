extends StaticBody3D
class_name HexTemplate
@onready var animation= $AnimationPlayer
@export var target1 : HexTemplate
@export var target2 : HexTemplate
@export var target3 : HexTemplate
@export var target4 : HexTemplate
@export var target5 : HexTemplate
@export var target6 : HexTemplate
@onready var walls : StaticBody3D = $Wall/Walls

func _process(delta):
	print(global_position, name)

func activate(targetwall:CollisionShape3D):
	targetwall.position += Vector3(0.0, 0.0, 0.0)

func deactivate(targetwall:CollisionShape3D):
	targetwall.position +=  Vector3(0.0, -10.0, 0.0)


func _on_up_r_body_entered(body):
	print("Coming1")


func _on_mid_r_body_entered(body):
	print("Coming2")

func _on_low_r_body_entered(body):
	print("Coming3")

func _on_low_l_body_entered(body):
	print("Coming4")


func _on_mid_l_body_entered(body):
	print("Coming5")
	
func _on_up_l_body_entered(body):
	print("Coming6")


func _on_up_r_body_exited(body):
	print("OutOf1")


func _on_mid_r_body_exited(body):
	print("OutOf2")


func _on_low_r_body_exited(body):
	print("OutOf3")


func _on_low_l_body_exited(body):
	print("OutOf4")


func _on_up_l_body_exited(body):
	print("OutOf6")


func _on_mid_l_body_exited(body):
	print("OutOf5")
