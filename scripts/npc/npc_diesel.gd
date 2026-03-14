extends Area2D

@onready var dialogue_ui = $DialogueUI
@onready var dialogue_text = $DialogueUI/Panel/Label # Let's us change the text!
var player_node: Node2D = null

# --- DETECT THE PLAYER ---
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		player_node = body 
		dialogue_text.text = "I'll trade you Diesel for 54 coins!" # Reset the greeting
		dialogue_ui.show()
		get_tree().paused = true 

# --- BUTTON A: BUY THE DIESEL ---
# --- BUTTON A: BUY THE DIESEL ---
func _on_button_a_pressed() -> void:
	if player_node != null and player_node.has_method("buy_diesel"):
		
		# Try to buy it for 5 coins
		var transaction_successful = player_node.buy_diesel(54)
		
		if transaction_successful == true:
			# SUCCESS! Turn off the NPC's collision so they don't ask again
			$CollisionShape2D.set_deferred("disabled", true)
			close_dialogue()
		else:
			# BROKE! Change the text, but keep the shop open
			dialogue_text.text = "You Poor Ass Donkey!"

# --- BUTTON B: NO THANKS ---
func _on_button_b_pressed() -> void:
	# Just close the menu. The collision stays ON so we can talk again later!
	close_dialogue()

# --- CLEANUP ---
func close_dialogue():
	dialogue_ui.hide()
	get_tree().paused = false
	# (We completely removed the collision disable line from down here!)
