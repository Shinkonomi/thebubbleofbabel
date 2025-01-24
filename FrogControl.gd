extends CharacterBody3D

# Constants
const GRAVITY: float = -9.8  # Gravity force
const JUMP_FORCE: float = 15.0  # Jump strength

# Variables
var is_on_ground: bool = true

func _process(delta: float) -> void:
	# Apply gravity if not on the ground
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Directly use the built-in velocity

	# Move the character using the built-in velocity
	move_and_slide()


func _input(event: InputEvent) -> void:
	# Check for space key press
	if event.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE  # Set the jump force to the built-in velocity.ynt

func _ready() -> void:
	# Ensure an InputMap action is set up for the space key
	if not InputMap.has_action("ui_accept"):
		InputMap.add_action("ui_accept")
		InputMap.action_add_event("ui_accept", InputEventKey.new().set_physical_key(KEY_SPACE))
