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

@onready var random1 = randi_range(0,4)
@onready var random2 = randi_range(0,4)
@onready var Stay : bool = true

func _process(delta):
	if Stay == true:
		get_tree().paused = true
	

func _ready():
	button_1.grab_focus()
	
	player = get_tree().get_first_node_in_group("Player")
	set_process_input(false)
	gpu_particles_3d.restart()
	gpu_particles_3d.emitting = true
	get_tree().paused = true
	
	print(random1,random2)
	if random2 == random1:
		random2 = randi_range(0,4)
		button_1.text = UpgradeArray[random1]
		button_2.text = UpgradeArray[random2]
	else:
		button_1.text = UpgradeArray[random1]
		button_2.text = UpgradeArray[random2]
	


func _on_button_1_pressed():
	Stay = false
	get_tree().paused = false
	set_process_input(false)
	if player != null:
		player.upgrades.Upgrade(UpgradeArray, random1)
	Input.flush_buffered_events()
	player.is_pulling = false
	player.corazon.pulled = false
	self.queue_free()


func _on_button_2_pressed():
	Stay = false
	get_tree().paused = false
	set_process_input(false)
	if player != null:
		player.upgrades.Upgrade(UpgradeArray, random2)
	Input.flush_buffered_events()
	player.is_pulling = false
	player.corazon.pulled = false
	self.queue_free()
