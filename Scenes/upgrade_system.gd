extends Control
@onready var gpu_particles_3d = $Node3D/GPUParticles3D

@onready var cube1 = $CardUpradge_animation/Cube
@onready var cube2 = $CardUpradge_animation2/Cube

@onready var animation_player1 : AnimationPlayer = $CardUpradge_animation/AnimationPlayer
@onready var animation_player2 : AnimationPlayer = $CardUpradge_animation2/AnimationPlayer


const CARDUV_HEARTSIZE_BW = preload("res://assets/powerup/CardPowerup/carduv_heartsize_bw.png")
const CARDUV_LONG_BW = preload("res://assets/powerup/CardPowerup/carduv_long_bw.png")
const CARDUV_REG_BW = preload("res://assets/powerup/CardPowerup/carduv_reg_bw.png")
const CARDUV_SPEED_BW = preload("res://assets/powerup/CardPowerup/carduv_speed_bw.png")
const CARDUV_STRENGHT_BW = preload("res://assets/powerup/CardPowerup/carduv_strenght_bw.png")

@onready var cardarray : Array = [CARDUV_LONG_BW, CARDUV_HEARTSIZE_BW, CARDUV_REG_BW, CARDUV_SPEED_BW, CARDUV_STRENGHT_BW]

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
		var material1 : StandardMaterial3D = cube1.material_override
		material1.albedo_texture = cardarray[random1]
		var material2 : StandardMaterial3D = cube2.material_override
		material2.albedo_texture = cardarray[random2]

	else:
		button_1.text = UpgradeArray[random1]
		button_2.text = UpgradeArray[random2]
		var material1 : StandardMaterial3D = cube1.material_override
		material1.albedo_texture = cardarray[random1]
		var material2 : StandardMaterial3D = cube2.material_override
		material2.albedo_texture = cardarray[random2]

	


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
