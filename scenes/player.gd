extends CharacterBody2D

@export var speed = 80.0 # Скорость игрока
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking := false

func is_currently_attacking() -> bool:
	return is_attacking

func _ready():
	# Подписываемся на сигнал окончания анимации
	anim_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Если нажата атака и мы еще не атакуем
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim_sprite.play("attack_down")
		velocity = Vector2.ZERO  # останавливаем игрока на время атаки
	elif not is_attacking:
		# движение разрешено только если не атакуем
		if direction != Vector2.ZERO:
			velocity = direction * speed
			play_run(direction)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
			play_idle()
	
	move_and_slide()


func _on_animation_finished():
	if anim_sprite.animation.begins_with("attack"):
		is_attacking = false

func play_run(dir: Vector2):
	var anim := ""
	if abs(dir.y) > abs(dir.x):
		anim = "run_down" if dir.y > 0 else "run_up"
	else:
		anim = "run_right" if dir.x > 0 else "run_left"
	
	if anim_sprite.animation != anim:
		anim_sprite.play(anim)

func play_idle():
	if anim_sprite.animation != "default":
		anim_sprite.play("default")
