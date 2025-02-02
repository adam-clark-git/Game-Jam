extends Control
signal start_game
signal toggle_music
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	start_game.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -200)
	print("fail")
	toggle_music.emit()
