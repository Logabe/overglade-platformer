extends StaticBody3D

@onready var player: CharacterBody3D = $"/root/Node3D/Player"
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var label_3d: Label3D = $Label3D
@onready var label_3d_2: Label3D = $Label3D2
@onready var game_manager: Node = $"/root/Node3D/GameManager"
var player_in := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("purify_near", Callable(self, "_purify_near"))
	player.connect("purify_left", Callable(self, "_purify_left"))
	label_3d.hide()
	label_3d_2.hide()

func _purify_near(purifier) -> void:
	if purifier == self:
		label_3d.show()
		player_in = true
		if game_manager.breakers != 8:
			label_3d_2.show()

func _purify_left(purifier) -> void:
	if purifier == self:
		label_3d.hide()
		player_in = false
		label_3d_2.hide()

func _unhandled_input(event: InputEvent) -> void:
	if player_in and Input.is_action_just_pressed("pickup") and game_manager.breakers >= 8:
		self.hide()
		self.set_physics_process(false)
		world_environment.environment.volumetric_fog_density = max(world_environment.environment.volumetric_fog_density - 0.019, 0.0)
		world_environment.environment.fog_density = max(world_environment.environment.fog_density - 0.0095, 0.0)
		print(world_environment.environment.fog_density)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
