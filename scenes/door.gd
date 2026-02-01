extends Area3D


@onready var collider = $StaticBody3D
var open := false

func _physics_process(delta: float) -> void:
	collider.position.x = move_toward(collider.position.x, 1 if open else 0, delta * 3)

func _on_body_exited(body: Node3D) -> void:
	open = false

func _on_body_entered(body: Node3D) -> void:
	open = true
