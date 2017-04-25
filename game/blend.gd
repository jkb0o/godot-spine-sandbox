extends HBoxContainer

signal changed
signal removed

onready var main = get_node("/root/main")
onready var from_btn = get_node("from")
onready var to_btn = get_node("to")
onready var remove_btn = get_node("remove")
onready var duration = get_node("duration")

func _ready():
	remove_btn.connect("pressed", self, "emit_signal", ["removed"])
	remove_btn.connect("pressed", self, "queue_free")
	for option in [from_btn, to_btn]:
		var idx = 0
		for anim in main.get_animations():
			option.add_item(anim)
			#if option == from_btn && idx == 0 || option == to_btn && idx == 1:
			#	option.select(idx)
			#	option.set_text(anim)
		idx += 1
		option.connect("item_selected", self, "emit_changed")
	duration.connect("value_changed", self, "emit_changed")

func emit_changed(val=null):
	emit_signal("changed")
		
func to_array():
	var arr = []
	arr.append(from_btn.get_item_text(from_btn.get_selected()))
	arr.append(to_btn.get_item_text(to_btn.get_selected()))
	arr.append(duration.get_value())
	return arr
	
func from_array(arr):
	set_block_signals(true)
	var arr_idx = 0
	for option in [from_btn, to_btn]:
		for try_idx in range(option.get_item_count()):
			if option.get_item_text(try_idx) == arr[arr_idx]:
				option.select(try_idx)
				break
		arr_idx += 1
	duration.set_value(arr[2])
	set_block_signals(false)
