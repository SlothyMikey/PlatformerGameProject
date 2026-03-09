extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -320.0
const jump_pad_height = -500.0
var is_invincible: bool = false

var health: int = 6
var coins: int = 0

func _ready() -> void:
	$UI/HealthBar.update_hearts(health)

func jump_launch(amount: float):
	velocity.y = amount

func add_coin() -> void:
	coins += 1
	$UI/CoinCounter/CoinText.text = str(coins)
	
func take_damage(damage_amount: int):
	# 1. Are we currently invincible? If yes, ignore the hit and stop the function!
	if is_invincible:
		return 
		
	# 2. Otherwise, take the damage as normal!
	health -= damage_amount
	print("Ouch! Player health is now: ", health)

	$UI/HealthBar.update_hearts(health)
	
	# 3. Turn on the forcefield and start the 1-second stopwatch!
	is_invincible = true
	$InvincibilityTimer.start()
	
	# --- THE HURT EFFECT ---
	$AnimatedSprite2D.modulate = Color.RED
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.3)
	# -----------------------

	if health <= 0:
		print("Player Died!")
		get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Direction Flipping
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	move_and_slide()


func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
