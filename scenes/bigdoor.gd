extends Area3D


@onready var collider = $StaticBody3D
@onready var collider2 = $StaticBody3D2
var open := false

func _physics_process(delta: float) -> void:
	collider.position.x = move_toward(collider.position.x, 1.75 if open else 0.75, delta * 3)
	collider2.position.x = move_toward(collider2.position.x, -1.75 if open else -.75, delta * 3)

func _on_body_exited(body: Node3D) -> void:
	open = false

func _on_body_entered(body: Node3D) -> void:
	if get_node("/root/Node3D/GameManager").breakers >= 8:
		open = true
