extends Node2D

#for keeping track of time since start of game
var delta_time: float = 0
#Measures height of tree for score purposes 
var tree_height: float = 0 

var camera_offset_start: float = 100

var screenheight: float = 0
var startpan: float = 0
@onready var tree = $Tree
var sun_speed 


# Called when the node enters the scene tree for the first time.
func _ready():
	%Camera.offset.y = camera_offset_start

	$"UI Layer/FadeTransitions/AnimationPlayer".play("fade_to_normal")
	get_window().position.y = 50 #because the stupid window bar always starts off screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tree_height+=delta
	%Camera.offset.y = lerp(camera_offset_start,-650.0, ease(tree_height*0.5,-2.5))
	
	if(%Camera.offset.y <= -650):

		%HeightCounter.text = "Height: " + str(round_place(tree_height,2))
		%Tree.position.y -= delta*50
	pass

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))


func _on_collectible_input_event(viewport, event, shape_idx):
	
	pass # Replace with function body.
	

