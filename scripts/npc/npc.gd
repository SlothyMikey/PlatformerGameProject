extends Area2D

@onready var dialogue_ui = $DialogueUI
var player_node: Node2D = null

# --- 1. DETECT THE PLAYER ---
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		player_node = body # Remember the player!
		dialogue_ui.show()
		get_tree().paused = true # Freeze the game while talking

# --- 2. BUTTON A (Half Heart Damage) ---
func _on_button_a_pressed() -> void:
	if player_node != null:
		# Deal 1 damage (half a heart)
		player_node.take_damage(1)
			
		if player_node.has_method("reset_coins"):
			player_node.reset_coins()
	close_dialogue()

# --- 3. BUTTON B (Heal to Full) ---
func _on_button_b_pressed() -> void:
	if player_node != null and player_node.has_method("heal_to_full"):
		player_node.heal_to_full()
	
	if player_node.has_method("add_bonus_coins"):
			player_node.add_bonus_coins(20)
	close_dialogue()

# --- 4. CLEANUP ---
func close_dialogue():
	dialogue_ui.hide()
	get_tree().paused = false
	
	# Turn off the NPC's collision so they don't ask the question again!
	$CollisionShape2D.set_deferred("disabled", true)
