extends Node
@onready var breaker: Label = $"../CanvasLayer/Breaker"
@onready var purifiers: Label = $"../CanvasLayer/Purifiers"
var purifiers_count := 0
var breakers := 7
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for switch in get_tree().get_nodes_in_group("interactable"):
		switch.connect("collect", Callable(self, "_increase"))
	get_tree().get_nodes_in_group("interactable")

signal full()
func _increase() -> void:
	if breakers <= 8:
		breakers += 1
		print(breakers)
		breaker.text = "Breakers: " + String.num(breakers, 0) + "/8"
		if breakers >= 8:
			emit_signal("full")
			#Engine.max_fps = 30
		
