extends Object

class_name Strings

static func slice(array:PoolStringArray, from:int, to:int, step:int=1):
	var final = PoolStringArray([])
	for i in range(from, to, step):
		final.append(array[i])
	return final
