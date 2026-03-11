extends Area2D

@onready var game_manager: Node = $"../../Game Manager"
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_coin"):
		body.add_coin()
	game_manager.add_point()
	
	# 1. Hide the coin so the player thinks it's gone
	visible = false 
	
	# 2. Turn off the collision so the player can't collect the invisible coin twice!
	$CollisionShape2D.set_deferred("disabled", true)
	
	# 3. Play the sound
	pickup_sound.play()
	
	# 4. Tell the code to pause right here and wait for the sound to finish
	await pickup_sound.finished 
	
	# 5. NOW delete the coin safely!
	queue_free()
