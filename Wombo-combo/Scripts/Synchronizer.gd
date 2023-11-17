extends Node

# Array to keep track of animations
var starters = []

# File paths
var file = 'res://starters.txt'
var notes = 'res://notes.txt'

# Updates from notes file
var updates = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all starter animations
	var animations = get_parent().sprite_frames.get_animation_names()
	var starter_animations = []
	for anim in animations:
		if anim.contains("Start"):
			starter_animations.append(anim)
	#print(starter_animations)
	
	for i in starter_animations.size():
		starters.append(Anim.new())
	
	#print(seek_to_index(0))
	#print(seek_to_index(5))
	#print(seek_to_index(9))
	
	#print(find_property('p'))
	#print(find_property('h'))
	#print(find_property('k'))
	
	parse_notes()
	print(updates)
	update_data("", 0, Vector2.ZERO)
	
#	write_updated_copy("aabody;ddbody;", "corn", 2)


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
	
	f.close()
	
	# Pass cursor position and cursor info to seek_to_index()
	
	return cursor_position


# Seek to the provided index & return data stored there or return cursor position
func seek_to_index(cursor_position: int, index: int, isRetrievingData: bool):
	var f = FileAccess.open(file, FileAccess.READ)
	f.seek(cursor_position)
	
	var x = ""
	var y = ""
	
	f.seek(f.get_position() + 2)
	
	# Seek to index
	var content = f.get_8()
	while int(char(content)) != index:
		content = char(f.get_8())
		while content != ';':
			content = char(f.get_8())
		
		content = f.get_8()
		
		# Return zero vector if index is not found
		if char(content) == ']':
			f.close()
			return Vector2(0, 0)
	
	# Once index is found, return position if we aren't retrieving data
	if !isRetrievingData: return f.get_position()
	
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
	var i = 0
	var f = FileAccess.open(notes, FileAccess.READ)
	while !f.eof_reached():
		updates.append([])
		if f.get_position() != 0:
			f.seek(f.get_position() - 1)
		
		# Grab property
		var content = f.get_8()
		
		# Store property
		updates[i].append(char(content))
		
		f.seek(f.get_position() + 1)
		
		# Grab index
		var index = ""
		
		while char(content) != ';':
			content = f.get_8()
			if char(content) != ';':
				index += char(content)
		
		# Store Index
		updates[i].append(int(index))
		
		# Grab value
		var x = ""
		var y = ""
		
			# Get x value
		content = char(f.get_8())
		while content != ',':
			x = x + content
			content = char(f.get_8())
		
		x = int(x)
		
			# Get y value
		content = char(f.get_8())
		while content != '\n':
			y = y + content
			content = char(f.get_8())
		
		y = int(y)
		
		var value: Vector2 = Vector2(x, y)
		
		# Store value
		updates[i].append(value)
		
		i += 1
		# Force read of character on next line, forces eof
		if char(f.get_8()) == '\n':
			pass
		
	
	f.close()


# Update data in animation data files from notes
func update_data(property: String, index: int, value: Vector2):
	var f = FileAccess.open(file,FileAccess.READ_WRITE)
	
	# Create copy of file contents to write to
	var file_copy = f.get_as_text()
	
	# Close file
	f.close()
	
	# Grab all cursor positions for updates
	for update in updates:
		write_updated_copy(file_copy, str(update[2]) + ';', 
			seek_to_index(find_property(update[0]), update[1], false))
	
#	print(file_copy.substr(14, 7))
#	print(file_copy.substr(116, 7))
#	print(file_copy.substr(141, 8))
	
	# Concatenate data to copy and pass it to write_updated_copy


func write_updated_copy(copy: String, replacement: String, from: int = 0):
#	print("before:\n" + copy)
	var temp1 = copy.substr(0, from)
	
	var query = copy.substr(from)
	query = query.substr(0, query.find(';') + 1)
	
	var temp2 = copy.substr(from + query.length())
#	print(query)
	query = query.replace(query, replacement)
	copy = temp1 + query + temp2
#	print("after:\n" + copy)
	return copy


# Add a property to an animation data file if needed
func add_property(property: String, index: int, value: Vector2):
	pass


class Anim:
	var position: Vector2 = Vector2(0, 0)
	var hitbox_position: Vector2 = Vector2(0, 0)
	var knockback: Vector2 = Vector2(0, 0) 
