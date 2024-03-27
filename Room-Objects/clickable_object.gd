extends RigidBody2D

## The name of the dialogue to play when this object is clicked.
@export var dialogue_name: String = "no_dialogue_set"
## The alpha value to set the sprite to when it is clicked (0 - 1).
@export_range(0, 1) var click_alpha := 0.7

var is_hover_enabled := true
@export var alt_sprite_exists := false
@export_file() var default_sprite
@export_file() var alt_sprite

@export var scale_multiplier: int = 3

var is_hovering: bool

@export var is_lamp = false

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
		#_on_mouse_exited()
		is_hover_enabled = false
		is_hovering = false
		GameManager.overlay.show()
		global_position = GameManager.middle.global_position
		scale *= scale_multiplier
		z_index = 1
		GameManager.show_dialogue(dialogue_name)
		if is_lamp:
			%Cable.hide()
		if alt_sprite_exists:
			$Sprite.texture = load(alt_sprite)
		$Sprite/AnimationPlayer.play_backwards("hover")
		$Sprite.self_modulate = Color(1, 1, 1, 1)
		await GameManager.dialogue_ended
		GameManager.overlay.hide()
		scale = scale / scale_multiplier
		z_index = 0
		
		if alt_sprite_exists:
			$Sprite.texture = load(default_sprite)
		$Sprite.self_modulate = Color(1, 1, 1, 1)
		#await get_tree().create_timer(0.5).timeout
		GameManager.start_box_minigame(self)
		#freeze = false
		
