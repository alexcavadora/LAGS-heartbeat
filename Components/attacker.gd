class_name Attacker
extends Area3D
@export var contact_damage = 10

func _on_body_entered(body: Node3D) -> void:
	if body.is_class("Eye"):
		body.health.hit()
