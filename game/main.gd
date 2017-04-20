extends Control

onready var box = get_node("tools/box")
onready var open_btn = box.get_node("file_open_btn")
onready var anim_buttons = box.get_node("anim_buttons")
onready var file_path = box.get_node("file_path")

onready var content = get_node("content")
onready var spine = content.get_node("scroll/spine")

var debug_rect
var alert_dialog

func _ready():
	open_btn.connect("pressed", self, "open_file")
	get_tree().connect("files_dropped", self, "open")
	for debug in ["bones", "region", "mesh"]:
		box.get_node("opts_debug_" + debug).connect("toggled", self, "spine_debug", [debug])
	get_node("content/scroll").connect("input_event", self, "_input")
	alert_dialog = preload("alert.tscn").instance()
	get_node("/root").call_deferred("add_child", alert_dialog)

	
func alert(text):
	alert_dialog.get_node("label").set_text(text)
	alert_dialog.popup_centered()
	
func should_blend():
	return box.get_node("opts_blend").is_pressed()
		
func spine_debug(value, prop):
	spine.set("debug/" + prop, value)
	if prop == "mesh":
		spine.set("debug/skinned_mesh", value)
	
func open_file():
	var dialog = preload("file_selector.tscn").instance()
	get_tree().get_root().add_child(dialog)
	dialog.popup_centered()
	var path = yield(dialog, "file_selected")
	dialog.queue_free()
	open(path)

func open(path, screen=0):
	if typeof(path) == TYPE_STRING_ARRAY:
		path = path[0]
	if !path.ends_with(".json"):
		alert("Wow. I can only open .json files, not this one:" + path)
		return
	
	if path.length() < 20:
		file_path.set_text(path)
	else:
		file_path.set_text("..." + path.substr(path.length()-20, path.length()))
	file_path.set_tooltip(path)
	
	var dir = Directory.new()
	dir.make_dir_recursive("user://res")
	var base_path = path.basename()
	var file_name = path.get_file().basename()
	for ext in [".png", ".atlas", ".json"]:
		dir.copy(base_path + ext, "user://res/" + file_name + ext)
	
	spine.set_resource(null)
	yield(get_tree(), "idle_frame")

	print("opening spine file ", path)
	var res = load("user://res/" + file_name + ".json")
	if !res:
		alert("Ups.. Can't open Spine resource =(")
		return
	spine.set_resource(res)
	
	#spine.set_pos(content.get_size()*0.5 - rect.size*0.5 - rect.pos)
	var pl = spine.get_property_list()
	var animations
	for p in pl:
		if p["name"] == "playback/play":
			animations = Array(p["hint_string"].split(","))
			animations.pop_front()
			
	spine.play(animations[animations.size()-1])
	spine.set_scale(Vector2(1,1))
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
			
	spine.set_pos(content.get_size()*Vector2(0.5, 0.75))
	print("animations: ", animations)
	
	for btn in anim_buttons.get_children():
		btn.queue_free()
	for anim in animations:
		var btn = Button.new()
		btn.set_text(anim)
		btn.connect("pressed", self, "play", [anim])
		anim_buttons.add_child(btn)
		
func play(anim):
	spine.set_active(true)
	var current = spine.get_current_animation(0)
	if should_blend():
		if current:
			spine.mix(current, anim, 0.5)
	else:
		if current:
			spine.mix(current, anim, 0)
	spine.play(anim, 1, true)
	
func _exit_tree():
	var dir = Directory.new()
	for file in list_files("user://res"):
		dir.remove("user://res/" + file)

func list_files(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files


var wantdrag = false
var dragging = false
func _input(event):
	if dragging && event.type == InputEvent.MOUSE_MOTION:
		spine.set_pos(spine.get_pos() + event.relative_pos)
	elif dragging && event.type == InputEvent.MOUSE_BUTTON && !event.is_pressed() && event.button_index == BUTTON_LEFT:
		dragging = false
		wantdrag = false
	elif !wantdrag && !dragging && event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() && event.button_index == BUTTON_LEFT:
		wantdrag = true
	elif wantdrag && !dragging && event.type == InputEvent.MOUSE_MOTION:
		dragging = true
	elif event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() && event.button_index == BUTTON_WHEEL_UP:
		spine.set_scale(spine.get_scale() + Vector2(0.1, 0.1))
	elif event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() && event.button_index == BUTTON_WHEEL_DOWN:
		if spine.get_scale().x > 0.1:
			spine.set_scale(spine.get_scale() - Vector2(0.1, 0.1))
	
	
