extends CanvasLayer

func _ready() -> void:
	# Sembunyikan UI saat game baru dimulai
	hide()

func show_victory() -> void:
	show()
	get_tree().paused = true



func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
