extends Node
@onready var enemy = $".."
@export var speed: float = 5.0
var player
@onready var real_speed = speed
var is_in_hit_stun: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(_delta: float) -> void:
	if is_in_hit_stun or not player:
		return
		
	var direction = (player.center.global_position - enemy.global_position).normalized()
	enemy.apply_central_force(direction * real_speed)
	
func _on_hit_received(_damage: float) -> void:
	is_in_hit_stun = true
	real_speed = 0
	enemy.set_collision_layer_value(1,false)
	enemy.set_collision_mask_value(1, false)
	#enemy.mesh.mesh.material.albedo_color = Color.DARK_MAGENTA

func _on_hit_ended():
	#enemy.mesh.mesh.material.albedo_color = Color.CORNFLOWER_BLUE
	is_in_hit_stun = false
	real_speed = speed
	enemy.set_collision_layer_value(1,true)
	enemy.set_collision_mask_value(1, true)


func _on_dead() -> void:
	enemy.set_collision_layer_value(1,false)
