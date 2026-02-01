extends Panel
@onready var minutes_l: Label = $Minutes
@onready var seconds_l: Label = $Seconds
@onready var m_sec: Label = $MSec

var time := 0.0
var minutes := 0
var seconds := 0
var msec := 0

func _process(delta: float) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60) 
	minutes = fmod(time, 3600)  / 60
	minutes_l.text = "%02d:" % minutes
	seconds_l.text = "%02d." % seconds
	m_sec.text = "%03d:" % msec


func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
