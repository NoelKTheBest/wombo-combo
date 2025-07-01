extends Node2D

@onready var player = $RED
@onready var enemy = $WARRIOR


func _ready() -> void:
	enemy.find_player(player.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy.find_player(player.position)
