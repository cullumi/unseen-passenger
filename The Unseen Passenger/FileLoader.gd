extends Object

class_name FileLoader

# File Extension Constants
const EXT:Dictionary = {
	AUDIO=[".ogg", ".wav"],
	SCENE=[".tscn"]
}

enum OUT {DICT, ARRAY}

static func load_files_to(str_dir : String, extensions=[], file_list = OUT.ARRAY):
	match file_list:
		OUT.ARRAY: file_list = []
		OUT.DICT: file_list = {}
	var dir : Directory = Directory.new()
# warning-ignore:return_value_discarded
	dir.open(str_dir)
# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not dir.current_is_dir():
			if file_type_valid(file, extensions):
				if file_list is Array:
					file_list.append(load(dir.get_current_dir() + "/" + file))
				elif file_list is Dictionary:
					var split_name = file.split(".")
					var sliced_name = Strings.slice(split_name, 0, split_name.size()-1)
					var final_name = sliced_name.join("")
					file_list[final_name] = load(dir.get_current_dir() + "/" + file)
	dir.list_dir_end()
	return file_list

static func file_type_valid(file, extensions:Array):
	if extensions.empty():
		return true
	for extension in extensions:
		if file.ends_with(extension):
			return true
	return false
