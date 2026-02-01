extends Node

@export_multiline var strings: Array[String] = []
signal dialog_stepped(number: int)
# UI references
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = %Label
@onready var parent_script: Node = get_parent()

# Dialogue state variables
var parent = 0
var inTalkRange := false  # Is player in range to talk?
var character_speaking: Tween  # Tween for text animation
var textLoaded = true  # Has current text finished loading?
var dialogNumber := 0
var first := 1
func step_dialog():
	dialogNumber += 1
	await get_tree().process_frame
	emit_signal("dialog_stepped", dialogNumber)
	print("Emitting", dialogNumber)

var finished = 0 # for parent functions

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer.hide()  

func _input(_event: InputEvent) -> void: #Swap out for start of game by calling a var.
	if canvas_layer.visible:
		_dialog_input()
	else:
		_talk_to_input()

func _dialog_input():
	if Input.is_action_just_pressed("ui_accept"):
		if textLoaded:
			if parent == 1:
				_next_dialog()  # Go to next dialogue line
			else:
				_next_dialog()
				#step_dialog()
		else:
			_fast_show()  # Skip text animation

func _next_dialog():
	# Move to next dialogue or quit if at end
	dialogNumber += 1
	if dialogNumber >= strings.size():  # Fixed: Added >= for safety
		finished = 1
		_quit_dialog()
	else:
		_start_dialog()
	await get_tree().process_frame
	emit_signal("dialog_stepped", dialogNumber) #Still don't know how to use signas (NOTE)
	print("Emitting", dialogNumber)

func _quit_dialog():
	# Exit dialogue system
	dialogNumber = 0
	get_tree().paused = false
	canvas_layer.hide()

func _fast_show():
	# Skip text animation and show full text immediately
	if character_speaking:  # Fixed: Check if tween exists before killing
		character_speaking.kill()
	label.visible_ratio = 1.0  # Fixed: Use 1.0 for float
	textLoaded = true

func _talk_to_input():
	# Handle input when not in dialogue (start dialogue if in range)
	if Input.is_action_just_pressed("interation") and inTalkRange:
		_start_dialog()

func _start_dialog():
	# Initialize and start dialogue display
	if dialogNumber >= strings.size():  # Fixed: Safety check
		return
	canvas_layer.show()  # Show dialogue UI
	label.visible_ratio = 0.0  # Reset text visibility
	label.text = strings[dialogNumber]  # Set current dialogue text
	get_tree().paused = true  # Pause game
	_dialog_animation()  # Start text animation

func _dialog_animation():
	# Animate text appearing character by character
	textLoaded = false
	
	# Kill previous tween if it exists
	if character_speaking:
		character_speaking.kill()
	
	# Create new tween for text animation
	character_speaking = create_tween()
	character_speaking.tween_property(label, "visible_ratio", 1.0, 1.0)  # Fixed: correct method and property
	await character_speaking.finished
	textLoaded = true

func _process(_delta: float) -> void:
	#parent = parent_script.dialog_identifier # for identifying special cases if need be within dialog script.
	if first == 1: #change to equals 1 for starting dialog
		if textLoaded:
			if parent == 1:
				_next_dialog()  # Go to next dialogue line
			else:
				_next_dialog()
				#step_dialog()
		else:
			_fast_show()  # Skip text animation
		first = 0
	if parent == 2 and finished == 1:
		inTalkRange = false

func wait_time(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
