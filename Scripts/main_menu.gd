extends Control

# Ubah path ini sesuai letak scene Main/Level 1 kamu
@export_file("*.tscn") var start_level_scene: String = "res://scenes/main.tscn"

func _on_start_button_pressed() -> void:
	# Pindah ke scene game utama
	get_tree().change_scene_to_file(start_level_scene)

func _on_quit_button_pressed() -> void:
	# Keluar dari game
	get_tree().quit()
