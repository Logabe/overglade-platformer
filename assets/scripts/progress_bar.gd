extends ProgressBar

@onready var style := self.get_theme_stylebox("fill", "ProgressBar") as StyleBoxFlat
var colors: Array[Color] = [Color.RED, Color.GREEN]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.value = value
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	style.bg_color = colors[0].lerp(colors[1], value / max_value)
	add_theme_stylebox_override("fill", style)
