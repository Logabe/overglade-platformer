extends Node3D
@export var rod_path:NodePath
@onready var rod = get_node(rod_path)
var entered := 0
var fishing_state := 0
var override := 0.0
var finished: bool = false
func _ready() -> void:
	pass



func _process(_delta: float) -> void:
	finished = rod.finished
	if finished:
		self.hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interation") and entered == 1:
		fishing_state = 1
		
	


func _end_game():
	while entered == 1:
		pass
	fishing_state = 0


func wait_time(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()




func _on_area_3d_body_entered(_body: Node3D) -> void:
	entered = 1


func _on_area_3d_body_exited(_body: Node3D) -> void:
	entered = 0
