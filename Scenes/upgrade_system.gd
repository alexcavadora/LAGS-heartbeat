extends Control
@onready var gpu_particles_3d = $Node3D/GPUParticles3D


@export var UpgradeArray : Array = ["Cord Length +", 
								"Hearth Size +", 
								"Energy Regeneration +",
								"Movement Speed +",
								"Push +"]
@onready var button_1 = $Button1
@onready var button_2 = $Button2
@export var player : Eye

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	gpu_particles_3d.restart()
	gpu_particles_3d.emitting = true
	get_tree().paused = true
	var random1 = randi_range(0,4)
	var random2 = randi_range(0,4)
	print(random1,random2)
	if random2 == random1:
		random2 = randi_range(0,4)
		button_1.text = UpgradeArray[random1]
		button_2.text = UpgradeArray[random2]
	else:
		button_1.text = UpgradeArray[random1]
		button_2.text = UpgradeArray[random2]
	


func _on_button_1_pressed():
	get_tree().paused = false
	self.queue_free()
	if player != null:
		pass


func _on_button_2_pressed():
	get_tree().paused = false
	self.queue_free()
