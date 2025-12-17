extends CharacterBody2D

@export var speed = 80.0 # Скорость игрока
@onready var sprite = $Sprite2D # Ссылка на спрайт

func _physics_process(delta):
	# Получаем направление нажатий стрелочек или WASD
	# ui_right, ui_left и т.д. - это встроенные кнопки (стрелки)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * speed
	else:
		# Если ничего не жмем, скорость плавно гаснет до 0
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
	update_animation(direction)

func update_animation(dir):
	# Если мы стоим на месте (вектор движения равен 0,0), ничего не меняем
	if dir == Vector2.ZERO:
		return
	
	# Простейшая анимация поворота (пока без шагов)
	# Меняем кадры (frame_coords) в зависимости от направления
	# Hframes у нас 4. Vframes 10.
	# Предположим: 0 ряд - вниз, 1 - вверх, 2 - вбок. (Надо сверить с вашей картинкой)
	
	# ВНИМАНИЕ: Тут нужно подбирать числа Y под вашу картинку character.png!
	# Я пишу примерные координаты (x - колонка, y - ряд)
	
	if dir.y > 0: # Идем ВНИЗ
		sprite.frame_coords.y = 0 # 0-й ряд сверху
	elif dir.y < 0: # Идем ВВЕРХ
		sprite.frame_coords.y = 1 # 1-й ряд
	
	if dir.x != 0: # Идем ВБОК
		sprite.frame_coords.y = 2 # 2-й ряд
		sprite.flip_h = (dir.x < 0) # Если идем влево, зеркалим спрайт
