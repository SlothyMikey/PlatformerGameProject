extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("jump_launch"):
		body.jump_launch(body.jump_pad_height) # Using a hardcoded number temporarily to test
		$AnimatedSprite2D.play("bounce")
