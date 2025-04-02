extends Area3D
var damage = 0
var is_hurting = false
signal finish_hit()
@onready var enemy = $".."

func _physics_process(_delta: float) -> void:
	if is_hurting == true and !get_parent().is_class("Eye"):
		damage = get_parent().linear_velocity.length()
	

func hurting(state):
	is_hurting = state
	monitoring = true

func hurt_timer(time):
	time = min(2, time)
	#print(time)
	if !monitoring:
		monitoring = true
		is_hurting = true
		enemy.set_collision_layer_value(1,false)
		enemy.set_collision_mask_value(1, false)
		await get_tree().create_timer(time).timeout
		enemy.set_collision_layer_value(1,true)
		enemy.set_collision_mask_value(1, true)
		print("timeout")
		monitoring = false
		finish_hit.emit()
		is_hurting = false
	

func _on_body_entered(body: RigidBody3D) -> void:
	if body.is_in_group("enemy"):
		body.health.hit(damage)
		body.hitbox.hurt_timer(damage)
