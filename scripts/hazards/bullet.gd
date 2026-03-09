extends Area2D

var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	rotation = direction.angle()


func _on_body_entered(body: Node2D) -> void:
	# 1. Did we hit the player?
	if body.has_method("take_damage"):
		body.take_damage(1) # Deal 1 damage
		
	# 2. Destroy the bullet when it hits ANYTHING (Player or walls)
	queue_free() # Replace with function body.
