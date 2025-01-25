
extends CharacterBody2D

@export var speed = 500
@export var rotation_speed = 2.0
@export var acceleration = 5;
@export var friction = 2;

var rotation_direction = 0

func get_input():
	var boost = 1
	var accel_boost = 1
	if (Input.is_action_pressed("boost")):
		boost = 1.5
		accel_boost = 3
	rotation_direction = Input.get_axis("turn_left", "turn_right")
	# Transform.x basically means whatever direction is forward for the object.
	var target_velocity = transform.x * Input.get_axis("move_back", "move_forward") * speed * boost
		
	
	if (target_velocity != Vector2.ZERO):
		velocity = velocity.move_toward(target_velocity, acceleration * accel_boost)
	
	#We have to give a slight amount of friction constantly, otherwise ice physics.
	velocity = velocity.move_toward(Vector2.ZERO, friction)
		
	
func _physics_process(delta):
	get_input()
	# Changes our rotation value to equal the direction chosen, times speed, times time passed
	# We need delta to be consistent with unique frame rates.
	rotation += rotation_direction * rotation_speed * delta
	#move_camera()
	# Calculates new position based on velocity vector.
	move_and_slide()
	# So we get the fancy animation. Kinda pointless ngl.
	$AnimatedSprite2D.rotation = -rotation
	animate()

# Goals: Camera should be ahead of the player, following the velocity they're going
# Problem: Camera is too jerky when rotating.
# Solution: Make the Camera follow the player's velocity direction.
func animate():
	var fixed_degrees = rotation_degrees;
	if (fixed_degrees < 0):
		fixed_degrees = 360 + fixed_degrees
	if (fixed_degrees < 18):
		$AnimatedSprite2D.frame = 0
	elif (fixed_degrees < 54):
		$AnimatedSprite2D.frame = 9
	elif (fixed_degrees < 90):
		$AnimatedSprite2D.frame = 8
	elif (fixed_degrees < 126):
		$AnimatedSprite2D.frame = 7
	elif (fixed_degrees < 162):
		$AnimatedSprite2D.frame = 6
	elif (fixed_degrees < 198):
		$AnimatedSprite2D.frame = 5
	elif (fixed_degrees < 234):
		$AnimatedSprite2D.frame = 4
	elif (fixed_degrees < 270):
		$AnimatedSprite2D.frame = 3
	elif (fixed_degrees < 306):
		$AnimatedSprite2D.frame = 2
	elif (fixed_degrees < 342):
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0



# GOALS
# Implement particle effects. Try adding tire marks to where it's driven, plus dirt being flung up.
# Animate wheels spinning. idk if this is possible without getting a new model
# Switch to 3D
# Add a goal to the game. Enemies would be a good start, as well as collision.
