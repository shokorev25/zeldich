extends CharacterBody2D

@export var speed = 30.0
@export var change_dir_time = 2.0
@export var attack_range = 50.0
@export var hero_node_path: NodePath  # перетащи героя
@export var tilemap_node_path: NodePath  # перетащи TileMap

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction = Vector2.ZERO
var time_since_change = 0.0
var tilemap: TileMap
var hero: CharacterBody2D

func _ready():
	randomize()

	# Получаем TileMap из инспектора
	if tilemap_node_path != null:
		tilemap = get_node(tilemap_node_path)
	else:
		push_warning("TileMap не указан!")

	# Получаем героя из инспектора
	if hero_node_path != null:
		hero = get_node(hero_node_path)


func _physics_process(delta):
	time_since_change += delta

	# Если герой рядом и атакует, злодей исчезает
	if hero != null and hero.is_currently_attacking() and global_position.distance_to(hero.global_position) <= attack_range:
		queue_free()
		return

	# Случайное движение
	if time_since_change >= change_dir_time or direction == Vector2.ZERO:
		direction = get_random_direction()
		time_since_change = 0.0

	velocity = direction * speed
	move_and_slide()

	if is_on_wall():
		direction = get_random_direction()

	if tilemap != null:
		keep_inside_tilemap()

	play_walk_animation(direction)


func get_random_direction() -> Vector2:
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
	return dirs[randi() % dirs.size()]


func play_walk_animation(dir: Vector2):
	if dir == Vector2.ZERO:
		if anim_sprite.animation != "default":
			anim_sprite.play("default")
	elif abs(dir.y) > abs(dir.x):
		anim_sprite.play("down" if dir.y > 0 else "up")
	else:
		anim_sprite.play("right" if dir.x > 0 else "left")


func keep_inside_tilemap():
	var map_rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_size

	var map_min = tilemap.map_to_world(map_rect.position)
	var map_max = tilemap.map_to_world(map_rect.position + map_rect.size)

	position.x = clamp(position.x, map_min.x, map_max.x)
	position.y = clamp(position.y, map_min.y, map_max.y)
