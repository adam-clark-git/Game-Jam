extends CharacterBody3D

signal take_damage
signal jump_shake
@export var speed = 40
@export var rotation_speed = 2.0
@export var acceleration = 0.2
@export var friction = 0.08
@export var life = 3
var dead = false
var powerup = 0
var overrideTireTracks
var rotation_direction = 0
var jumps = 3
func get_input():
	overrideTireTracks = false
	var target_velocity = Vector3.ZERO
	if (Input.is_action_pressed("move_forward")):
		target_velocity = transform.basis.x * -speed
	if (Input.is_action_pressed("move_back")):
		target_velocity = transform.basis.x * 0.01
		$TireTracks.emitting = true
		overrideTireTracks = true
	
	
	if (target_velocity != Vector3.ZERO):
		velocity = velocity.move_toward(target_velocity, acceleration)
	
	if (Input.is_action_just_pressed("boost")):
		if jumps > 0:
			velocity.y = 8;
			jumps = jumps -1
		emit_signal("jump_shake")
		$Noises/Impact.play()
	velocity = velocity.move_toward(Vector3.ZERO, friction)
	animate_tire_tracks(target_velocity)

func _physics_process(delta: float) -> void:
	if not dead:
		rotation_direction = -Input.get_axis("turn_left", "turn_right")
	if (rotation_direction > 0):
		$"Pivot/Square Car 1/AnimationPlayer".play("turn_left")
	elif (rotation_direction < 0):
		$"Pivot/Square Car 1/AnimationPlayer".play("turn_right")
	else:
		$"Pivot/Square Car 1/AnimationPlayer".play("Spin Wheels")
	if (is_on_floor() and not dead):
		get_input()
	else:
		animate_tire_tracks(velocity)

		velocity.y = velocity.y - (12 * delta)
	rotation.y += rotation_direction * rotation_speed * delta
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)

		# If the collision is with ground
		if collision.get_collider() == null:
			continue

		# If the collider is with a mob
		if collision.get_collider().is_in_group("missiles"):
			var missile = collision.get_collider()
			missile.explode()
			emit_signal("take_damage")
			break
	move_and_slide()
	audio()


func audio():
	$Noises/Running.pitch_scale = 1.5 + velocity.length() /15
func animate_tire_tracks(target_speed: Vector3):
	if (velocity.distance_to(target_speed) > 30 or overrideTireTracks):
		$TireTracks.emitting = true
		if $Noises/Skid.playing == false:
			$Noises/Skid.play()
	else:
		$Noises/Skid.stop()
		$TireTracks.emitting = false
