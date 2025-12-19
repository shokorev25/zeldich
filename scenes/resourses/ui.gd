extends CanvasLayer

@export var hero_path: NodePath
@onready var hp_label: Label = $HPLabel

var hero

func _ready():
	hero = get_node(hero_path)

func _process(_delta):
	if hero:
		hp_label.text = "HP %d / %d" % [hero.hp, hero.max_hp]
