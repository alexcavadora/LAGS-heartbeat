extends Node
class_name EnemyAI

@onready var enemy = $".."
@export var speed: float = 5.0
@export var vis_range: float = 8.0
@export_range(0.0, 1.0) var physics_skip_frames: int = 2

@onready var timer: Timer = $Timer

var player
var real_speed: float
var is_in_hit_stun: bool = false
var wandering: bool = true
var has_seen_player: bool = false
var wander_direction: Vector3
var frame_count: int = 0
var cached_player_pos: Vector3
var direction: Vector3
var last_distance: float = INF

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	real_speed = speed
	wander_direction = new_wander_direction()
	if player and player.has_node("center"):
		cached_player_pos = player.center.global_position
		direction = (cached_player_pos - enemy.global_position).normalized()

func _physics_process(_delta: float) -> void:
	frame_count = (frame_count + 1) % (physics_skip_frames + 1)
	if frame_count != 0:
		enemy.apply_central_force(direction * real_speed)
		return
		
	if is_in_hit_stun or not player:
		return

	cached_player_pos = player.center.global_position
	var to_player = cached_player_pos - enemy.global_position
	var distance = to_player.length_squared()
	if abs(distance - last_distance) > 0.5 or wandering:
		last_distance = distance

		if not has_seen_player and distance < vis_range * vis_range:
			has_seen_player = true
			wandering = false
			timer.stop()

		if has_seen_player:
			real_speed = speed
			direction = to_player.normalized()
		else:
			direction = wander_direction

	enemy.apply_central_force(direction * real_speed)

func _on_hit_received(_damage: float) -> void:
	is_in_hit_stun = true
	real_speed = 0
	enemy.set_collision_layer_value(1, false)
	enemy.set_collision_mask_value(1, false)
	timer.stop()

func _on_hit_ended() -> void:
	is_in_hit_stun = false
	real_speed = speed
	enemy.set_collision_layer_value(1, true)
	enemy.set_collision_mask_value(1, true)
	wander_direction = new_wander_direction()

func _on_dead() -> void:
	var mask = 0
	enemy.collision_layer = mask
	enemy.collision_mask = mask
	timer.stop()
	set_physics_process(false)

func new_wander_direction() -> Vector3:
	return Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _on_timer_timeout() -> void:
	if wandering:
		wander_direction = new_wander_direction()


func _on_tetherer_tethered(status: Variant) -> void:
	if status:
		speed = speed/2
	else:
		speed = speed*2
