extends Area3D
signal point_earned


func _on_body_entered(body: Node3D) -> void:
	emit_signal("point_earned")
	print("DEATH COMES FOR US ALL")
	queue_free()

func begin(x: float, z: float):
	position.x = x
	position.z = z
	position.y = 1
