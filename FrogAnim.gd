extends Node

# Preload textures into an array
var textures: Array = [
	preload("res://Art/Intermediate/other/in progress/Untitled 3.png"),
	preload("res://Art/Intermediate/other/in progress/NormalMap.png"),
	preload("res://Art/Intermediate/other/in progress/Frog.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



var current_index: int = 0  # Index to track current texture
var time_passed: float = 0.0  # To control texture change rate
var change_interval: float = 0.1  # Time (in seconds) between texture changes

func _process(delta: float) -> void:
	var mesh_instance = $"."
	if mesh_instance == null:
		print("MeshInstance3D not found!")
		return

	time_passed += delta
	if time_passed >= change_interval:
		time_passed = 0.0
		
		# Cycle through textures
		current_index = (current_index + 1) % textures.size()
		
		# Ensure the material exists
		var material = mesh_instance.get_surface_override_material(0)
		if material == null:
			material = StandardMaterial3D.new()
			mesh_instance.set_surface_override_material(0, material)

		# Set the albedo texture
		if material is StandardMaterial3D:
			material.albedo_texture = textures[current_index]
