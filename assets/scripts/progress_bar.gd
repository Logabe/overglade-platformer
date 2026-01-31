extends ProgressBar

@onready var style := self.get_theme_stylebox("fill", "ProgressBar") as StyleBoxFlat
var colors: Array[Color] = [Color.RED, Color.GREEN]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.value = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	style.bg_color = colors[0].lerp(colors[1], value / max_value)
	add_theme_stylebox_override("fill", style)
