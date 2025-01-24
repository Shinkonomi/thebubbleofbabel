extends CharacterBody3D

# Constants
const GRAVITY: float = -9.8  # Gravity force
const JUMP_FORCE: float = 5.0  # Jump strength

# Speed variables
var speed: float = 5.0  # Running speed

func _ready() -> void:
	# Ensure the character has a CollisionShape3D
	if not $CollisionShape3D:
		print("No CollisionShape3D found! Please add one.")
		return
	# Optional: Check if the shape is set (e.g., capsule or box)
	if $CollisionShape3D.shape == null:
		print("Collision shape is not set!")
		return

func _process(delta: float) -> void:
	# Apply gravity if the character is not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Apply gravity to vertical movement
	
	# Move the character using the velocity
	move_and_slide()  # Vector3.UP indicates the upward direction for sliding

func _input(event: InputEvent) -> void:
	# Handle jump on space key press
	if event.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE  # Set jump force on the Y axis
	
	# Handle horizontal movement using input (e.g., left, right, forward, back)
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1

	# Normalize direction and apply speed
	if direction.length() > 0:
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
