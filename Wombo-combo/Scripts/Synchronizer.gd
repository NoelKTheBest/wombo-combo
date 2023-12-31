extends Node

# Arrays to keep track of animations
var starters = []
var attacks = []
var finishers = []

# File paths
var starter_file = 'res://starters.txt'
var attacks_file = 'res://attacks.txt'
var finishers_file = 'res://finishers.txt'
var file
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
	
	for i in starter_animations.size():
		starters.append(Anim.new())
	
	# Read changes on startup
	parse_notes()
	
	# Make changes to property data before game starts running
	update_data()
	clear_notes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Searches through animation property data files to find the desired properties
#	index
func find_property(property: String):
	var f = FileAccess.open(file, FileAccess.READ)
	f.seek(2)
	
	var cursor_position: int = 0
	var prop = f.get_8()
	
	while char(prop) != property:
		if f.eof_reached(): break
		f.get_line()
		prop = f.get_8()
	
	if f.eof_reached(): return -1
	
	cursor_position = f.get_position() - 1
	
	var content 
	f.seek(f.get_position() + 1)
	content = f.get_8()
	if char(content) == '-':
		return -2
	
	f.close()
	
	# Pass cursor position and cursor info to seek_to_index()
	
	return cursor_position


# Seek to the provided index & return data stored there or return cursor position
func seek_to_index(cursor_position: int, index: int, isRetrievingData: bool):
	if cursor_position == -1: return
	if cursor_position == -2:
		return [0,'null property']
	
	var known_indices = []
	var f = FileAccess.open(file, FileAccess.READ)
	f.seek(cursor_position)
	
	var x = ""
	var y = ""
	
	f.seek(f.get_position() + 2)
	
	# Seek to index
	var content = f.get_8()
	while int(char(content)) != index:
		known_indices.append(int(char(content)))
		content = char(f.get_8())
		while content != ';':
			content = char(f.get_8())
		
		content = f.get_8()
		
		# Decide what to do if index is not found
		if char(content) == ']':
			if !isRetrievingData:
				# Find where the index should be inserted in order
				var index_to_find = insert_in_order(known_indices, index)
				# Find the position where the new index will go
				var null_position = f.get_position() - 1
				f.close()
				
				# If the new index isn't in range of our known indices return null_position
				if index_to_find >= known_indices[known_indices.size() - 1]:
					return [null_position, 'null']
				
				# Return index to find
				return [index_to_find, 'index']
			f.close()
			# Return zero vector if we are retrieving data
			return Vector2(0, 0)
	
	# Once index is found, return position if we aren't retrieving data
	if !isRetrievingData: 
		var return_position = f.get_position()
		f.close()
		return return_position
	
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


# Parses the changes listed in the notes files and adds them as updates to an 
#	update array
func parse_notes():
	var i = 0
	var f = FileAccess.open(notes, FileAccess.READ)
	
	# Check first 16 bits of file to see if there are any notes 
	if f.get_16() == 0:
		pass
	else:
		f.seek(0)
		var type = f.get_8()
		f.seek(f.get_position() + 2)
		
		match type:
			49: # 1
				file = starter_file
			50: # 2
				file = attacks_file
			51: # 3
				file = finishers_file
	
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
		
		# Add value telling update_data() how to process the update
		content = char(f.get_8())
		if content == '+':
			updates[i].append('insert')
		elif content == '-':
			updates[i].append('remove')
		else:
			updates[i].append('modify')
			f.seek(f.get_position() - 1)
		
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
func update_data():
	if updates.size() == 0: return
	
	var f = FileAccess.open(file,FileAccess.READ_WRITE)
	
	# Create copy of file contents to write to
	var file_copy = f.get_as_text()
	
	# Close file
	f.close()
	
	# Grab all cursor positions for updates
	for update in updates:
		if update[2] == 'modify':
			file_copy = modify_at_index(file_copy, str(update[3]) + ';', 
			seek_to_index(find_property(update[0]), update[1], false))
		elif update[2] == 'insert':
			file_copy = add_at_index(file_copy, update[0], update[1], update[3])
		elif update[2] == 'remove':
			file_copy = remove_at_index(file_copy, update[0], update[1])
	
	# Reopen file to finalize changes
	f = FileAccess.open(file, FileAccess.WRITE)
	f.store_string(file_copy)
	f.close()


# Takes a copy of the file being used to save animation property data and makes
#	 the changes listed in the notes file
func modify_at_index(copy: String, replacement: String, from: int = 0):
	var temp1 = copy.substr(0, from)
	
	var query = copy.substr(from)
	query = query.substr(0, query.find(';') + 1)
	
	var temp2 = copy.substr(from + query.length())
	
	query = query.replace(query, replacement)
	copy = temp1 + query + temp2
	
	return copy


# Clears the notes file
func clear_notes():
	# Clear data
	var f = FileAccess.open(notes, FileAccess.WRITE)
	f.store_8(0)
	f.close()


# Adds a value to a property at a specified index. Does not modify existing values
func add_at_index(copy: String, property: String, index: int, value: Vector2):
	# Return 2 element array, the second element tells us what to do with the first
	var results = seek_to_index(find_property(property), index, false)
	if typeof(results) == typeof(0): return
	
	var temp_position
	var temp1
	var temp2
	var new_copy
	if results[1] == 'index':
		# Call seek_to_index once more
		temp_position = seek_to_index(find_property(property), results[0], false) - 1
		temp_position += copy.substr(temp_position).find(';') + 1
		temp1 = copy.substr(0, temp_position)
		temp2 = copy.substr(temp_position)
		new_copy = temp1 + str(index) + str(value) + ';' + temp2
	elif results[1] == 'null':
		temp_position = results[0]
		temp1 = copy.substr(0, temp_position)
		temp2 = copy.substr(temp_position)
		new_copy = temp1 + str(index) + str(value) + ';' + temp2
	elif results[1] == 'null property':
		temp_position = copy.find(property) + 2
		temp1 = copy.substr(0, temp_position)
		temp2 = copy.substr(temp_position)
		temp2 = temp2.substr(0, 2).replace('-;', str(index) + str(value) + ';')
		new_copy = temp1 + temp2 + copy.substr(temp_position + 2)
	
	return new_copy


# Returns the last known index smaller than the given index
func insert_in_order(indices: Array, index: int):
	var i = 0
	for num in indices:
		if num > index:
			# Returning the previous index element so we can get a position in 
			#	between a larger and smaller index
			return indices[i - 1] if i > 0 else indices[0]
		
		i += 1
	
	return i


# Removes a value from a property at the given index
func remove_at_index(copy: String, property: String, index: int):
	var position = seek_to_index(find_property(property), index, false) - 1
	
	var temp1 = copy.substr(0, position)
	position += copy.substr(position).find(';') + 1
	var temp2 = copy.substr(position)
	
	if temp1.ends_with('[') and temp2.begins_with(']'):
		return temp1 + '-;' + temp2
	
	return temp1 + temp2


# Add a property to an animation data file if needed
func add_property(property: String):
	pass


class Anim:
	var position: Vector2 = Vector2(0, 0)
	var hitbox_position: Vector2 = Vector2(0, 0)
	var knockback: Vector2 = Vector2(0, 0) 
