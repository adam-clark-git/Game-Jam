extends Node

var former_velocity = Vector3.ZERO
var hurry_up = 0.01
var fast_cam_move = true
@export var missile: PackedScene
@export var explosion: PackedScene
@export var meeple: PackedScene
@export var tesla: PackedScene
var points = 0
var spawnLocations = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_missile()
	spawn_meeple()
	$UI/Retry.hide()


func move_camera(delta: float):
	var target_cam_pos = $Player.position
	target_cam_pos.x += ($Player.velocity.x/2.0)
	target_cam_pos.z += ($Player.velocity.z/2.0)
	# To prevent Jerkiness\
	var fixed_current_velocity = $Player.velocity
	fixed_current_velocity.y = 0 
	if not abs(fixed_current_velocity.length() - former_velocity.length()) > 1 && fast_cam_move: 
		fast_cam_move = true
		hurry_up = 0.01
		$CameraPivot.position = target_cam_pos
		former_velocity = $Player.velocity
		former_velocity.y = 0
	else:
		if (hurry_up ==0.01 ):
			_camera_shake(0.2, 0.2)
		$CameraPivot.position = $CameraPivot.position.move_toward(target_cam_pos, 0.01 + hurry_up)
		fast_cam_move = false
		if ($CameraPivot.position == target_cam_pos):
			fast_cam_move = true
			former_velocity = $Player.velocity
		hurry_up = hurry_up + (0.6 * delta)
		
	var min_zoom = 24
	
	var zoom_float = min_zoom + $Player.velocity.length() / 3
	
	$CameraPivot/Camera3D.size = move_toward_float($CameraPivot/Camera3D.size, zoom_float, 0.2)




func lock_on():
	get_tree().call_group("missiles", "find_player_position", $Player.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_camera(delta)
	lock_on()
	if ($Player.life == 0):
		player_dies()


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



# SPAWNING STUFF
func spawn_missile():
	var currentMissile = missile.instantiate()
	var mob_spawn_location = get_node("MissileSystem/MissileSpawnPath/MissileSpawner")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	currentMissile.initialize(mob_spawn_location.position)
	add_child(currentMissile)
	currentMissile.missile_death.connect(explode_missile)
	
func spawn_meeple():
	var newMeeple = meeple.instantiate()
	var spawnLocation = find_unoccupied_space()
	newMeeple.begin(spawnLocation.x,spawnLocation.y, $Player)
	add_child(newMeeple)
	newMeeple.point_earned.connect(add_point)
	
func spawn_tesla():
	var newTesla = tesla.instantiate()
	var spawnLocation = find_unoccupied_space()
	spawnLocations.append(spawnLocation)
	newTesla.begin(spawnLocation.x,spawnLocation.y)
	add_child(newTesla)
	newTesla.zap_player.connect(tesla_shock)
	newTesla.spawn_animation()
func tesla_shock():
	_on_player_take_damage()
func find_unoccupied_space():
	var succeed = false
	var spawnLocationX
	var spawnLocationZ
	var i = 0;
	while (not succeed || i > 300):
		succeed = true
		print("PANIC")
		spawnLocationX = randf_range(-40,40)
		spawnLocationZ = randf_range(-40,40)
		for location in spawnLocations:
			print("One location tested")
			var potential_spawn = Vector2(spawnLocationX, spawnLocationZ)
			print(potential_spawn.distance_to(location))
			if (potential_spawn.distance_to(location) < 10):
				succeed = false
		i +=1
	return Vector2(spawnLocationX, spawnLocationZ)
func add_point():
	points +=1
	$UI/Score.text = "Points: %s" % points
	if (points % 2 == 0):
		spawn_tesla()
	spawn_meeple()
	
	$MissileSystem/MissileSpawnTimer.wait_time = $MissileSystem/MissileSpawnTimer.wait_time / 1.05
func explode_missile(missile_position: Vector3):
	var explosion = explosion.instantiate()
	explosion.position = missile_position
	add_child(explosion)
func player_dies():
	$UI/Retry.show()
	$Player.dead = true
func _on_missile_spawn_timer_timeout() -> void:
	spawn_missile()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
func _on_death_plane_body_entered(body: Node3D) -> void:
	player_dies()


func _on_player_take_damage() -> void:
	$Player.life = $Player.life - 1
	_camera_shake(0.2,0.2)
	print($Player.life)


func _on_player_jump_shake() -> void:
	_camera_shake(0.2,0.2)
