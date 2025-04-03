class_name Eye
extends CharacterBody3D
@onready var health: Node = $Health
@onready var center: CollisionShape3D = $CollisionShape3D
@export var corazon: heart
# spring properties
@export var s_force: float = 2000.0
@export var s_max_distance: float = 8.0
@export var s_damping: float = 0.7
var is_pulling: bool = false
var to_player = 0
var distance = 0
# player movement
@export var p_move_speed: float = 7.0
@export var p_acceleration: float = 50.0
@export var p_deceleration: float = 35.0
@export var p_pull_acceleration: float = 2000
var p_current_pull_force: float = 0.0 
var p_current_speed = p_move_speed

#cooldown variables
@export var c_max : float = 2
var cooldown = c_max
@export var c_drain_speed = 0.01
@export var c_regen_speed = 0.005

#repel signal
signal attack()

func _physics_process(delta):
	to_player = center.global_position - corazon.global_position
	distance = to_player.length()
	# movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		if distance > s_max_distance:
			direction = -to_player.normalized()
		velocity.x = move_toward(velocity.x, direction.x * p_current_speed, p_acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * p_current_speed, p_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, p_deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, p_deceleration * delta)
	
	#chained_physics
	get_pulled(delta)
	if !is_pulling or cooldown <= 0:
		p_current_pull_force = 0.0
		p_current_speed = p_move_speed
		corazon.pulled = false
	elif is_pulling or cooldown > 0:
		cooldown = max(cooldown -c_drain_speed, 0)
		p_current_speed = p_move_speed / 2
		pull_heart(delta)
		p_current_pull_force = min(p_current_pull_force + p_pull_acceleration * delta, s_force)
	if !is_pulling and cooldown < c_max:
		cooldown = min(cooldown + c_regen_speed, c_max)
	#print(cooldown)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			collider.apply_central_impulse(-collision.get_normal()* collider.mass)
	

func pull_heart(delta):
	var to_corazon = corazon.global_position - center.global_position
	var distance = to_corazon.length()
	var direction = to_corazon.normalized()

	var pull_strength = p_current_pull_force * delta
	var pull_force = - direction * pull_strength * distance * distance
	corazon.apply_central_force(pull_force)

func get_pulled(delta):
	if distance > s_max_distance:
		var exceed = distance - s_max_distance
		var direction = to_player.normalized()
		var force = direction * exceed * s_force * -1.0 * s_damping
		velocity.x = move_toward(velocity.x, velocity.x + force.x * delta, p_acceleration * delta)
		velocity.z = move_toward(velocity.z, velocity.z + force.z * delta, p_acceleration * delta)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("pull_spring"):
		#print("pulling")
		corazon.pulled = true
		is_pulling = true
	elif Input.is_action_just_released("pull_spring"):
		is_pulling = false
		corazon.pulled = false
	if Input.is_action_just_pressed("repel"):
		attack.emit()
