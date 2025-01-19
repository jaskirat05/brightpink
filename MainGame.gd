extends Node2D

var treeheight: float = 0 

var CameraStartOffset: float = 100

var screenheight: float = 0
var startpan: float = 0
@onready var tree = $Tree

var is_any_timmy_active:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	%Camera.offset.y = CameraStartOffset
	
	%BlackFadeAnimationPlayer.play("fade_to_normal")
	get_window().position.y = 50 #because the stupid window bar always starts off screen
func treeHeight():
	return treeheight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		is_any_timmy_active=tree.is_any_tim_active()
		print("Tim is ", is_any_timmy_active)
		treeheight+=delta
		tree.update_difficulty(treeheight)
	
		if is_any_timmy_active:
		# Move camera down to roots when Timmy is active
				%Camera.offset.y = lerp(-650.0, -100.0, ease(delta *80.0, -2.5))
		else:
		# Normal camera behavior for tree growth
				%Camera.offset.y = lerp(CameraStartOffset, -650.0, ease(treeheight*0.5, -2.5))
		
		if(%Camera.offset.y <= -650):
			%HeightCounter.text = "Height: " + str(round_place(treeheight,2))
			%Tree.position.y -= delta*50

		%HeightCounter.text = "Height: " + str(round_place(treeheight,2))
		%Tree.position.y -= delta*50
		
func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))


func _on_collectible_input_event(viewport, event, shape_idx):
	
	pass # Replace with function body.
	

