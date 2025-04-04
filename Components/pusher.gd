extends Area3D
#attack variable
@export var a_magnitude = 20.0
@onready var cooldown: Timer = $Timer

var attack_ready = true

func _on_body_entered(body: Enemy) -> void:
	var force = (body.global_position - global_position).normalized() *a_magnitude* body.mass
	#print(force)
	body.apply_central_impulse(force)
	body.hitbox.hurt_timer(1)

func _on_player_attack() -> void:
	if attack_ready:
		attack_ready = false
		cooldown.start()
		#print(monitoring)
		monitoring = true
		await get_tree().create_timer(0.1).timeout
		monitoring = false

func _on_timer_timeout() -> void:
	attack_ready = true
