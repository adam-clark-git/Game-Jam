extends Area3D
signal point_earned
var collected = false
var player: Node3D
func _on_body_entered(body: Node3D) -> void:
	if (not collected):
		emit_signal("point_earned")
		collected = true
		$CollisionIndicator.visible = false
		$AnimationPlayer.speed_scale = 5.0
		player = body
	
func _physics_process(delta: float) -> void:
	var canvas = $Control.get_canvas_transform()
	print(canvas)
	set_marker_position()
	set_marker_rotation()
	set_marker_size()
	var angle_to_meeple = player.position.angle_to(position)
	print(angle_to_meeple * (180 / PI))
	
	if (collected):

		position = position.move_toward(player.position, 0.1)
		var awesome = Vector3(delta*1,delta*1,delta*1)
		if (scale > Vector3(0,0,0)):
			scale = scale - awesome
		else:
			queue_free()
func begin(x: float, z: float, newPlayer: Node3D):
	position.x = x
	position.z = z
	position.y = 1
	player = newPlayer
	$AnimationPlayer.play("spawn")
	$AnimationPlayer.queue("move")

func set_marker_size():
	var icon_size = 0.1 + abs(position - player.position).length() / 500 
	$Control/Sprite2D.scale = Vector2(icon_size, icon_size)
func set_marker_position():
	pass
func set_marker_rotation():
	pass
func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	$Control.hide()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	$Control.show()
