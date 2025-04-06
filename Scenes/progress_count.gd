extends Sprite3D
@onready var animationp= $"../AnimationPlayer"
@onready var progress_bar = $SubViewport/Control/ProgressBar

func _process(delta):
	if animationp.current_animation == "GoUp":
		progress_bar.value =  round(animationp.current_animation_position)*10
