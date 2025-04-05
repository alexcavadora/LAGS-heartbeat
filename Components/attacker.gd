class_name Attacker
extends Area3D

@export var contact_damage: float = 10.0
@export var damage_interval: float = 0.5

var target = null
var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = damage_interval
	timer.one_shot = false
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_body_entered(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		target = body
		timer.start()
		_apply_damage()

func _on_body_exited(body: Node3D) -> void:
	if body == target:
		target = null
		timer.stop()

func _on_timer_timeout() -> void:
	_apply_damage()

func _apply_damage() -> void:
	if target != null:
		target.health.hit(contact_damage)
