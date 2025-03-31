extends CharacterBody3D


# spring properties
@export var spring_force: float = 100.0
@export var max_distance: float = 5.0
@export var spring_damping: float = 0.1
var is_pulling: bool = false

# player movement
@export var move_speed: float = 5.0
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0
@export var pull_acceleration: float = 1.5  
var current_pull_force: float = 0.0 
var current_speed = move_speed
var moving = false

@onready var heart: RigidBody3D = $Heart

func _physics_process(delta):
	# movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		if not moving:
			velocity.x = move_toward(velocity.x, 0, 100 * deceleration * delta)
			velocity.z = move_toward(velocity.z, 0, 100 * deceleration * delta)
			moving = true
		velocity.x = move_toward(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, acceleration * delta)
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
	
	#chained_physics
	get_pulled(delta)
	if !is_pulling:
		current_pull_force = 0.0 
		heart.linear_velocity.x = move_toward(heart.linear_velocity.x, 0,  deceleration * delta)
		heart.linear_velocity.z = move_toward(heart.linear_velocity.z, 0,  deceleration * delta)
		current_speed = move_speed
	else:
		current_speed = move_speed /3.5
		pull_heart(delta)
		current_pull_force = min(current_pull_force + pull_acceleration * delta, spring_force)
	
	move_and_slide()

func pull_heart(delta):
	var to_heart = heart.global_position - global_position
	to_heart.y = 0
	var distance = to_heart.length()
	var direction = to_heart.normalized()
		
	var pull_strength = current_pull_force * delta
	var pull_force = - direction * pull_strength * distance * distance
	pull_force.y = 0
	heart.apply_central_force(pull_force)

func get_pulled(delta):
	var to_player = global_position - heart.global_position
	to_player.y = 0
	var distance = to_player.length()
	
	if distance > max_distance:
		var exceed = distance - max_distance
		var direction = to_player.normalized()
		
		var force = direction * exceed * spring_force * -1.0
		
		var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
		force -= horizontal_velocity * spring_damping
		
		velocity.x += force.x * delta
		velocity.z += force.z * delta
		velocity.y = 0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pull_spring"):
		print("pulling")
		is_pulling = true
	else:
		is_pulling = false
