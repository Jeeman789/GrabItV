extends Control



func _on_button_button_down() -> void:
	EventBus.reset_level.emit()
