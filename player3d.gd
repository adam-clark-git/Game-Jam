extends CharacterBody3D

signal take_damage
@export var speed = 40
@export var rotation_speed = 2.0
@export var acceleration = 0.2
@export var friction = 0.08
@export var life = 3
var powerup = 0


signal update_position(currentPosition : Vector3)
var rotation_direction = 0
func get_input():
	rotation_direction = -Input.get_axis("turn_left", "turn_right")
	var target_velocity = Vector3.ZERO
	if (Input.is_action_pressed("move_forward")):
		target_velocity = transform.basis.x * -speed
	if (Input.is_action_pressed("move_back")):
		target_velocity = transform.basis.x * 0.01
		$TireTracks.emitting = true
	
	if (rotation_direction > 0):
		$"Pivot/Square Car 1/AnimationPlayer".play("turn_left")
	elif (rotation_direction < 0):
		$"Pivot/Square Car 1/AnimationPlayer".play("turn_right")
	else:
		$"Pivot/Square Car 1/AnimationPlayer".play("Spin Wheels")
	if (target_velocity != Vector3.ZERO):
		velocity = velocity.move_toward(target_velocity, acceleration)
	if (Input.is_action_just_pressed("boost")):
		if powerup == 0:
			velocity.y = 12;
		if powerup == 1:
			acceleration = acceleration * 2

	velocity = velocity.move_toward(Vector3.ZERO, friction)
	animate_tire_tracks(target_velocity)

func _physics_process(delta: float) -> void:
	if (is_on_floor()):
		get_input()
	else:
		animate_tire_tracks(velocity)
		velocity.y = velocity.y - (16 * delta)
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
	
	emit_signal("update_position", position)

func animate_tire_tracks(target_speed: Vector3):
	if (velocity.distance_to(target_speed) > 30):
		$TireTracks.emitting = true
	else:
		$TireTracks.emitting = false
