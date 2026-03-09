extends Node2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 60

var direction = -1

var is_stunned = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_stunned:
		if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = false
		
		if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = true
		
		position.x += direction * SPEED * delta

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if body.is_invincible == false:
			body.jump_launch(-300)
			body.take_damage(2)


func _on_stunzone_body_entered(body: Node2D) -> void:
	if body.has_method("jump_launch"):
		if body.is_invincible == false:
			if body.velocity.y > 0: 
				
				is_stunned = true
				animated_sprite_2d.play("stun")
				body.jump_launch(-300)
				
				$killzone/CollisionShape2D.set_deferred("disabled", true)
				$stunzone/CollisionShape2D.set_deferred("disabled", true)
