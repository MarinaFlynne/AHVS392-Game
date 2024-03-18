extends Node

const dialogue_balloon = preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")
const dialogue_resource = preload("res://Dialogue/main.dialogue")
var new_dialogue_allowed := true


signal dialogue_started()
signal dialogue_ended()

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	#await get_tree().create_timer(1).timeout
	new_dialogue_allowed = true
