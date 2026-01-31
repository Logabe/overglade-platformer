extends MeshInstance3D
@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var label_3d: Label3D = $Label3D
@onready var player: CharacterBody3D = $"../Player"
var player_inside := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_3d.connect("body_entered", Callable(self, "_on_body_entered"))
	#area_3d.connect("body_exited", Callable(self, "_on_body_exited"))
	player.connect("player_near", Callable(self, "_player_near"))
	player.connect("player_left", Callable(self, "_player_left"))
	label_3d.hide()


signal collect1()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("pickup"):
		self.visible = false
		area_3d.monitoring = false
		label_3d.hide()
		self.set_physics_process(false)
		emit_signal("collect1")

<<<<<<< Updated upstream:assets/scripts/breaker1.gd
func _player_near(breaker_index):
	if breaker_index == 1:
		label_3d.show()
		player_inside = true

func _player_left(breaker_index):
	if breaker_index == 1:
		label_3d.hide()
=======
func _player_near(breaker):
	if breaker == self:
		print("hi")
		label_3d.visible = true
		player_inside = true

func _player_left(breaker):
	if breaker == self:
		label_3d.visible = false
>>>>>>> Stashed changes:assets/scripts/breaker.gd
		player_inside = false

func _on_button_pressed() -> void:
	self.show()
	self.set_physics_process(true)
