extends Node2D

@export var bullet_scene: PackedScene 
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	
	# Get the current frame from the animation (0, 1, 2, or 3)
	var current_frame = $AnimatedSprite2D.frame
	
	# Shoot Left
	if current_frame == 0: 
		bullet.global_position = $SpawnLeft.global_position
		bullet.direction = Vector2(-1, -1).normalized()
		
	# Shoot Middle (This handles BOTH frame 1 and frame 3!)
	elif current_frame == 1 or current_frame == 3: 
		bullet.global_position = $SpawnCenter.global_position
		bullet.direction = Vector2(0, -1)
		
	# Shoot Right
	elif current_frame == 2: 
		bullet.global_position = $SpawnRight.global_position
		bullet.direction = Vector2(1, -1).normalized()


func _on_timer_timeout() -> void:
	shoot_sound.play()
	shoot() # Replace with function body.
