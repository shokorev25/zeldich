extends CharacterBody2D

enum State { IDLE, AGRO }

@export var speed := 40.0
@export var detect_radius := 150.0
@export var attack_range := 20.0
@export var hero_node_path: NodePath

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var hero: CharacterBody2D
var state := State.IDLE
var idle_dir := Vector2.ZERO
var idle_timer := 0.0

@export var damage := 1
@export var attack_cooldown := 1.0

var attack_timer := 0.0
@export var attack_delay := 1  # время в секундах перед атакой
var attack_wait_timer := 0.0
var is_waiting_attack := false

func _ready():
	randomize()
	hero = get_node(hero_node_path)
	
	# Настройка NavigationAgent
	nav_agent.path_desired_distance = 5.0  # чуть больше, чтобы не прилипал
	nav_agent.target_desired_distance = 5.0


func _physics_process(delta):
	if hero == null or not is_instance_valid(hero):
		return  # если герой ещё не существует, просто ждём

	attack_timer -= delta

	var dist_to_hero = global_position.distance_to(hero.global_position)

	if dist_to_hero <= detect_radius:
		state = State.AGRO
	elif dist_to_hero > detect_radius * 1.3:
		state = State.IDLE

	match state:
		State.IDLE:
			process_idle(delta)
		State.AGRO:
			process_agro(delta)

	move_and_slide()
	play_animation()


func process_idle(delta):
	idle_timer -= delta

	if idle_timer <= 0:
		idle_timer = randf_range(1.5, 3.0)
		idle_dir = get_random_direction()

	velocity = idle_dir * speed * 0.5

func process_agro(delta):
	if hero == null:
		return

	# обновляем цель каждый кадр
	nav_agent.target_position = hero.global_position
	if nav_agent.get_target_position() != hero.global_position:
		nav_agent.force_update_path()

	var dist = global_position.distance_to(hero.global_position)

	# смерть от атаки героя
	if hero.is_currently_attacking() and dist <= attack_range:
		queue_free()
		return

	# если герой в зоне атаки
	if dist <= attack_range:
		velocity = Vector2.ZERO

		if not is_waiting_attack:
			# начинаем ждать перед атакой
			is_waiting_attack = true
			attack_wait_timer = attack_delay
		else:
			attack_wait_timer -= delta
			if attack_wait_timer <= 0 and attack_timer <= 0:
				attack_timer = attack_cooldown
				anim_sprite.play("attack")
				hero.take_damage(damage)
				is_waiting_attack = false  # сбрасываем ожидание после удара

		return

	# движение по пути NavigationAgent
	is_waiting_attack = false  # если отходим, сбрасываем ожидание
	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var dir = (next_pos - global_position).normalized()
		velocity = dir * speed
	else:
		var dir = (hero.global_position - global_position).normalized()
		velocity = dir * speed

func play_animation():
	if velocity.length() < 1:
		anim_sprite.play("default")
		return

	if abs(velocity.x) > abs(velocity.y):
		anim_sprite.play("right" if velocity.x > 0 else "left")
	else:
		anim_sprite.play("down" if velocity.y > 0 else "up")

func get_random_direction() -> Vector2:
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
	return dirs.pick_random()

func play_walk_animation(dir: Vector2):
	if dir == Vector2.ZERO:
		if anim_sprite.animation != "default":
			anim_sprite.play("default")
	elif abs(dir.y) > abs(dir.x):
		anim_sprite.play("down" if dir.y > 0 else "up")
	else:
		anim_sprite.play("right" if dir.x > 0 else "left")
