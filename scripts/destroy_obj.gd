extends StaticBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var area: Area2D = $Area2D

var hp := 1
var is_broken := false

func _ready():
	add_to_group("Destroyable")
	anim.animation = "idle"
	anim.play()

	# Инициализируем генератор случайных чисел для этого объекта отдельно
	randomize()  # либо RandomNumberGenerator для ещё более чистого подхода

func _physics_process(delta):
	var hero = get_tree().get_root().get_node("PathToPlayerNode")
	if hero == null:
		return
	
	if hero.is_currently_attacking() and not is_broken:
		var attack_pos = hero.attack_hitbox_position()
		if global_position.distance_to(attack_pos) <= 20:
			take_damage(1)

func take_damage(amount: int):
	hp -= amount
	if hp <= 0 and not is_broken:
		break_object()

func break_object():
	is_broken = true
	anim.animation = "broken"
	anim.play()
	if collider != null:
		collider.disabled = true
	if area != null:
		area.monitoring = false

	# Запускаем процесс разрушения и исчезновения
	_play_random_and_remove()

func _play_random_and_remove() -> void:
	# Ждём 1 секунду после broken
	await get_tree().create_timer(1.0).timeout
	# Выбираем случайную анимацию
	var r = randf()
	var next_anim = ""
	if r < 0.1:
		next_anim = "coin"
		PlayerData.player_coins += 1
	elif r < 0.6:
		next_anim = "heart"
		PlayerData.hp_diff = 5
	else:
		next_anim = "fire"
		PlayerData.hp_diff = -3

	anim.animation = next_anim
	anim.play()

	# Ждём пока анимация проиграется полностью
	var frames = anim.sprite_frames.get_frame_count(next_anim)
	var fps = anim.sprite_frames.get_animation_speed(next_anim)
	var duration = frames / fps
	await get_tree().create_timer(duration).timeout

	# После завершения анимации удаляем объект или делаем его невидимым
	queue_free()  # полностью удаляет объект из сцены
	# или вместо queue_free() можно использовать:
	# visible = false
	# collider.disabled = true
	# area.monitoring = false
