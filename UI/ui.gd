extends Control

@onready var player: CharacterBody3D = %Player
@onready var hp_bar: TextureProgressBar = $Panel/Health
@onready var cooldown_bar: TextureProgressBar = $Panel/Cooldown
@onready var sprite: AnimatedSprite2D = $SubViewport/AnimatedSprite2D

func _ready() -> void:
	pass
	#_update_ui_colors()

func _update_ui_colors() -> void:
	if cooldown_bar.value < cooldown_bar.max_value * 0.25:
		cooldown_bar.modulate = Color(1, 0.3, 0.3) 
	else:
		cooldown_bar.modulate = Color(0.3, 0.8, 1)
	
	if hp_bar.value < hp_bar.max_value * 0.3:
		hp_bar.modulate = Color(1, 0.2, 0.2)  
	elif hp_bar.value < hp_bar.max_value * 0.6:
		hp_bar.modulate = Color(1, 0.8, 0.2)  
	else:
		hp_bar.modulate = Color(0.2, 1, 0.2) 

func _on_player_health_changed(new_health: float) -> void:
	hp_bar.value = new_health
	#_update_ui_colors()

func _on_player_cooldown_changed(new_cooldown: float) -> void:
	cooldown_bar.value = new_cooldown
	#_update_ui_colors()


func _on_player_using_energy(status: Variant) -> void:
	if status:
		sprite.play("use")
	else:
		sprite.play("normal")
