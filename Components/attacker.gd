class_name Attacker
extends Area3D
@export var contact_damage = 10

var inside = null

func _physics_process(delta: float) -> void:
	if inside != null:
		inside.health.hit(contact_damage)

func _on_body_entered(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		inside = body

func _on_body_exited(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		inside = null
