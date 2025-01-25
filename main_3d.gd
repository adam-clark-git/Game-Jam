extends Node

var former_velocity = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func move_camera():
	var target_cam_pos = $Player.position
	target_cam_pos.x += ($Player.velocity.x/2.0)
	target_cam_pos.z += ($Player.velocity.z/2.0)
	if not abs($Player.velocity.length() - former_velocity.length()) > 1: 
		$CameraPivot.position = target_cam_pos
		former_velocity = $Player.velocity
	else:
		$CameraPivot.position = $CameraPivot.position.move_toward(target_cam_pos, 0.2)
		if ($CameraPivot.position == target_cam_pos):
			former_velocity = $Player.velocity
		
	var min_zoom = 20
	
	var zoom_float = min_zoom + $Player.velocity.length() / 4
	
	$CameraPivot/Camera3D.size = move_toward_float($CameraPivot/Camera3D.size, zoom_float, 0.2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_camera()

func move_toward_float(current: float, goal: float, accel: float):
	if current == goal:
		return current
	var direction = goal - current
	var step = min(abs(direction), accel) * sign(direction)
	return current + step
