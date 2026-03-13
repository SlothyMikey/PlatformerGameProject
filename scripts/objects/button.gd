extends Area2D

@onready var sprite = $Sprite2D # (Make sure this matches your node name!)

func _on_body_entered(body: Node2D) -> void:
	# Check if the player is the one stepping on it
	if body.name == "PlayerCharacter": # (Change this to your exact player node name!)
		
		# Change the picture to the pushed-down version
		sprite.play("press")
		
		print("The button was stepped on!")
		# (We will add the code to open a door or spawn an item right here!)
