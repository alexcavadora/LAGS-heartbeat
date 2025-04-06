extends Node
class_name UpgradeComponent
@onready var player = $".."
#@export var UpgradeArray : Array = ["Cord Length +", 
								#"Hearth Size +", 
								#"Energy Regeneration +",
								#"Movement Speed +",
								#"Push +"]


func Upgrade(UpArray:Array ,tryup : int):
	print(UpArray[tryup])
	
	match tryup:
		0:
			player.s_max_distance += 2
			
		1:
			if player.corazon != null:
				player.corazon.scale *= 1.2
		2:
			player.c_regen_speed += 0.001
		3:
			player.p_move_speed += 1
		4:
			player.c_max += 1
			
