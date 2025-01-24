extends Node3D  # Script is attached to the parent Node3D

var time: float = 0.0  # To track elapsed time
var speed: float = 2.0  # Speed of the movement
var distance: float = 0.1  # Distance the light travels


func _process(delta: float) -> void:
	time += delta
	# Move the parent Node3D
	if time > 0.5:
		distance = -distance
		time = 0.0
	position = position + Vector3(distance * speed, 0, 0)  # Adjust the axis if needed
