extends Node

var breakers := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for switch in get_tree().get_nodes_in_group("interactable"):
		switch.connect("collect", Callable(self, "_increase"))
	get_tree().get_nodes_in_group("interactable")

signal full()
func _increase() -> void:
	breakers += 1
	print(breakers)
	if breakers >= 8:
		emit_signal("full")
		#Engine.max_fps = 30
