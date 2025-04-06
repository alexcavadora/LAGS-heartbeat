extends Node3D
class_name EnemieSound
const ENEMIE_ATTACK = preload("res://assets/SFX/Enemie Attack.mp3")
const ENEMIE_STUN = preload("res://assets/SFX/Enemie stun.mp3")
const ENEMY_DEATH = preload("res://assets/SFX/Enemy Death.mp3")

@onready var currentsound
@onready var audios : AudioStreamPlayer3D = $AudioStreamPlayer3D

func play_sound(sound):
	audios.stream = sound
	audios.playing = true

func _on_health_dead():
	print("Sounding Death")
	play_sound(ENEMY_DEATH)


func _on_health_just_hit(health):
	print("Sounding Hit")
	play_sound(ENEMIE_STUN)


func _on_attacker_attacked():
	print("Sounding Attack")
	play_sound(ENEMIE_ATTACK)
