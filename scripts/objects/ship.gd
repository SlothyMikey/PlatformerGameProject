extends Area2D

@onready var warning_label: Label = $warningLabel
@onready var hide_timer: Timer = $Timer

func _ready() -> void:
	warning_label.hide() # Make sure it is hidden when the game starts!

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter": 
		
		if body.has_diesel == true:
			# --- VICTORY ---
			if body.has_node("UI/WinScreen"):
				# 1. Show the Win Screen
				body.get_node("UI/WinScreen").show()
				
				# 2. Hide the Diesel Icon!
				if body.has_node("UI/DieselIcon"):
					body.get_node("UI/DieselIcon").hide()
					
				# 3. Freeze the game
				get_tree().paused = true
				
		else:
			# --- NO DIESEL! ---
			warning_label.show() # Show the floating text
			hide_timer.start()   # Start the 2-second countdown!
			
func _on_timer_timeout() -> void:
	warning_label.hide() # Hide the text when the timer runs out!
