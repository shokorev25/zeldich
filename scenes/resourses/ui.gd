extends CanvasLayer

@export var hero_path: NodePath
@onready var hp_label: Label = $HPLabel
@onready var coins_label: Label = $CoinsLabel

var hero

func _ready():
	hero = get_node(hero_path)

func _process(_delta):
	if hero:
		hp_label.text = "%d" % [hero.hp]
		coins_label.text = "%d" % [PlayerData.player_coins]
