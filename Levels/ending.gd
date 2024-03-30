extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.show_dialogue("all_packed")
	await GameManager.dialogue_ended
	$Sprite2D2/AnimationPlayer.play("fade_in")
	await $Sprite2D2/AnimationPlayer.animation_finished
	$Car_noise.play()
	await get_tree().create_timer(3).timeout
	$"End Label".show()
	await get_tree().create_timer(1).timeout
	$"End Label2".show()
