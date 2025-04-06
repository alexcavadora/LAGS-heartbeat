extends RigidBody3D
class_name Boss
@onready var health: Node = $Health
@onready var hitbox: Area3D = $Hitbox
@onready var enemy_health: ProgressBar = $SubViewport/Control/Enemy_health
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite
@export var enemy_name = ""
@onready var attacker: Attacker = $Attacker
var player_node: Eye
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

@export var anim = false

var max_health: float = 0.0
var is_stunned: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const ANIM_MOVING: String = "Moving"
const ANIM_STUN: String = "Stun"
const ANIM_DEATH: String = "Die"
const ANIM_ATTACK: String = "Attack"

@export var player : Eye
@export var heart_boss : Heart_boss

@export_enum("Chasing", "Orbiting_Payer", "Orbiting_Heart") var state : int 

func _ready() -> void:
	if anim:
		animation_player.play("surround_2")
		animated_sprite.flip_h = true
	else:
		animation_player.play("surround")
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
	attacker.target = null
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
	attacker.monitoring = true


func _on_attacker_attacked() -> void:
	animated_sprite.play(ANIM_ATTACK)
	await animated_sprite.animation_finished
	animated_sprite.play(ANIM_MOVING)

func _on_health_dead() -> void:
	animated_sprite.play(ANIM_DEATH)
