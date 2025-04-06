extends Node
const UPGRADE_SYSTEM = preload("res://Scenes/upgrade_system.tscn")
func _on_health_dead():
	var instance = UPGRADE_SYSTEM.instantiate()
	get_tree().current_scene.add_child(instance)
	
