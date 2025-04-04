class_name Eye extends CharacterBody3D

@onready var center: CollisionShape3D = $CollisionShape3D
@onready var pivot: Node3D = $pivot
@onready var health: Node = $Health

@export var corazon: heart

#spring
@export var s_force: float = 2000.0
@export var s_max_distance: float = 8.0
@export var s_damping: float = 0.7

#player
@export var p_move_speed: float = 7.0
@export var p_acceleration: float = 50.0
@export var p_deceleration: float = 35.0
@export var p_pull_acceleration: float = 2000

#cooldown
@export var c_max: float = 2
@export var c_drain_speed = 0.01
@export var c_regen_speed = 0.005

#cache
var is_pulling: bool = false
var p_current_pull_force: float = 0.0
var p_current_speed: float = 0.0
var cooldown: float = 0.0
var to_player: Vector3
var distance: float = 0.0

var _input_dir: Vector2
var _direction: Vector3
var _zero_vector = Vector3.ZERO

signal updated_health(hp)
signal updated_energy(energy)
signal attack()

func _ready() -> void:
	pivot.global_position = global_position
	p_current_speed = p_move_speed
	cooldown = c_max

func _physics_process(delta: float) -> void:
	pivot.global_position = global_position
	to_player = center.global_position - corazon.global_position
	distance = to_player.length()
	
	_process_movement(delta)
	
	_process_chain_physics(delta)
	
	move_and_slide()
	_handle_collisions()

func _process_movement(delta: float) -> void:
	_input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	_direction = Vector3(_input_dir.x, 0, _input_dir.y).normalized()
	
	if _direction != _zero_vector:
		pivot.look_at(-_direction * 20000 + global_position)
		
		var final_dir = _direction
		if distance > s_max_distance:
			final_dir = -to_player.normalized()
			
		velocity.x = move_toward(velocity.x, final_dir.x * p_current_speed, p_acceleration * delta)
		velocity.z = move_toward(velocity.z, final_dir.z * p_current_speed, p_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, p_deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, p_deceleration * delta)

func _process_chain_physics(delta: float) -> void:
	if distance > s_max_distance:
		var exceed = distance - s_max_distance
		var direction = to_player.normalized()
		var force = direction * exceed * s_force * -1.0 * s_damping
		velocity.x = move_toward(velocity.x, velocity.x + force.x * delta, p_acceleration * delta)
		velocity.z = move_toward(velocity.z, velocity.z + force.z * delta, p_acceleration * delta)
	
	if !is_pulling or cooldown <= 0:
		p_current_pull_force = 0.0
		p_current_speed = p_move_speed
		corazon.pulled = false
	elif is_pulling:
		cooldown = max(cooldown - c_drain_speed, 0)
		updated_energy.emit(cooldown)
		p_current_speed = p_move_speed * 0.5
		_pull_heart(delta)
		p_current_pull_force = min(p_current_pull_force + p_pull_acceleration * delta, s_force)
	
	if !is_pulling and cooldown < c_max:
		cooldown = min(cooldown + c_regen_speed, c_max)
		updated_energy.emit(cooldown)

func _pull_heart(delta: float) -> void:
	var to_corazon = corazon.global_position - center.global_position
	var pull_distance = to_corazon.length()
	var direction = to_corazon.normalized()
	var pull_strength = p_current_pull_force * delta
	var pull_force = -direction * pull_strength * pull_distance * pull_distance
	corazon.apply_central_force(pull_force)

func _handle_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			collider.apply_central_impulse(-collision.get_normal() * collider.mass)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("pull_spring"):
		corazon.pulled = true
		is_pulling = true
	elif Input.is_action_just_released("pull_spring"):
		is_pulling = false
		corazon.pulled = false
	
	if Input.is_action_just_pressed("repel"):
		attack.emit()

func _on_health_just_hit(health: Variant) -> void:
	updated_health.emit(health)
