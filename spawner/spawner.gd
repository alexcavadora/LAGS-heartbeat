extends Node3D
class_name Spawner3D


var amount = 0

signal tile_finished()

func _ready() -> void:
	amount = get_child_count()
	#print("ready:", amount)

func dead_counter():
	amount -= 1
	if amount == 0:
		tile_finished.emit()
		print(tile_finished)
