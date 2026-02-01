extends StaticBody3D
var lights_on: bool = false

@onready var game_manager: Node = $"/root/Node3D/GameManager"
@onready var light_2: MeshInstance3D = $Light2
@onready var directional_light_3d: OmniLight3D = $DirectionalLight3D
@onready var directional_light_3d_2: OmniLight3D = $DirectionalLight3D2
@onready var directional_light_3d_3: OmniLight3D = $DirectionalLight3D3
@onready var directional_light_3d_4: OmniLight3D = $DirectionalLight3D4
@onready var directional_light_3d_5: OmniLight3D = $DirectionalLight3D5
@onready var directional_light_3d_6: OmniLight3D = $DirectionalLight3D6
@onready var light: MeshInstance3D = $Light

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.connect("full", Callable(self, "_turn_on"))
	directional_light_3d.hide()
	directional_light_3d_2.hide()
	directional_light_3d_3.hide()
	directional_light_3d_4.hide()
	directional_light_3d_5.hide()
	directional_light_3d_6.hide()
	light_2.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _turn_on() -> void:
	lights_on = true
	directional_light_3d.show()
	directional_light_3d_2.show()
	directional_light_3d_3.show()
	directional_light_3d_4.show()
	directional_light_3d_5.show()
	directional_light_3d_6.show()
	light_2.show()
	light.hide()
