extends Control
@onready var player: CharacterBody3D = %Player
@onready var cooldown: ProgressBar = $Cooldown

func _process(_rdelta: float) -> void:
	cooldown.value = player.cooldown
	
