extends Node
@export var health = 100
var max_health = health
@export var attack_cooldown = 0.5
@onready var timer: Timer = $Timer
@export var IE_frames = false
var hit_ready = true

signal just_hit(health)
signal dead()

func hit(damage: float):
	if IE_frames and !hit_ready:
		return
	elif IE_frames and hit_ready:
		hit_ready = false
		timer.start(attack_cooldown)
	
	health = max(health - damage, 0)
	just_hit.emit(health)
	if health == 0:
		dead.emit()

func heal(hp: float):
	health = min(health + hp, max_health)
	
func _on_hitbox_finish_hit() -> void:
	if health == 0:
		get_parent().queue_free()
		

func _on_timer_timeout() -> void:
	hit_ready = true
