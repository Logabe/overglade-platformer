extends StaticBody3D

@onready var game_manager: Node = $"/root/Node3D/GameManager"
@onready var light_2: MeshInstance3D = $Light2
@onready var directional_light_3d: OmniLight3D = $DirectionalLight3D
@onready var light: MeshInstance3D = $Light

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.connect("full", Callable(self, "_turn_on"))
	directional_light_3d.hide()
	light_2.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _turn_on() -> void:
	directional_light_3d.show()
	light_2.show()
	light.hide()
