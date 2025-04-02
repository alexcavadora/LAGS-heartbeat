extends Area3D
var damage = 0
@export var is_hurting = false
signal finish_hit()
@onready var enemy = $".."

func _physics_process(_delta: float) -> void:
	if is_hurting == true and !get_parent().is_class("Eye"):
		damage = get_parent().linear_velocity.length()

func hurting(state):
	is_hurting = state
	monitoring = state

func hurt_timer(time):
	time = min(1.5, time)
	#print(time)
	if !is_hurting:
		hurting(true)
		await get_tree().create_timer(time).timeout
		hurting(false)
		finish_hit.emit()
	

func _on_body_entered(body: RigidBody3D) -> void:
	if body.is_in_group("enemy") and damage > 0:
		body.health.hit(damage)
		body.hitbox.hurt_timer(damage)
