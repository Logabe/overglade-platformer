extends CanvasLayer

@export var trigger_node_path: NodePath 
@export var success_margin: float = 40.0 
@export var min_fish_speed: float = 250.0
@export var max_fish_speed: float = 550.0
@export var min_wait_time: float = 1.0
@export var max_wait_time: float = 4.0

var current_fish_speed: float = 0.0
var is_active: bool = false
var is_ending: bool = false # Prevents logic overlap during "Catch/Loss" screens
var direction_to_target: Vector2 = Vector2.ZERO
var finished: bool = false

@onready var trigger_node = get_node_or_null(trigger_node_path)
@onready var ui_container = $Control
@onready var target_circle = $Control/TargetCircle
@onready var fish_icon = $Control/FishIcon
@onready var status_label = $Control/StatusLabel

func _ready():
	hide()
	setup_anchors()
	reset_minigame()

func _process(delta):
	# Check if the external trigger wants to start fishing
	if trigger_node and trigger_node.get("fishing_state") == 1:
		if not is_active and not is_ending:
			start_minigame()
		
		# FIXED: These must be indented to stay inside the 'if is_active' block
		if is_active:
			move_fish(delta)
			check_input()

func setup_anchors():
	ui_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	target_circle.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	status_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	status_label.position.y += 50 

func start_minigame():
	is_active = true
	is_ending = false
	show()
	status_label.text = "Waiting for a bite..."
	fish_icon.hide()
	
	await get_tree().create_timer(randf_range(min_wait_time, max_wait_time)).timeout
	
	if not is_active: return 
	
	status_label.text = "NIBBLE!"
	fish_icon.show()
	current_fish_speed = randf_range(min_fish_speed, max_fish_speed)
	
	var random_angle = randf_range(0, TAU)
	var spawn_distance = get_viewport().get_visible_rect().size.x / 1.5
	# FIXED: Added 'var' keyword
	offset = Vector2.RIGHT.rotated(random_angle) * spawn_distance
	
	fish_icon.global_position = target_circle.global_position + offset
	direction_to_target = (target_circle.global_position - fish_icon.global_position).normalized()
	fish_icon.rotation = direction_to_target.angle()

func move_fish(delta):
	if not fish_icon.visible: return
	
	fish_icon.global_position += direction_to_target * current_fish_speed * delta
	
	var distance = fish_icon.global_position.distance_to(target_circle.global_position)
	var dot_product = direction_to_target.dot((target_circle.global_position - fish_icon.global_position).normalized())
	
	# If the fish has flown past the target circle
	if dot_product < 0 and distance > success_margin:
		end_minigame(false)

func check_input():
	if Input.is_action_just_pressed("ui_accept"):
		var distance = fish_icon.global_position.distance_to(target_circle.global_position)
		if distance <= success_margin:
			end_minigame(true)
		else:
			end_minigame(false)

func end_minigame(success: bool):
	if not is_active: return
	is_active = false
	is_ending = true # Mark that we are in the "showing result" phase
	
	if success:
		finished = true
		status_label.text = "CATCH!"
		if trigger_node: trigger_node.set("fishing_state", 2)
		await get_tree().create_timer(0.8).timeout
		status_label.text = "You depleted the food source!"
	else:
		status_label.text = "LOST IT... ):"
		if trigger_node: trigger_node.set("fishing_state", 0)
	
	await get_tree().create_timer(1.5).timeout
	hide()
	reset_minigame()
	is_ending = false # Allow the game to be triggered again

func reset_minigame():
	fish_icon.hide()
	# Move far offscreen so it's not accidentally visible
	fish_icon.global_position = Vector2(-2000, -2000)
