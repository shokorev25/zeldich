extends Node2D

@export var tilemap_path: NodePath
@onready var hero := get_node_or_null("Player")

func _ready():
	
	if hero == null:
		push_error("Hero не найден в сцене")
		return
	
	hero.hp = PlayerData.previous_scene_player_hp

	var tilemap := get_node_or_null(tilemap_path)
	if tilemap == null:
		push_error("TileMap не найден")
		return

	hero.setup_camera_limits(tilemap)


func _on_portal_home_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		PlayerData.previous_scene_player_hp = hero.hp
		get_tree().change_scene_to_file("res://scenes/resourses/world.tscn")
