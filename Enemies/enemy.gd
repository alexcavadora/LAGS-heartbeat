class_name Enemy
extends RigidBody3D
@onready var health: Node = $Health
@onready var hitbox: Area3D = $Hitbox
@onready var enemy_health: ProgressBar = $SubViewport/Control/Enemy_health
@onready var particles: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
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
