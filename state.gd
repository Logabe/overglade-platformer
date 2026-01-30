extends Node
@onready var breaker_1: CSGBox3D = $"../Breaker1"
@onready var breaker_2: CSGBox3D = $"../Breaker2"
@onready var breaker_3: CSGBox3D = $"../Breaker3"
var breakers := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	breaker_1.connect("collect1", Callable(self, "_increase"))
	breaker_2.connect("collect2", Callable(self, "_increase"))
	breaker_3.connect("collect3", Callable(self, "_increase"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _increase() -> void:
	breakers += 1
	print(breakers)
