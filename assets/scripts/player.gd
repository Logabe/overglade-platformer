extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var ray_cast_3d: RayCast3D = $Head/Camera3D/RayCast3D
var mouse_captured := false
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var spot_light_3d: SpotLight3D = $Head/Camera3D/SpotLight3D
var flash_on := false
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	spot_light_3d.hide()
		# Set horizontal anchors to 0 (Left Side)
	self.anchor_left = 0
	self.anchor_right = 0
	
	# Set vertical anchors to stretch top-to-bottom (0 to 1)
	self.anchor_top = 0.3
	self.anchor_bottom = 0.7
	
	# Set offsets to maintain 30px width and zero vertical margin
	self.offset_left = 0
	self.offset_right = 30 # This fixes the width to 30px
	#self.offset_top = 0
	#self.offset_bottom = 0
func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_captured = false
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_captured = true
	if event is InputEventMouseMotion and mouse_captured == true:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera_3d.rotate_x(-event.relative.y * SENSITIVITY)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	if event.is_action_pressed("flashlight"):
		if flash_on:
			spot_light_3d.hide()
			flash_on = false
		elif !flash_on or flash_on == false:
			spot_light_3d.show()
			flash_on = true
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
signal player_near(breaker)
signal player_left(breaker)
var last_near_breaker
func _process(delta: float) -> void:
	var new_near_breaker
	if ray_cast_3d.is_colliding():
		var obj = ray_cast_3d.get_collider()
		if obj.is_in_group("interactable"):
			emit_signal("player_near", obj)
			new_near_breaker = obj
	if new_near_breaker and !last_near_breaker:
		emit_signal("player_near", new_near_breaker)
	if !new_near_breaker and last_near_breaker:
		emit_signal("player_left", last_near_breaker)
	last_near_breaker = new_near_breaker
	
	if flash_on:
		progress_bar.value -= delta * 10
	if !flash_on:
		progress_bar.value += delta/2
