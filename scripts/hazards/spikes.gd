extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if body.is_invincible == false:
			body.jump_launch(-300)
			body.take_damage(1) 
