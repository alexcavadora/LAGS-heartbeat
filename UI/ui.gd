extends Control
@onready var player: CharacterBody3D = %Player
@onready var cooldown: ProgressBar = $Cooldown
@onready var HP: ProgressBar = $Panel/Health
@onready var speed: Label = $SPEED


func _process(_rdelta: float) -> void:
	cooldown.value = player.cooldown
	HP.value = player.health.health
