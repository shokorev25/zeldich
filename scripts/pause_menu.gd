extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc_button_pressed"):
		if get_tree().paused:
			resume()
		else:
			pause()

func resume():
	get_tree().paused = false
	visible = false
	
func pause():
	get_tree().paused = true
	visible = true


func _on_continue_button_button_down() -> void:
	resume()


func _on_restart_button_button_down() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_exit_button_button_down() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
