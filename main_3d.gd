extends Node

var former_velocity = Vector3.ZERO
var hurry_up = 0.01
var fast_cam_move = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func move_camera(delta: float):
	var target_cam_pos = $Player.position
	target_cam_pos.x += ($Player.velocity.x/2.0)
	target_cam_pos.z += ($Player.velocity.z/2.0)
	# To prevent Jerkiness
	if not abs($Player.velocity.length() - former_velocity.length()) > 1 && fast_cam_move: 
		fast_cam_move = true
		hurry_up = 0.01
		$CameraPivot.position = target_cam_pos
		former_velocity = $Player.velocity
	else:
		if (hurry_up ==0.01 ):
			_camera_shake(0.2, 0.2)
		$CameraPivot.position = $CameraPivot.position.move_toward(target_cam_pos, 0.01 + hurry_up)
		fast_cam_move = false
		if ($CameraPivot.position == target_cam_pos):
			fast_cam_move = true
			former_velocity = $Player.velocity
		hurry_up = hurry_up + (0.6 * delta)
		
	var min_zoom = 18
	
	var zoom_float = min_zoom + $Player.velocity.length() / 3
	
	$CameraPivot/Camera3D.size = move_toward_float($CameraPivot/Camera3D.size, zoom_float, 0.2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_camera(delta)


func _camera_shake(magnitude: float, period: float):
	var initial_transform = $CameraPivot/Camera3D.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		$CameraPivot/Camera3D.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	$CameraPivot/Camera3D.transform = initial_transform

func move_toward_float(current: float, goal: float, accel: float):
	if current == goal:
		return current
	var direction = goal - current
	var step = min(abs(direction), accel) * sign(direction)
	return current + step
