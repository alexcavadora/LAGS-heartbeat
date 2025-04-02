extends Node
@onready var enemy = $".."
@export var speed: float = 5.0
var player
var is_in_hit_stun: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	if is_in_hit_stun or not player:
		return
		
	var direction = (player.center.global_position - enemy.global_position).normalized()
	enemy.apply_central_force(direction * speed)
	
func _on_hit_received(damage: float) -> void:
	is_in_hit_stun = true
	enemy.linear_velocity = Vector3.ZERO
	enemy.set_collision_layer_value(1,false)
	enemy.set_collision_mask_value(1, false)
	#enemy.mesh.mesh.material.albedo_color = Color.DARK_MAGENTA

func _on_hit_ended():
	#enemy.mesh.mesh.material.albedo_color = Color.CORNFLOWER_BLUE
	enemy.set_collision_layer_value(1,true)
	enemy.set_collision_mask_value(1, true)
	is_in_hit_stun = false
