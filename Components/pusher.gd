extends Area3D
#attack variable
@export var a_magnitude = 20.0
@onready var cooldown: Timer = $Timer

func _on_body_entered(body: Node3D) -> void:
	var force = (body.global_position - global_position).normalized() * a_magnitude
	body.apply_central_force(force)

func _on_player_attack() -> void:
	if cooldown.paused:
		cooldown.start()
		monitoring = true
		monitoring = false
