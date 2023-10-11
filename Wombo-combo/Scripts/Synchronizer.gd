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

# get_position() returns the number of bytes away from the start of the file the cursor is, not the number of bits
var seeker

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = FileAccess.open(file, FileAccess.READ)
	# i may want to get all starter animations first
	var content = f.get_line()
	seeker = f.get_position()
	
	# Get number of animations
	for i in int(content):
		print(i)
		starters.append(Anim.new())
	print(starters)
	
	content = f.get_8()
	seeker = f.get_position()
	print("seeker: " + str(seeker))
	print(char(content))
	while !f.eof_reached():
		#f.seek(f.get_position() + 1)
		print(char(f.get_8()))
	
	# Get all starter animations
	var animations = get_parent().sprite_frames.get_animation_names()
	var starter_animations = []
	for anim in animations:
		if anim.contains("Start"):
			starter_animations.append(anim)
	print(starter_animations)
	print(starter_animations.size())
	
	# file.seek(file.get_position() + n) skips n number of bytes
	# file.get_8() automatically advances cursor forward 1 byte
	# file.get_line() retrieves the entire line and advances cursor to the beginning of the next line
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func seek_to_index(index):
	# function responsible for moving the file cursor to the correct point to grab the data for the 
	#	current animation
	pass


class Anim:
	var position = Vector2(0, 0)
	var hitbox_position = Vector2(0, 0)
	var knockback = Vector2(0, 0) 
