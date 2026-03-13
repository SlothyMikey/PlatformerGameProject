extends Node2D

@export var bullet_scene: PackedScene 
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	
	var current_frame = $AnimatedSprite2D.frame
	
	# If Frame 0 is aiming RIGHT
	if current_frame == 0: 
		bullet.global_position = $SpawnRight.global_position # Use the right spawn point
		bullet.direction = Vector2(1, 1).normalized()        # 1 means shoot RIGHT
		
	# Shoot Middle
	elif current_frame == 1 or current_frame == 3: 
		bullet.global_position = $SpawnCenter.global_position
		bullet.direction = Vector2(0, 1)
		
	# If Frame 2 is aiming LEFT
	elif current_frame == 2: 
		bullet.global_position = $SpawnLeft.global_position  # Use the left spawn point
		bullet.direction = Vector2(-1, 1).normalized()       # -1 means shoot LEFT


func _on_timer_timeout() -> void:
	shoot_sound.play()
	shoot() # Replace with function body.
