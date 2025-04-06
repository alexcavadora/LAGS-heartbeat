class_name Tether_area
extends Area3D
@onready var shape: CollisionShape3D = $CollisionShape3D

@export var tether_force = 150.0
@onready var max_tether_distance = 8.0
@export var tether_dampening = 0.5
var target : Eye
signal tethered (status)
var to_target : Vector3
var distance : float
var direction : Vector3
var frame_count = 0


func apply_tether_force(delta):
	#frame_count += 1
	#if frame_count % 10 == 0:
	to_target = global_position - target.global_position
	distance = to_target.length()
	
	if distance <= max_tether_distance:
		direction = to_target.normalized()

		target.velocity = tether_force * delta * tether_dampening * direction

func _physics_process(delta: float) -> void:
	if target != null:
		apply_tether_force(delta)

func _on_body_entered(body: Node3D) -> void:
	if body is Eye:
		target = body
		body.pulled_n += 1
		body.tethers.append(self)
		tethered.emit(true)

func _on_body_exited(body: Node3D) -> void:
	if body is Eye:
		target = null
		body.pulled_n -= 1
		body.tethers.erase(self)
		tethered.emit(false)
