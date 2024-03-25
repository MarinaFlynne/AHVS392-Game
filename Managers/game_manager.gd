extends Node

const dialogue_balloon = preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")
const dialogue_resource = preload("res://Dialogue/main.dialogue")
var new_dialogue_allowed := true

var box_game_position: Vector2 = Vector2(1800, 324)
var box_game_camera: Camera2D
var bedroom_camera: Camera2D

var overlay: Sprite2D
var middle: Node2D

var minigame_enabled := false
var drop_enabled := false
var current_minigame_object: RigidBody2D

signal dialogue_started()
signal dialogue_ended()
#signal minigame_ended()

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	drop_enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if minigame_enabled:
		# Make current_minigame_object's x value follow the mouse
		current_minigame_object.global_position.x = get_viewport().get_mouse_position().x + 1224
		# Make the object fall when the player clicks
		if Input.is_action_just_released("mouse_click") && drop_enabled:
			minigame_enabled = false
			current_minigame_object.freeze = false
			minigame_ended()
		pass
		
	
## Show dialogue balloon with the specified dialogue
func show_dialogue(title: String = "", extra_game_states: Array = []) -> void:
	if new_dialogue_allowed:
		dialogue_started.emit()
		new_dialogue_allowed = false
		var balloon: Node = dialogue_balloon.instantiate()
		SceneManager.get_current_scene().add_child(balloon)
		balloon.start(dialogue_resource, title, extra_game_states)
	else:
		print("GameManager: New dialogue disabled. Already in dialogue.")
		pass
		
func _on_dialogue_ended(_resource):
	dialogue_ended.emit()
	await get_tree().create_timer(1).timeout
	new_dialogue_allowed = true
	
func start_box_minigame(object: RigidBody2D):
	current_minigame_object = object
	object.position = box_game_position
	bedroom_camera.enabled = false
	box_game_camera.enabled = true
	minigame_enabled = true
	await get_tree().create_timer(0.8).timeout
	drop_enabled = true
	#await minigame_ended
	#current_minigame_object.freeze = false
	#await get_tree().create_timer(2).timeout
	#bedroom_camera.enabled = true
	#box_game_camera.enabled = false
	
func minigame_ended():
	await get_tree().create_timer(2).timeout
	bedroom_camera.enabled = true
	box_game_camera.enabled = false
	minigame_enabled = false
	drop_enabled = false
	current_minigame_object = null
	

