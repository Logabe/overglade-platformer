extends Node3D
var entered := 0
var fishing_state := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interation") and entered == 1:
		fishing_state = 1
		await wait_time(.2)
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
