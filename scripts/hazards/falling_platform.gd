extends RigidBody2D

@onready var timer: Timer = $Timer


# Optional: Add a variable to ensure the timer only starts once
var is_triggered = false

func _ready():
	# Ensure the platform starts frozen
	freeze = true

# Connected from PlayerDetector's body_entered signal
func _on_player_detector_body_entered(body):
	if body.is_in_group("Player") and not is_triggered:
		print("It was the player!")     # <--- Add this
		is_triggered = true
		timer.start()

# Connected from FallTimer's timeout signal
func _on_fall_timer_timeout():
	# Unfreeze the platform so gravity takes over
	freeze = false
