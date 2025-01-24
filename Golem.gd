extends Node3D

var health: int = 3

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	print("Enemy defeated")
	queue_free()
