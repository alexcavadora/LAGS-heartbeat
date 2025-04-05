extends Node3D
class_name  HexAnimComponent
@export var animation_player : AnimationPlayer


func _on_fixed_hex_anim_toggle(NextAnim):
	if animation_player != null:
		animation_player.play(NextAnim)
