extends Node
@export var health = 10
signal just_hit(health)
signal dead()
func hit(damage: float):
	health = max(health - damage, 0)
	if health < 0:
		health = 0
	just_hit.emit(health)
	# print(get_parent(), "hit for: ", damage, "health: ", health)
	# print(health)
	# print(health)

func _on_hitbox_finish_hit() -> void:
	if health == 0:
		dead.emit()
		#print("removing")
		get_parent().queue_free()
