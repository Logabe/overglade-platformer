extends Control
var play = 0
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
