extends CharacterBody3D

@onready var heart: RigidBody3D = $Heart

# spring properties
@export var s_force: float = 2000.0
@export var s_max_distance: float = 8.0
@export var s_damping: float = 0.7
var is_pulling: bool = false

# player movement
@export var p_move_speed: float = 7.0
@export var p_acceleration: float = 50.0
@export var p_deceleration: float = 35.0
@export var p_pull_acceleration: float = 2000
var p_current_pull_force: float = 0.0 
var p_current_speed = p_move_speed
var p_moving = false

#cooldown variables
@export var c_max : float = 2
var cooldown = c_max
var c_drain_speed = 0.01
var c_regen_speed = 0.005

func _physics_process(delta):
	# movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		if not p_moving:
			velocity.x = move_toward(velocity.x, 0, 100 * p_deceleration * delta)
			velocity.z = move_toward(velocity.z, 0, 100 * p_deceleration * delta)
			p_moving = true
		velocity.x = move_toward(velocity.x, direction.x * p_current_speed, p_acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * p_current_speed, p_acceleration * delta)
	else:
		p_moving = false
		velocity.x = move_toward(velocity.x, 0, p_deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, p_deceleration * delta)
	
	#chained_physics
	get_pulled(delta)
	if !is_pulling or cooldown <= 0:
		p_current_pull_force = 0.0 
		heart.linear_velocity.x = move_toward(heart.linear_velocity.x, 0,  p_deceleration * delta)
		heart.linear_velocity.z = move_toward(heart.linear_velocity.z, 0,  p_deceleration * delta)
		p_current_speed = p_move_speed
	elif cooldown > 0:
		cooldown = max(cooldown -c_drain_speed, 0)
		p_current_speed = p_move_speed / 2
		pull_heart(delta)
		p_current_pull_force = min(p_current_pull_force + p_pull_acceleration * delta, s_force)
	if !is_pulling:
		if cooldown < c_max:
			cooldown = min(cooldown + c_regen_speed, c_max) 
		
	
	#print(cooldown)
	move_and_slide()

func pull_heart(delta):
	var to_heart = heart.global_position - global_position

	var distance = to_heart.length()
	var direction = to_heart.normalized()
		
	var pull_strength = p_current_pull_force * delta
	var pull_force = - direction * pull_strength * distance * distance

	heart.apply_central_force(pull_force)

func get_pulled(delta):
	var to_player = global_position - heart.global_position

	var distance = to_player.length()
	
	if distance > s_max_distance:
		var exceed = distance - s_max_distance
		var direction = to_player.normalized()
		
		var force = direction * exceed * s_force * -1.0
		
		var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
		force -= horizontal_velocity * s_damping
		
		velocity.x += force.x * delta
		velocity.z += force.z * delta
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pull_spring"):
		#print("pulling")
		is_pulling = true
	else:
		is_pulling = false
