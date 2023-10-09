extends Node

# 0 - start 1
# 1 - start stab
# 2 - start stab down
# 3 - start stab up
# 4 - start sword
# 5 - start sword 1
# 6 - start sword 2
# 7 - start sword down
# 8 - start sword up
var starter_positions = [Vector2(12, 0), Vector2(10, 0), Vector2(0, 10), Vector2(0, -8),
 Vector2(10, 0), Vector2(10, 0), Vector2(10, 0), Vector2(0, 0), Vector2(1, 0)]

# 0 - start 1
# -
# -
# -
# 1 - start sword
# -
# 2 - start sword 2
# 3 - start sword down
# 4 - start sword up
var starter_knockback = [Vector2(0, -10), Vector2(10, 0), Vector2(10, 0), Vector2(0, 10), Vector2(0, -10)]

var starters = []

var file = 'res://starters.txt'

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = FileAccess.open(file, FileAccess.READ)
	var content = f.get_as_text()
	
	for i in int(content):
		print(i)
		starters.append(Anim.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


class Anim:
	var position = Vector2(0, 0)
	var hitbox_position = Vector2(0, 0)
	var knockback = Vector2(0, 0) 
