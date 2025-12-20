extends Node2D

@onready var pause_menu = get_node("UI/pause_menu")


@export var tilemap_path: NodePath

func _ready():
	var hero := get_node_or_null("Player")
	if hero == null:
		push_error("Hero не найден в сцене")
		return

	var tilemap := get_node_or_null(tilemap_path)
	if tilemap == null:
		push_error("TileMap не найден")
		return

	hero.setup_camera_limits(tilemap)

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("escape"):
		#get_tree().paused = true
		#pause_menu.visible = true
		#
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body)
	if "Player" in body.name:
		get_tree().change_scene_to_file("res://cave.tscn")
