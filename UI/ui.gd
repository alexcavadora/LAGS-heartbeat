extends Control
@onready var player: CharacterBody3D = %Player
@onready var cooldown: ProgressBar = $Cooldown
@onready var HP: ProgressBar = $Panel/Health
@onready var speed: Label = $SPEED


func _process(_rdelta: float) -> void:
	cooldown.value = player.cooldown
	HP.value = player.health.health
	speed.text = str("x " + var_to_str(player.velocity.x), "\ny " + var_to_str(player.velocity.y), "\nz " + var_to_str(player.velocity.z) )
