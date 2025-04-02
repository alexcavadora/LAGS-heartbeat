class_name heart
extends RigidBody3D
@onready var hitbox: Area3D = $Hitbox
@export var follow: Node3D
@export var string_max_distance :float = 8.0
@export var s_force: float = 2000.0
@export var s_damping: float = 0.7
@export var p_deceleration: float = 35.0

var to_target 
var distance 
var pulled = false
func _physics_process(delta: float) -> void:
	if linear_velocity.x == 0 and linear_velocity.z == 0:
		active(false)
	else:
		active(true)
	to_target = global_position - follow.global_position
	distance = to_target.length()
	if distance > string_max_distance:
		get_pulled(delta)
	elif !pulled:
		linear_velocity.x = move_toward(linear_velocity.x, 0,  p_deceleration * delta)
		linear_velocity.z = move_toward(linear_velocity.z, 0,  p_deceleration * delta)


func get_pulled(delta):
	var exceed = min (distance - string_max_distance, string_max_distance)
	var direction = to_target.normalized()
	var force = direction * exceed * s_force * -1.0
	var velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
	force -= velocity * s_damping

	linear_velocity.x += force.x * delta
	linear_velocity.z += force.z * delta



func active(state):
	#print(hitbox.monitoring)
	hitbox.hurting(state)
