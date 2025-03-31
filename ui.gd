extends Control
@onready var player: CharacterBody3D = %Player
@onready var progress_bar: ProgressBar = $ProgressBar

func _process(delta: float) -> void:
	progress_bar.value = player.cooldown
