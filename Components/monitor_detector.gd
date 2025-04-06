extends Area3D

@onready var movement: EnemyAI = $"../Movement"

func _on_area_entered(area: Area3D) -> void:
	if area.name == "Eyesight":
		movement.has_seen_player = true
		movement.wandering = false
		movement.vis_range = 20


func _on_area_exited(area: Area3D) -> void:
	if area.name == "Eyesight":
		movement.has_seen_player = false
		movement.wandering = true
		movement.vis_range = 0
