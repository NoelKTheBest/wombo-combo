extends Node

# Get all files from starter attacks, basic attacks, and finishers and place them in this variable
var web = [["starter"], ["basic attacks"], ["finishers"]]
var starter_path = "res://Player Character/Starters"
var attacks_path = "res://Player Character/Attacks/"
var finisher_path = "res://Player Character/Finishers/"


# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents(starter_path)
	print("------------------")
	dir_contents(attacks_path)
	print("------------------")
	dir_contents(finisher_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_input():
	pass


func calculate_combo_value():
	pass


func dir_contents(path):
	print(path)
	var count = 0
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			count += 1
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	print("This directory has " + str(count / 2) + " files")
