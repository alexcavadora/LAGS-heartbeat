class_name Enemy
extends RigidBody3D
@onready var health: Node = $Health
@onready var hitbox: Area3D = $Hitbox
@onready var enemy_health: ProgressBar = $SubViewport/Control/Enemy_health
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var animated_sprite: AnimatedSprite3D

@export var attacker: Attacker
var player_node: Eye

var max_health: float = 0.0
var is_stunned: bool = false

const ANIM_MOVING: String = "Moving"
const ANIM_STUN: String = "Stun"

func _ready() -> void:
	animated_sprite = find_child("AnimatedSprite")
	player_node = get_tree().get_first_node_in_group("Player")
	
	if health:
		max_health = health.health
		_setup_health_ui()
		
	if health and not health.is_connected("just_hit", _on_health_just_hit):
		health.connect("just_hit", _on_health_just_hit)
	if hitbox and not hitbox.is_connected("finish_hit", _on_hitbox_finish_hit):
		hitbox.connect("finish_hit", _on_hitbox_finish_hit)

func _setup_health_ui() -> void:
	if enemy_health:
		enemy_health.max_value = max_health
		enemy_health.value = max_health
		enemy_health.hide()


func active(state: bool) -> void:
	if hitbox:
		hitbox.hurting(state)

func _on_health_just_hit(life: float) -> void:
	if life >= max_health:
		return
		
	if enemy_health:
		enemy_health.value = life
		
		if life <= 0:
			enemy_health.hide()
		else:
			enemy_health.show()
	
	_play_hit_effects()
	
	if attacker:
		attacker.monitoring = false

func _play_hit_effects() -> void:
	if particles:
		particles.restart()
		particles.emitting = true
	
	if animated_sprite:
		animated_sprite.play(ANIM_STUN)
		is_stunned = true

func _on_hitbox_finish_hit() -> void:
	if animated_sprite:
		animated_sprite.play(ANIM_MOVING)
		is_stunned = false
	
	if particles:
		particles.emitting = false
	
	if attacker:
		attacker.monitoring = true
