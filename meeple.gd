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
	if (collected):

		position = position.move_toward(player.position, 0.1)
		var awesome = Vector3(delta*1,delta*1,delta*1)
		if (scale > Vector3(0,0,0)):
			scale = scale - awesome
		else:
			queue_free()
func begin(x: float, z: float):
	position.x = x
	position.z = z
	position.y = 1
