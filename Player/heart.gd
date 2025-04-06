class_name heart
extends RigidBody3D

# Node references
@onready var hitbox: Area3D = $Hitbox

# Exported properties
@export var follow: Node3D
@export var string_max_distance: float = 8.0
@export var s_force: float = 2000.0
@export var s_damping: float = 0.7
@export var p_deceleration: float = 35.0

# Cached variables
var to_target: Vector3 = Vector3.ZERO
var distance: float = 0.0
var pulled: bool = false
var _temp_velocity: Vector3 = Vector3.ZERO

# Physics constants
const _zero_threshold: float = 0.01

func _physics_process(delta: float) -> void:
	to_target = global_position - follow.global_position
	active(linear_velocity.length_squared() > _zero_threshold)
	if follow:
		distance = to_target.length()
		if distance > string_max_distance:
			_apply_string_force(delta)
		elif !pulled:
			_apply_deceleration(delta)

func _apply_string_force(delta: float) -> void:
	var exceed = min(distance - string_max_distance, string_max_distance)
	
	var direction = to_target.normalized()
	var spring_force = direction * exceed * s_force * -1.0
	
	_temp_velocity.x = linear_velocity.x
	_temp_velocity.z = linear_velocity.z
	var damping_force = _temp_velocity * s_damping
	var final_force = spring_force - damping_force
	
	linear_velocity.x += final_force.x * delta
	linear_velocity.z += final_force.z * delta

func _apply_deceleration(delta: float) -> void:
	linear_velocity.x = move_toward(linear_velocity.x, 0, p_deceleration * delta)
	linear_velocity.z = move_toward(linear_velocity.z, 0, p_deceleration * delta)

func active(state: bool) -> void:
	hitbox.hurting(state)
