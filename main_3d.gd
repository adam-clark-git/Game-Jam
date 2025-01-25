extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func move_camera():
	var target_cam_pos = $Player.position
	target_cam_pos.x += ($Player.velocity.x/2.0)
	target_cam_pos.z += ($Player.velocity.z/2.0)
	if !abs(target_cam_pos.x - $CameraPivot.position.x) > 20 and !abs(target_cam_pos.z - $CameraPivot.position.z) > 20: 
		$CameraPivot.position = target_cam_pos
		
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
