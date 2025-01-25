extends CharacterBody3D

@export var speed = 20
@export var rotation_speed = 1.0
@export var acceleration = 0.1;
@export var friction = 0.01;

var rotation_direction = 0
func get_input():
	rotation_direction = Input.get_axis("turn_left", "turn_right")
	var target_velocity = transform.basis.x * Input.get_axis("move_back", "move_forward") * speed 
	
	
	if (target_velocity != Vector3.ZERO):
		velocity = velocity.move_toward(target_velocity, acceleration)
		

func _physics_process(delta: float) -> void:
	get_input()
	rotation.y += rotation_direction * rotation_speed * delta
	move_and_slide()
