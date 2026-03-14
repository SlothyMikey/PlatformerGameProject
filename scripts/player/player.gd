extends CharacterBody2D
@onready var jump_sound: AudioStreamPlayer2D = $Node/JumpSound
@onready var death_sound: AudioStreamPlayer2D = $Node/DeathSound
@onready var damage_sound: AudioStreamPlayer2D = $Node/DamageSound

const SPEED = 150.0
const JUMP_VELOCITY = -320.0
const jump_pad_height = -500.0
var is_invincible: bool = false
var is_dead: bool = false

var health: int = 6
var max_health: int = 6
var coins: int = 0

var has_diesel: bool = false

func _ready() -> void:
	$UI/HealthBar.update_hearts(health)

func jump_launch(amount: float):
	velocity.y = amount

func add_coin() -> void:
	coins += 1
	$UI/CoinCounter/CoinText.text = str(coins)
	
func take_damage(damage_amount: int):
	# 1. Ignore hits if already invincible or already dead!
	if is_invincible or is_dead: 
		return 
		
	health -= damage_amount
	if health < 0:
		health = 0
		 
	damage_sound.play()
	print("Ouch! Player health is now: ", health)
	$UI/HealthBar.update_hearts(health)
	
	# --- THE DELAYED DEATH SEQUENCE ---
	if health <= 0:
		is_dead = true # Lock controls
		
		if death_sound.playing == false:
			death_sound.play()
			
		# Turn off collision so they fall through the floor and obstacles
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Give them a classic "death hop"
		velocity.y = -300 
		
		# Stop blinking so they are visible while falling
		$BlinkTimer.stop()
		$AnimatedSprite2D.visible = true
		
		# THE DELAY: Wait 1.5 seconds while they fall off screen
		await get_tree().create_timer(1.5).timeout
		
		# Now show the menu and pause the game!
		$UI/GameOverScreen.show()
		get_tree().paused = true
		return 
	# ----------------------------------

	# IF STILL ALIVE, trigger standard damage effects!
	is_invincible = true
	$InvincibilityTimer.start()
	$BlinkTimer.start()
	
	$AnimatedSprite2D.modulate = Color.RED
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.3)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_dead:
		move_and_slide()
		return
		
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
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
	$BlinkTimer.stop() 
	$AnimatedSprite2D.visible = true


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func heal_to_full():
	health = max_health
	$UI/HealthBar.update_hearts(health)
	print("Healed to full!")


func _on_blink_timer_timeout() -> void:
	$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible

func reset_coins() -> void:
	coins = 0
	
	# Update the UI to show 0!
	if $UI/CoinCounter/CoinText != null:
		$UI/CoinCounter/CoinText.text = str(coins)
		
func add_bonus_coins(amount: int) -> void:
	# Add the specific amount to our total
	coins += amount
	
	# Update the UI!
	if $UI/CoinCounter/CoinText != null:
		$UI/CoinCounter/CoinText.text = str(coins)
	
func instant_death():
	# 1. Instantly set health to 0
	health = 0
	print("Fell off the map!")
	
	# 2. Update the UI to show all empty hearts
	if $UI/HealthBar != null:
		$UI/HealthBar.update_hearts(health)
	
	# 3. PLAY THE SOUND!
	if death_sound.playing == false:
		death_sound.play()
	
	# 3. Show the Game Over screen and pause the game
	if $UI/GameOverScreen != null:
		$UI/GameOverScreen.show()
		
	get_tree().paused = true
	
func buy_diesel(cost: int) -> bool:
	# 1. Check if we have enough money!
	if coins >= cost:
		
		# 2. Take the coins away and update the UI
		coins -= cost
		if $UI/CoinCounter/CoinText != null:
			$UI/CoinCounter/CoinText.text = str(coins)
			
		# 3. Put the diesel in our inventory
		has_diesel = true
		
		# --- NEW: SHOW THE UI ICON! ---
		if $UI/DieselIcon != null:
			$UI/DieselIcon.show()
		# ------------------------------
			
		print("Transaction complete! Diesel acquired.")
		return true 
		
	else:
		print("Not enough money!")
		return false
