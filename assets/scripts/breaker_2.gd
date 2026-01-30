extends CSGBox3D


var player_inside := false
@onready var label_3d: Label3D = $Label3D
@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.connect("body_entered", Callable(self, "_on_body_entered"))
	area_3d.connect("body_exited", Callable(self, "_on_body_exited"))
	label_3d.hide()
signal collect2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("pickup"):
		self.hide()
		self.set_physics_process(false)
		emit_signal("collect2")
		
func _on_body_entered(body):
	if body.is_in_group("player"):
		label_3d.show()
		player_inside = true
		
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		label_3d.hide()
		player_inside = false


func _on_button_pressed() -> void:
	self.show()
	self.set_physics_process(true)
