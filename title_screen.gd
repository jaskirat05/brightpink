extends Node2D

var startanimation: float = 0
var titleanimed: bool = true
var startanimed: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.visible = false
	$Title2.add_theme_color_override("default_color", Color(0,0,0,0))
	$AudioStreamPlayer.play()
	
	$"UI Layer/FadeTransitions/AnimationPlayer".play("fade_to_normal")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	startanimation += delta
	
	if(startanimation > 3 && titleanimed == true):
		titleanimed = false
		$"Title/AnimationPlayer".play("fade_in")
		$Title.visible = true


	
	if(startanimation >5 && startanimed == true):
		startanimed = false
		$"Title2/AnimationPlayer".play("fade_to_normal")
		$Title2.visible = true

func _on_title_2_mouse_entered():
	$"Title2".add_theme_constant_override("outline_size",20)
	pass # Replace with function body.

func _on_title_2_mouse_exited():
	$"Title2".remove_theme_constant_override("outline_size")
	pass # Replace with function body.

func _on_title_2_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://MainGame.tscn")
	pass # Replace with function body.


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.
