extends CanvasLayer

# --- Configuration ---
@export var trigger_node_path: NodePath # Path to the 3D node with the variable
@export var success_margin: float = 40.0 # How close the fish must be to the center
@export var min_fish_speed: float = 250.0
@export var max_fish_speed: float = 550.0
@export var min_wait_time: float = 1.0
@export var max_wait_time: float = 4.0
var current_fish_speed: float = 0.0

var is_active = false
var fish_caught = false
@onready var trigger_node = get_node(trigger_node_path)
var finished := 0

@onready var target_circle = $Control/TargetCircle
@onready var fish_icon = $Control/FishIcon
@onready var status_label = $Control/StatusLabel

func _ready():
	# Hide the UI until the game starts
	randomize()
	self.visible = false
	trigger_node = get_node(trigger_node_path)
	reset_minigame()
	$Control/Sprite2D.modulate = Color(0.5, 0.5, 0.5, 1.0)

func _process(delta):
	# 1. Watch for the trigger variable (change "fishing_state" to your variable name)
	if trigger_node and trigger_node.fishing_state == 1 and not is_active:
		start_minigame()

	if is_active:
		move_fish(delta)
		check_input()

func start_minigame():
	is_active = true
	self.visible = true
	status_label.text = "Waiting for a bite..."
	fish_icon.modulate.a = 0 # Hide fish while waiting
	
	# Randomize the "wait for splash" time (Minecraft style)
	var wait_time2 = randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time2).timeout
	
	if not is_active: return # Safety check if player cancelled
	
	# Randomize Speed and Appearance
	status_label.text = "NIBBLE!"
	fish_icon.modulate.a = 1 
	current_fish_speed = randf_range(min_fish_speed, max_fish_speed)
	
	# Randomize Side: 50% chance left or right
	var side_multiplier = 1 if randf() > 0.5 else -1
	fish_icon.position = Vector2(target_circle.position.x + (400 * side_multiplier), target_circle.position.y)

func move_fish(delta):
	var direction = (target_circle.position - fish_icon.position).normalized()
	fish_icon.position += direction * current_fish_speed * delta # Uses the random speed
	
	# Lose if the fish moves too far past the center
	if fish_icon.position.distance_to(target_circle.position) > 600:
		end_minigame(false)


func check_input():
	if Input.is_action_just_pressed("ui_accept"): # "ui_accept" is Space by default
		var distance = fish_icon.position.distance_to(target_circle.position)
		
		if distance <= success_margin:
			end_minigame(true)
		else:
			end_minigame(false)

func end_minigame(success: bool):
	is_active = false
	if success:
		status_label.text = "CATCH!"
		#put wait logic and stuff
		finished = 1
		await wait_time(.8) #Yay sound?!
		status_label.text = "You have now depleted the otter's only food source!"
	else:
		status_label.text = "LOST IT... ):"

	# Tell the 3D node to stop fishing (reset variable)
	if trigger_node:
		trigger_node.fishing_state = 0
	
	# Wait 1 second so player sees the result, then hide
	await wait_time(1)
	self.visible = false
	reset_minigame()

func reset_minigame():
	fish_icon.position = Vector2(-1000, -1000) # Move off-screen


func wait_time(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
