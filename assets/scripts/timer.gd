extends Panel
@onready var minutes_l: Label = $Minutes
@onready var seconds_l: Label = $Seconds
@onready var m_sec: Label = $MSec
var save_path := "user://timer.save"
var time := 0.0
var minutes := 0
var seconds := 0
var msec := 0
@onready var minutes_2: Label = $Minutes2
@onready var seconds_2: Label = $Seconds2
@onready var m_sec_2: Label = $MSec2

var stored_mins
var stored_secs
var stored_msec

func save_score() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ_WRITE)
		if minutes <= stored_mins and seconds <= stored_secs and msec <= stored_secs:
			minutes_2.text = "%02d:" % stored_mins
			seconds_2.text = "%02d." % stored_secs
			m_sec_2.text = "%03d" % stored_msec
	if not FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(minutes)
		file.store_var(seconds)
		file.store_var(msec)

func _ready() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		stored_mins = file.get_var()
		stored_secs = file.get_var()
		stored_msec = file.get_var()
		minutes_2.text = "%02d:" % stored_mins
		seconds_2.text = "%02d." % stored_secs
		m_sec_2.text = "%03d" % stored_secs

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_score()

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
	save_score()
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
