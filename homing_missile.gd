extends CharacterBody3D
@export var speed = 5
var player_position
func _ready() -> void:
	pass
	


func _physics_process(delta: float) -> void:
	if (player_position != null):
		var direction = player_position - position
		direction = direction.normalized()
		
		velocity = multiply_vector3(direction, speed)
	move_and_slide()

func multiply_vector3(vector: Vector3, mult: float):
	vector.x = vector.x * mult
	vector.y = vector.y * mult
	vector.z = vector.z * mult
	return vector

"""
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
"""

func find_player_position(player_position_local: Vector3):
	print("darn")
	player_position = player_position_local
	
