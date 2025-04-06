extends Node3D
@onready var tutorial_component : TutorialComponent = $BegginingStugg/TutorialComponent
@onready var enemy_parts = $BegginingStugg/EnemyParts
@onready var stuffparts = $BegginingStugg/Stuffparts
@onready var loading = $BegginingStugg/Loading
@onready var animation_player = $BegginingStugg/AnimationPlayer
@onready var dialog_box : DialogComponent3D = $Player/DialogBox

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _ready():
	animation_player.play("RESET")
	enemy_parts.emitting = true
	stuffparts.emitting = true
	await enemy_parts.finished
	loading.queue_free()
	await stuffparts.finished
	get_tree().paused = true
	animation_player.play("Intro")
	enemy_parts.queue_free()
	stuffparts.queue_free()
	


func _on_animation_player_animation_finished(anim_name):
	get_tree().paused = false
	if tutorial_component.tutoskip == false:
		dialog_box.InputEnable = true
		dialog_box.Timerstart = true
		dialog_box.timer.start()
