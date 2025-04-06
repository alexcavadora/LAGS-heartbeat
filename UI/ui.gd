extends Control

@onready var player: CharacterBody3D = %Player
@onready var hp_bar: TextureProgressBar = $Panel/Health 
@onready var cooldown_bar: TextureProgressBar = $Panel/Cooldown
@onready var sprite: AnimatedSprite2D = $SubViewport/AnimatedSprite2D
@onready var minimap: Panel = $Minimap

const READY = Color(1,1,1,0.2)
const UNLOCKED = Color(1,1,1,1)
const HIDDEN = Color(0,0,0,0)
var inner_ring = range(1,7,1)
var outer_ring = range(7, 19, 1)

var first_complete = false
var inner_ring_complete = false


func _ready() -> void:
	_update_minimap(-1)

func _update_minimap(idx):
	if idx == 0:
		first_complete = true
	elif idx < 7:
		inner_ring.erase(idx)
	else:
		outer_ring.erase(idx)
	inner_ring_complete = inner_ring.size() == 0
	
	for i in range(minimap.get_child_count()):
		if i in inner_ring and first_complete:
			minimap.get_child(i).modulate = READY
		elif i in inner_ring:
			minimap.get_child(i).modulate = HIDDEN
		elif i in outer_ring and inner_ring_complete:
			minimap.get_child(i).modulate = READY
		elif i in outer_ring:
			minimap.get_child(i).modulate = HIDDEN
		else:
			minimap.get_child(i).modulate = UNLOCKED

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
