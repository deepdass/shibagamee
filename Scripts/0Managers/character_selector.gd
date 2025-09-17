extends Panel

var icon = null:
	set(value):
		icon = value
		$Panel/Texturebut.texture_normal = value
		
signal pressed

func _ready() -> void:
	$Select.hide()


func _on_texturebut_pressed() -> void:
	for slot in get_parent().get_children():
		slot.deselect()
	$Select.show()
	pressed.emit()

func deselect():
	$Select.hide()
