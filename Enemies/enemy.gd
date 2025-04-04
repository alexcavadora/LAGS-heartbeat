class_name Enemy
extends RigidBody3D
@onready var health: Node = $Health
@onready var hitbox: Area3D = $Hitbox
@onready var enemy_health: ProgressBar = $SubViewport/Control/Enemy_health
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var animated_sprite : AnimatedSprite3D
@export var attacker: Attacker

@onready var max_health = health.health
var PlayerNode : Eye

func _ready() -> void:
	
	animated_sprite = find_child("AnimatedSprite")
	PlayerNode = get_tree().get_first_node_in_group("Player")
	enemy_health.max_value = health.health
	enemy_health.value = health.health

func active(state):
	hitbox.hurting(state)
	


func _on_health_just_hit(life: Variant) -> void:
	if life == max_health:
		return
	enemy_health.value = life
	enemy_health.show()
	particles.restart()
	particles.emitting = true
	if enemy_health.value == 0:
		enemy_health.hide()
	if animated_sprite != null:
		animated_sprite.play("Stun")
		#print(hitbox.monitoring)
	if attacker:
		attacker.monitoring = false


func _on_hitbox_finish_hit() -> void:
	if animated_sprite != null:
		animated_sprite.play("Moving")
	particles.emitting = false
		#print(hitbox.monitoring)
	if attacker:
		attacker.monitoring = true
