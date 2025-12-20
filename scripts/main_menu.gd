extends Control

@onready var settings: Panel = $Settings
var settings_opened: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc_button_pressed"):
		if settings_opened:
			settings.visible = false
			settings_opened = false
		else:
			get_tree().quit()

func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/resourses/world.tscn")


func _on_settings_button_button_down() -> void:
	settings_opened = true
	settings.visible = true


func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _on_exit_settings_button_button_down() -> void:
	settings.visible = false
	settings_opened = false


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
