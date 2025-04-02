class_name Enemy
extends RigidBody3D
@onready var health: Node = $Health
@onready var hitbox: Area3D = $Hitbox
@onready var enemy_health: ProgressBar = $SubViewport/Control/Enemy_health
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var mesh: MeshInstance3D = $Mesh

var PlayerNode : Eye

func _ready() -> void:
	PlayerNode = get_tree().get_first_node_in_group("Player")
	enemy_health.max_value = health.health
	enemy_health.value = health.health

func active(state):
	#print(hitbox.monitoring)
	hitbox.hurting(state)


func _on_health_just_hit(health: Variant) -> void:
	enemy_health.value = health
	enemy_health.show()
	particles.emitting = true
	if enemy_health.value == 0:
		enemy_health.hide()


func _on_hitbox_finish_hit() -> void:
	particles.emitting = false
