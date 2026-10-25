class_name Skeleton
extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var patrol_timer: Timer = $Timer 

signal player_died
const SPEED = 30.0
var direction = 1.0
var has_attacked: bool = false
var cooldown_time: float = 1.0

func _ready() -> void:
	animated_sprite_2d.play("running") 

func _process(delta: float) -> void:
	if not has_attacked:
		position.x += direction * SPEED * delta
		
		if direction == 1.0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
			
		if animated_sprite_2d.animation != "running" or not animated_sprite_2d.is_playing():
			animated_sprite_2d.play("running")

func _on_timer_timeout() -> void:
	if has_attacked:
		return
		
	direction *= -1
	
	for child in get_children():
		if child is CollisionShape2D:
			child.position.x *= -1

func _on_body_entered(body: Node2D) -> void:
	if body is player and body.alive and not has_attacked:
		has_attacked = true 
		patrol_timer.paused = true 
		
		if body.global_position.x < global_position.x:
			animated_sprite_2d.flip_h = true 
		else:
			animated_sprite_2d.flip_h = false 
			
		animated_sprite_2d.play("attack")
		body.take_damage(1)
		
		get_tree().create_timer(cooldown_time).timeout.connect(_reset_attack)

func _reset_attack() -> void:
	has_attacked = false
	animated_sprite_2d.play("running")
	patrol_timer.paused = false
