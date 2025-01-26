extends CharacterBody3D

@export var speed = 40
@export var rotation_speed = 2.0
@export var acceleration = 0.2
@export var friction = 0.08
@export var life = 3

signal update_position(currentPosition : Vector3)
var rotation_direction = 0
func get_input():
	rotation_direction = -Input.get_axis("turn_left", "turn_right")
	var target_velocity = transform.basis.x * -Input.get_axis("move_back", "move_forward") * speed 
	
	if (rotation_direction > 0):
		$"Pivot/Square Car 1/AnimationPlayer".play("turn_left")
	elif (rotation_direction < 0):
		$"Pivot/Square Car 1/AnimationPlayer".play("turn_right")
	else:
		$"Pivot/Square Car 1/AnimationPlayer".play("Spin Wheels")
	if (target_velocity != Vector3.ZERO):
		velocity = velocity.move_toward(target_velocity, acceleration)
	
	velocity = velocity.move_toward(Vector3.ZERO, friction)
	animate_tire_tracks(target_velocity)

func _physics_process(delta: float) -> void:
	if (is_on_floor()):
		get_input()
	else:
		animate_tire_tracks(velocity)
		velocity.y = velocity.y - (9.8 * delta)
	rotation.y += rotation_direction * rotation_speed * delta

	move_and_slide()
	emit_signal("update_position", position)

func animate_tire_tracks(target_speed: Vector3):
	if (velocity.distance_to(target_speed) > 30):
		$TireTracks.emitting = true
	else:
		$TireTracks.emitting = false
