extends CharacterBody2D

@export var speed := 80.0
@export var max_hp := 10

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var hp := max_hp
var is_attacking := false
var hurt_timer := 0.0
var is_dead := false   # ← ВАЖНО

func is_currently_attacking() -> bool:
	return is_attacking

func _ready():
	anim_sprite.animation_finished.connect(_on_animation_finished)
	if "Node2D" in get_tree().current_scene:
		get_node("Camera2D").limit_right = 300

func _physics_process(delta):
	
		
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# восстановление цвета после удара
	if hurt_timer > 0:
		hurt_timer -= delta
		if hurt_timer <= 0:
			anim_sprite.modulate = Color.WHITE

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim_sprite.play("attack_down")
	elif not is_attacking:
		if direction != Vector2.ZERO:
			velocity = direction * speed
			play_run(direction)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
			play_idle()

	move_and_slide()

func take_damage(damage: int):
	if is_dead:
		return

	hp = clamp(hp - damage, 0, max_hp)
	print("Герой получил урон:", damage, " HP:", hp)

	anim_sprite.modulate = Color(1, 0.4, 0.4)
	hurt_timer = 0.2

	if hp == 0:
		die()

func die():
	is_dead = true
	is_attacking = false
	velocity = Vector2.ZERO

	anim_sprite.play("default")
	print("Герой умер")

	# Останавливаем весь мир
	get_tree().paused = true


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
