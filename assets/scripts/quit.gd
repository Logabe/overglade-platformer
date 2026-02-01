extends Control
@onready var button: Button = $Button
@export var start_path:NodePath
@onready var start_script = get_node(start_path)
var play = 0
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	

func _process(_delta: float) -> void:
	play = start_script.play
	if play == 0:
		self.hide()
func _on_button_pressed() -> void:
	get_tree().quit()

func wait_time(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
