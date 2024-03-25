extends Area2D

## The name of the dialogue to play when this object is clicked.
@export var dialogue_name: String = "no_dialogue_set"
## The alpha value to set the sprite to when it is clicked (0 - 1).
@export_range(0, 1) var click_alpha := 0.7

@export var kitty_overlay: Sprite2D

var is_hover_enabled := true


var is_hovering: bool

signal clicked

func _process(delta):
	if (is_hover_enabled):
		# Make the sprite slightly transparent while it's clicked
		if Input.is_action_pressed("mouse_click") and is_hovering:
			pass
			$Sprite.self_modulate = Color(1, 1, 1, click_alpha)
		else:
			$Sprite.self_modulate = Color(1, 1, 1, 1)

func _on_mouse_entered():
	if (is_hover_enabled && input_pickable):
		is_hovering = true
		$Sprite/AnimationPlayer.play("hover")


func _on_mouse_exited():
	if (is_hover_enabled && input_pickable):
		is_hovering = false
		$Sprite/AnimationPlayer.play_backwards("hover")


func _on_input_event(_viewport, event, _shape_idx):
	if (is_hover_enabled && input_pickable):
		if event is InputEventMouseButton and Input.is_action_just_released('mouse_click'):
			clicked.emit()

func _on_clicked():
	if GameManager.new_dialogue_allowed:
		input_pickable = false
		_on_mouse_exited()
		is_hover_enabled = false
		is_hovering = false
		$Sprite.hide()
		kitty_overlay.show()
		get_tree().create_timer(2).timeout
		GameManager.show_dialogue(dialogue_name)
		await GameManager.dialogue_ended
		get_tree().create_timer(0.5).timeout
		$Sprite.show()
		kitty_overlay.hide()
		input_pickable = true
		is_hover_enabled = true
	
