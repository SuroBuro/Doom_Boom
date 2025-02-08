extends Node3D

@export var enemy:PackedScene

func spawn():
	var Entity = enemy.instantiate()
	add_child(Entity)


func _on_timer_timeout() -> void:
	spawn()
