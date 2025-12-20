extends Control

var change_level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_active() -> void:
	visible = true


func _on_exit_button_button_down() -> void:
	get_tree().paused = false # На случай если пользователь жмал esc и поставил паузу
	get_tree().change_scene_to_file("res://scenes/UI/levels_menu.tscn")


func _on_next_lvl_button_button_down() -> void:
	get_tree().paused = false # На случай если пользователь жмал esc и поставил паузу
	# Название следующего уровня
	if change_level==0:	
		get_tree().change_scene_to_file("res://scenes/second_scene.tscn")
	if change_level == 1:
		get_tree().change_scene_to_file("res://scenes/third_scene.tscn")
	if change_level == 2:
		get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
		


func _on_ready() -> void:
	change_level = 2

func second_level() ->void:
	change_level = 1
