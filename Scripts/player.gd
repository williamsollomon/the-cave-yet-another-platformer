class_name player
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var health_bar: ProgressBar = $HealthBar # Pastikan tambahkan node ProgressBar sebagai child Player di scene

@export var game_over_ui: CanvasLayer 

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true

var max_health: int = 3
var current_health: int = 3

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	current_health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

func _physics_process(delta: float) -> void:
	if !alive:
		velocity += get_gravity() * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"
	elif velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

func take_damage(amount: int) -> void:
	if !alive: return
	current_health -= amount
	if health_bar:
		health_bar.value = current_health
	death_sound.play()
	if current_health <= 0:
		die()

func die() -> void:
	if !alive:
		return
		
	alive = false
	death_sound.play()
	animated_sprite_2d.play("death")
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	get_tree().create_timer(1.5).timeout.connect(_trigger_game_over)

func _trigger_game_over() -> void:
	if game_over_ui:
		game_over_ui.show_game_over()

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
		queue_free()
