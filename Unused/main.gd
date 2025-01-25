
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CameraPivot.position.x = $Player.position.x
	$CameraPivot.position.y = $Player.position.y
func move_camera():
	$CameraPivot.position.x = $Player.position.x + ($Player.velocity.x/2.0)
	$CameraPivot.position.y = $Player.position.y + ($Player.velocity.y/2.0)
	var target_zoom
	var max_zoom = 1.5
	
	var zoom_float = max_zoom - $Player.velocity.length() / 800
	target_zoom = Vector2(zoom_float,zoom_float)
	
	$CameraPivot/Camera2D.zoom = $CameraPivot/Camera2D.zoom.move_toward(target_zoom,0.01)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_camera()
