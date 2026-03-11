extends Node2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 80
var direction = -1
var is_stunned = false

# --- NEW VARIABLES ---
# @export lets you change this number in the Inspector for each enemy!
@export var patrol_distance: float = 100.0 
var start_x: float 

func _ready() -> void:
	# Remember where the enemy was placed in the level
	start_x = global_position.x

func _process(delta: float) -> void:
	if not is_stunned:
		
		# 1. Check for physical walls (Your existing RayCast code)
		if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = false
		elif ray_cast_left.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = true
			
		# 2. THE LEASH: Check if we flew too far from the start position
		if global_position.x > start_x + patrol_distance:
			direction = -1 # Turn left
			animated_sprite_2d.flip_h = false
		elif global_position.x < start_x - patrol_distance:
			direction = 1 # Turn right
			animated_sprite_2d.flip_h = true

		position.x += direction * SPEED * delta

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if body.is_invincible == false:
			body.jump_launch(-300)
			body.take_damage(2)
