extends CharacterBody3D

# Constants
const GRAVITY: float = -9.8
const MIN_JUMP_FORCE: float = 2.0
const MAX_JUMP_FORCE: float = 15.0
const JUMP_CHARGE_RATE: float = 4.0
const BUBBLE_SPEED: float = 10.0  # Speed of the bubbleng space

var sitAnim_Albedo: Array = [
	preload("res://Art/Intermediate/animation/jumping/1.png"),
	preload("res://Art/Intermediate/animation/jumping/2.png"),
	preload("res://Art/Intermediate/animation/jumping/3.png")
]
var sitAnim_Normal: Array = [
	preload("res://Art/Intermediate/animation/jumping/1_NormalMap.png"),
	preload("res://Art/Intermediate/animation/jumping/2_NormalMap.png"),
	preload("res://Art/Intermediate/animation/jumping/3_NormalMap.png")
]
var jumpAnim_Albedo: Array = [
	preload("res://Art/Intermediate/animation/jumping/4.png")
]
var jumpAnim_Normal: Array = [
	preload("res://Art/Intermediate/animation/jumping/4_NormalMap.png")
]

# Variables
var speed: float = 3.0
var health: int = 5  # Initial health

# Jump charge state
var jump_force: float = MIN_JUMP_FORCE  # Initial jump force

# Input state
var is_space_held: bool = false  # Tracks if space is being held
var is_facing_right: bool = true  # Tracks if the character is facing right

# Bubble scene
var bubble_scene: PackedScene = preload("res://Bubble.tscn")

func _ready() -> void:
	# Ensure the character has a CollisionShape3D
	if not $CollisionShape3D:
		print("No CollisionShape3D found! Please add one.")
		return
	# Optional: Check if the shape is set (e.g., capsule or box)
	if $CollisionShape3D.shape == null:
		print("Collision shape is not set!")
		return

func setTexture(material, array, index) -> void:
	if material is StandardMaterial3D:
			material.albedo_texture = array[index] 

# Sit texture index
var sitIndex = 0
func _process(delta: float) -> void:
	# Mesh Instance
	var mesh_instance = $MeshInstance3D
	if mesh_instance == null:
		print("MeshInstance3D not found!")
		return
	var material = mesh_instance.get_surface_override_material(0)
	if material == null:
		material = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(0, material)

	# Apply gravity if the character is not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Apply gravity to vertical movement
	
	# Move the character using the velocity
	move_and_slide()
	
	# If space is held, increase jump force up to the cap
	if is_space_held:
		jump_force = min(jump_force + JUMP_CHARGE_RATE * delta, MAX_JUMP_FORCE)


	# Flip the character's scale based on the facing direction (left or right)
	if not is_facing_right and velocity.x > 0:
		# Flip character to face right
		scale.x = abs(scale.x)  # Make sure the character is facing right
		is_facing_right = true
	elif is_facing_right and velocity.x < 0:
		# Flip character to face left
		scale.x = -abs(scale.x)  # Flip character to face left
		is_facing_right = false
	if is_facing_right:
		if is_on_floor() == false:
			velocity.x = speed
		else:
			velocity.x = 0
	else:
		if is_on_floor() == false:
			velocity.x = -speed
		else:
			velocity.x = 0
	if is_on_floor() and is_space_held == false:
		sitIndex = 0
		setTexture(material, sitAnim_Albedo, sitIndex)

func _input(event: InputEvent) -> void:
	# Mesh Instance
	var mesh_instance = $MeshInstance3D
	if mesh_instance == null:
		print("MeshInstance3D not found!")
		return
	var material = mesh_instance.get_surface_override_material(0)
	if material == null:
		material = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(0, material)
	# Detect when space is held or released
	if event.is_action_pressed("ui_accept"):
		is_space_held = true  # Start charging the jump force when space is pressed
		# Set the albedo texture
		if is_on_floor():
			sitIndex = 1
			setTexture(material, sitAnim_Albedo, sitIndex)
			sitIndex = 2
			setTexture(material, sitAnim_Albedo, sitIndex)
	elif event.is_action_released("ui_accept"):
		setTexture(material, jumpAnim_Albedo, 0)
		# Jump when space is released
		if is_on_floor():
			# Apply the jump force vertically
			velocity.y = jump_force  # Apply the jump force vertically

			# Reset the jump force after jumping
			jump_force = MIN_JUMP_FORCE
		is_space_held = false  # Stop charging jump force when space is released

	# Debugging print statements to check input actions
	if Input.is_action_pressed("move_right"):
		if not is_facing_right:
			# Flip character to face right if moving right
			scale.x = abs(scale.x)
			is_facing_right = true
	elif Input.is_action_pressed("move_left"):
		if is_facing_right:
			# Flip character to face left if moving left
			scale.x = -abs(scale.x)
			is_facing_right = false
	else:
		velocity.x = 0
		
	# Shoot bubble
	if event.is_action_pressed("shoot_bubble_right"):
		shoot_bubble()
		
func shoot_bubble():
	# Check if the BubbleScene is loaded
	if bubble_scene == null:
		print("BubbleScene not set or preloaded!")
		return

	# Spawn a bubble instance
	var bubble = bubble_scene.instantiate()  # Use 'instantiate' to create an instance
	get_parent().add_child(bubble)  # Add the bubble to the game scene

	# Set the bubble's position to the character's position
	bubble.global_transform.origin = global_transform.origin

	# Set the bubble's velocity
	var direction = Vector3.ZERO
	if is_facing_right:
		direction = Vector3(1, 1, 0)  # Replace with your desired direction
	else:
		direction = Vector3(-1, 1, 0)
	bubble.set_velocity(direction)


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	print("Game Over")
	queue_free()
