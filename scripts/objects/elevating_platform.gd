extends Area2D

@onready var sprite = $AnimatedSprite2D # Make sure this matches your animation node name!

# --- SETTINGS YOU CAN CHANGE IN THE INSPECTOR ---
@export var target_platform: Node2D
@export var move_distance: float = 100.0 # How high it goes (in pixels)
@export var move_speed: float = 2.0      # How many seconds it takes

# --- INTERNAL MEMORY ---
var original_y: float
var is_pressed: bool = false
var current_tween: Tween

func _ready() -> void:
	# Remember where the platform started so it knows where to return!
	if target_platform != null:
		original_y = target_platform.global_position.y

# --- WHEN THE PLAYER STEPS ON IT ---
func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter" and is_pressed == false:
		is_pressed = true
		sprite.play("press") # Push the button down
		
		if target_platform != null:
			if current_tween:
				current_tween.kill() # Stop any current movement
				
			current_tween = create_tween()
			var target_y = original_y - move_distance # Calculate the new height (negative Y is UP)
			current_tween.tween_property(target_platform, "global_position:y", target_y, move_speed)

# --- WHEN THE PLAYER STEPS OFF IT ---
func _on_body_exited(body: Node2D) -> void:
	if body.name == "PlayerCharacter" and is_pressed == true:
		is_pressed = false
		sprite.play("default") # Pop the button back up
		
		if target_platform != null:
			if current_tween:
				current_tween.kill()
				
			current_tween = create_tween()
			current_tween.tween_property(target_platform, "global_position:y", original_y, move_speed)
