extends Control



func _on_button_button_down() -> void:
	EventBus.reset_level.emit()
	get_tree().paused = false
	queue_free()
