extends Node2D

@onready var pause_menu = get_node("UI/pause_menu")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("escape"):
		#get_tree().paused = true
		#pause_menu.visible = true
		#
	pass
