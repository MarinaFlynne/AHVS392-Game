extends Area2D

## The name of the dialogue to play when this object is clicked.
@export var dialogue_name: String = "no_dialogue_set"
## The alpha value to set the sprite to when it is clicked (0 - 1).
@export_range(0, 1) var click_alpha := 0.7

var is_hovering: bool

signal clicked

func _process(delta):
	# Make the sprite slightly transparent while it's clicked
	if Input.is_action_pressed("mouse_click") and is_hovering:
		pass
		$Sprite.self_modulate = Color(1, 1, 1, click_alpha)
	else:
		$Sprite.self_modulate = Color(1, 1, 1, 1)

func _on_mouse_entered():
	is_hovering = true
	$Sprite/AnimationPlayer.play("hover")


func _on_mouse_exited():
	is_hovering = false
	$Sprite/AnimationPlayer.play_backwards("hover")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_action_just_released('mouse_click'):
		clicked.emit()
		#print("clicked")
		

func _on_clicked():
	# DialogueManager.show(dialogue_name)
	pass
