extends Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(Callable(self, "hover"))
	mouse_exited.connect(Callable(self, "exit"))

func hover() -> void:
	animation_player.play("hover")

func exit() -> void:
	animation_player.play_backwards("hover")

func _pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
