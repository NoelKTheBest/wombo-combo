extends Node

var starters = []

var file = 'res://starters.txt'
var notes = 'res://notes.txt'

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all starter animations
	var animations = get_parent().sprite_frames.get_animation_names()
	var starter_animations = []
	for anim in animations:
		if anim.contains("Start"):
			starter_animations.append(anim)
	print(starter_animations)
	
	for i in starter_animations.size():
		starters.append(Anim.new())
	
	#print(seek_to_index(0))
	#print(seek_to_index(5))
	#print(seek_to_index(9))
	
	#print(find_property('p'))
	#print(find_property('h'))
	#print(find_property('k'))
	
	parse_notes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func find_property(property: String):
	var f = FileAccess.open(file, FileAccess.READ)
	f.seek(2)
	
	var cursor_position: int = 0
	var prop = f.get_8()
	
	while char(prop) != property:
		f.get_line()
		prop = f.get_8()
	
	cursor_position = f.get_position() - 1
	
	print(char(prop))
	
	f.close()
	
	# Pass cursor position and cursor info to seek_to_index()
	
	return cursor_position


func seek_to_index(index: int):
	# function responsible for moving the file cursor to the correct point to grab the data for the 
	#	current animation
	var f = FileAccess.open(file, FileAccess.READ)
	f.seek(2)
	
	var x = ""
	var y = ""
	
	f.seek(f.get_position() + 2)
	
	# Seek to index
	var content = f.get_8() # seek 5
	while int(char(content)) != index:
		content = char(f.get_8())
		while content != ';':
			content = char(f.get_8())
		
		content = f.get_8()
		
		# Return zero vector if index is not found
		if char(content) == ']':
			f.close()
			return Vector2(0, 0)
	
	# Get Data
	if int(char(content)) == index:
		f.seek(f.get_position() + 1)
		
		
		# Get x value
		content = char(f.get_8())
		while content != ',':
			x = x + content
			content = char(f.get_8())
		
		x = int(x)
		
		f.seek(f.get_position() + 1)
		
		# Get y value
		content = char(f.get_8())
		while content != ')':
			y = y + content
			content = char(f.get_8())
		
		y = int(y)
	
	f.close()
	
	return Vector2(x, y) if typeof(x) == typeof(0) else Vector2(0, 0)


func parse_notes():
	var f = FileAccess.open(notes, FileAccess.READ)
	while !f.eof_reached():
		if f.get_position() != 0:
			f.seek(f.get_position() - 1)
		
		var content = f.get_8()
		# Grab property
		match char(content):
			'p':
				print("Position")
			'h':
				print("Hitbox Position")
			'k':
				print("Knockback")
		
		f.seek(f.get_position() + 1)
		
		# Grab index
		var index = ""
		
		while char(content) != ';':
			content = f.get_8()
			if char(content) != ';':
				index += char(content)
		
		print("Index: " + index)
		
		# Grab value
		var x = ""
		var y = ""
		
			# Get x value
		content = char(f.get_8())
		while content != ',':
			x = x + content
			content = char(f.get_8())
		
		x = int(x)
		
		f.seek(f.get_position() + 1)
		
			# Get y value
		content = char(f.get_8())
		while content != '\n':
			y = y + content
			content = char(f.get_8())
		
		y = int(y)

		
		var value: Vector2 = Vector2(x, y)
		print(value)
		
		if char(f.get_8()) == '\n':
			pass
	
	f.close()


class Anim:
	var position: Vector2 = Vector2(0, 0)
	var hitbox_position: Vector2 = Vector2(0, 0)
	var knockback: Vector2 = Vector2(0, 0) 
