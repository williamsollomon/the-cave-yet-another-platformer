extends Node2D
@onready var exit: Area2D = $LevelRoot/Exit
@onready var victory_ui: CanvasLayer = $LevelRoot/VictoryUI2

var score: int = 0
var total_apples: int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level() # Replace with function body.
	#total_apples = get_tree().get_nodes_in_group("Apples").size()
	if exit:
		exit.player_won.connect(_on_player_won)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _setup_level() -> void:
	#connect apples
	var apples = $LevelRoot.get_node_or_null("Apples")
	if apples :
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
			
	#connect enemies
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies :
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
			
			
			
#-------------------
#SIGNAL HANDLER
#-------------------

func _on_player_died(body):
	body.die()
	print("Player killed")

#-----------------------
#SCORE
#-----------------------
func increase_score() -> void:
	score += 1
	print(score)
	
	if total_apples > 0 and score >= total_apples:
		exit.open_door()
		
func _on_player_won() -> void:
	if victory_ui:
		victory_ui.show_victory()
	
	
	
