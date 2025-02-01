extends Area3D
signal zap_player
var collected = false
var player: Node3D


	
func _on_body_entered(body: Node3D) -> void:
	if (not collected):
		collected = true;
		emit_signal("zap_player")
		print("first entered tesla")
		$Sizzle.volume_db = -5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func begin(x: float, z: float):
	position.x = x
	position.z = z
	position.y = 0.5
	print("Tesla spawned")


func _on_body_exited(body: Node3D) -> void:
	collected = false
	print("left tesla")
	$Sizzle.volume_db = -15
	
func spawn_animation():
	print("Animationplayed")
	$AnimationPlayer.play("spawn")
