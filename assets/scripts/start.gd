extends Control
@export var light_path:NodePath
@onready var light_script = get_node(light_path)
var play = 0
var first := 1
var lights_on: bool = false
@onready var button: Button = $Button
var musica = 0
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	
func _on_exit_to_menu():
	play = 0
func _process(_delta: float) -> void:
	if play == 0 and musica == 0:
		$menu_music.play()
		musica = 1
	lights_on = light_script.lights_on
	if play == 1 and first == 1:
		first = 0
		$dark_music.play()
	if lights_on and first == 0:
		first = 2
		$dark_music.stop()
		$main_music.play()
	if first == 2 and not $main_music.playing:
		$main_music.play()
func _on_button_pressed() -> void:
	#print("button works")
	play = 1
	$menu_music.stop()
	self.hide()
func _on_menu_music_finished() -> void:
	musica = 0


func wait_time(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
