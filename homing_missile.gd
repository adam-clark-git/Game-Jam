extends CharacterBody3D
@export var speed = 10
@export var vfx_explosion: PackedScene
var player_position
@export var acceleration = 0.1
signal missile_death(position: Vector3)
func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if (player_position != null):
		var direction = player_position - position
		direction = direction.normalized()
		if (direction.y > 0):
			direction.y = 0
		velocity = velocity.move_toward(multiply_vector3(direction, speed), acceleration)
		look_at(velocity + position)
	move_and_slide()

func multiply_vector3(vector: Vector3, mult: float):
	vector.x = vector.x * mult
	vector.y = vector.y * mult
	vector.z = vector.z * mult
	return vector

func initialize(spawnPosition: Vector3):
	position = spawnPosition

func find_player_position(player_position_local: Vector3):
	player_position = player_position_local
	

func explode():
	emit_signal("missile_death",position)
	queue_free()
func _on_timer_timeout() -> void:
	explode()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	if ($Timer.is_stopped()):
		$Timer.start()
