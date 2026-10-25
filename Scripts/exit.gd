extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var info_label: Label = $Label



# Sinyal untuk memberi tahu Main bahwa player menang
signal player_won

var is_open: bool = false

func _ready() -> void:
	animated_sprite.play("locked")
	is_open = false
	info_label.hide()

func open_door() -> void:
	if is_open:
		return
	is_open = true
	animated_sprite.play("unlocked")
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	print("Pintu terbuka!")
	
	info_label.show()

func _on_body_entered(body: Node2D) -> void:
	# Jika pintu sudah terbuka DAN yang masuk adalah Player
	if is_open:
		print("Player berhasil masuk!")
		win_game()

func win_game() -> void:
	print("You Win!")
	player_won.emit() # Pancarkan sinyal menang ke Main
