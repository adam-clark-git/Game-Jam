extends CharacterBody3D

@export var speed = 40
@export var rotation_speed = 2.0
@export var acceleration = 0.2;
@export var friction = 0.08;

var rotation_direction = 0
func get_input():
	rotation_direction = -Input.get_axis("turn_left", "turn_right")
	var target_velocity = transform.basis.x * -Input.get_axis("move_back", "move_forward") * speed 
	
	
	if (target_velocity != Vector3.ZERO):
		velocity = velocity.move_toward(target_velocity, acceleration)
	
	velocity = velocity.move_toward(Vector3.ZERO, friction)
	animate_tire_tracks(target_velocity)

func _physics_process(delta: float) -> void:
	get_input()
	rotation.y += rotation_direction * rotation_speed * delta
	if (not is_on_floor()):
		velocity.y = velocity.y - (9.8 * delta)
	move_and_slide()

func animate_tire_tracks(target_speed: Vector3):
	if (velocity.distance_to(target_speed) > 30):
		$TireTracks.emitting = true
	else:
		$TireTracks.emitting = false
