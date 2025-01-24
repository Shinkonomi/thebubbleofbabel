extends Area3D

# Constants
const GRAVITY: float = -9.8
const AIR_RESISTANCE: float = 8.0

# Variables
var velocity: Vector3 = Vector3.ZERO
var speed: float = 3.0  # Speed of the bubble

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	# Connect the signal for collision detection
	connect("body_entered", Callable(self, "_on_body_entered"))
	

func _physics_process(delta: float) -> void:
	# Apply gravity to the bubble's vertical velocity
	velocity.y += (GRAVITY + AIR_RESISTANCE) * delta

	# Apply air resistance to the velocity
	velocity.x -= velocity.x * (delta/10)

	# Move the bubble
	global_transform.origin += velocity * delta
	global_transform.origin.x += randf_range(-0.01, 0.01)

func set_velocity(new_velocity: Vector3) -> void:
	# Set the direction and speed of the bubble
	velocity = new_velocity.normalized() * speed
	$CollisionShape3D.disabled = true
	await(1000)
	#$CollisionShape3D.disabled = false

func _on_body_entered(body: Node) -> void:
	# Handle collision with enemies
	if body.has_method("take_damage"):
		body.take_damage(1)  # Deal 1 damage
	queue_free()  # Destroy the bubble after hitting something
