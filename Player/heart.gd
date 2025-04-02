class_name heart
extends RigidBody3D
@onready var hitbox: Area3D = $Hitbox

func active(state):
	#print(hitbox.monitoring)
	hitbox.hurting(state)
