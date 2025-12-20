extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_first_lvl_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_second_lvl_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/second_scene.tscn")


func _on_third_lvl_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/third_scene.tscn")

func _on_four_lvl_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/four_scene.tscn")
	
func _on_five_lvl_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/four_scene.tscn")


func _on_back_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
