extends Node3D
class_name EnemieSound
const ENEMIE_ATTACK = preload("res://assets/SFX/Enemie Attack.mp3")
const ENEMIE_STUN = preload("res://assets/SFX/Enemie stun.mp3")
const ENEMY_DEATH = preload("res://assets/SFX/Enemy Death.mp3")

@onready var currentsound
@onready var audios : AudioStreamPlayer3D = $AudioStreamPlayer3D

func play_sound(sound):
	audios.play(sound)


func _on_health_dead():
	play_sound(ENEMY_DEATH)


func _on_health_just_hit(health):
	play_sound(ENEMIE_STUN)


func _on_attacker_attacked():
	play_sound(ENEMIE_ATTACK)
