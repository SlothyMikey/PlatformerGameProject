extends Node2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("jump_launch"):
		jump_sound.play()
		body.jump_launch(body.jump_pad_height) # Using a hardcoded number temporarily to test
		$AnimatedSprite2D.play("bounce")
