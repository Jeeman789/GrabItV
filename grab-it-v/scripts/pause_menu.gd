extends Control


func _on_continue_button_button_down() -> void:
	EventBus.pause.emit()


func _on_options_button_button_down() -> void:
	pass # Replace with function body.
