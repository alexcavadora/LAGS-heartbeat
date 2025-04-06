class_name Spawner
extends Node
@export var enemy : PackedScene
@export var amount : int = 10

var instance

func spawn():
	for i in range(amount):
		instance = enemy.instantiate()
		instance.global_position = get_parent().global_position
		get_parent().get_parent().add_child(instance)
	return true
