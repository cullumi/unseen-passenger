extends Object

class_name Arrays

static func print_all(arr:Array):
	print("Printing All...")
#	var p_str:String = ""
#	for i in range(0, arr.size()):
#		p_str += "\t[ " + arr[i] + " ]\t"
#		if (i < arr.size()-1 and i % w == w-1):
#			p_str += "\n"
#	print(p_str)
	print(arr)

static func print_names(arr:Array, w:int=3):
	print("Printing Names...")
	var p_str:String = ""
	for i in range(0, arr.size()):
		p_str += "\t[ " + arr[i].name + " ]\t"
		if (i < arr.size()-1 and i % w == w-1):
			p_str += "\n"
	print(p_str)
