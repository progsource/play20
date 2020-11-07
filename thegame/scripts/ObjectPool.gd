extends Reference

# The object pool expects the object to have an id variable with which it can
# be identified.
# Before being able to use the object pool, you need to call init_object_pool().

var unused_objects = []
var used_objects = []

func init_object_pool(var packed : String, var object_pool_size : int) -> void :
	var packed_scene = load(packed)
	for i in range(object_pool_size):
		var scene = packed_scene.instance()
		scene.id = i
		unused_objects.append(scene)

func get_object():
	if unused_objects.size() == 0:
		return null
	
	var obj = unused_objects.pop_back()
	used_objects.append(obj)
	
	return obj

func return_object(var return_obj) -> void :
	for i in range(used_objects.size()):
		var o = used_objects[i]
		if o.id == return_obj.id:
			used_objects.remove(i)
			unused_objects.append(return_obj)
			break

