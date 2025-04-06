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
			print("Succesful!")
		1:
			if player.corazon != null:
				player.corazon.scale *= 2
		2:
			pass
