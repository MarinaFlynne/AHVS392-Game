extends Node2D

@export var bedroom_camera: Camera2D
@export var box_game_camera: Camera2D
@export var box_game_marker: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.bedroom_camera = bedroom_camera
	GameManager.box_game_camera = box_game_camera
	GameManager.box_game_position = box_game_marker.position
	GameManager.overlay = %Overlay
	GameManager.middle = %MiddleMarker


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
