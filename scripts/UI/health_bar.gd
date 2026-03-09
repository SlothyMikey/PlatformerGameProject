extends HBoxContainer

# We use @export so you can drag and drop your heart sprites in the Inspector!
@export var heart_full: Texture2D
@export var heart_half: Texture2D
@export var heart_empty: Texture2D

func update_hearts(current_health: int) -> void:
	# Heart 1 (Represents 1 and 2 HP)
	if current_health >= 2:
		$Heart1.texture = heart_full
	elif current_health == 1:
		$Heart1.texture = heart_half
	else:
		$Heart1.texture = heart_empty
		
	# Heart 2 (Represents 3 and 4 HP)
	if current_health >= 4:
		$Heart2.texture = heart_full
	elif current_health == 3:
		$Heart2.texture = heart_half
	else:
		$Heart2.texture = heart_empty
		
	# Heart 3 (Represents 5 and 6 HP)
	if current_health >= 6:
		$Heart3.texture = heart_full
	elif current_health == 5:
		$Heart3.texture = heart_half
	else:
		$Heart3.texture = heart_empty
