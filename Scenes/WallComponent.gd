extends CollisionShape3D
class_name WallComponent
@onready var Detector : Area3D
signal LastDetected(ownthing)

func _ready():
	for i in get_children():
		if i is Area3D:
			Detector = i
			Detector.body_entered.connect(emitlast)
	

func emitlast(body):
	if body is Eye:
		LastDetected.emit(self)
