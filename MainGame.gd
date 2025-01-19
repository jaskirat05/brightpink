extends Node2D

var treeheight: float = 0 
var treeheightstart: float = 0
var screenheight: float = 0
var startpan: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	%Camera.offset.y = 200
	
	%BlackFadeAnimationPlayer.play("fade_to_normal")
	get_window().position.y = 50 #because the stupid window bar always starts off screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(%Camera.offset.y > -480):
		%Camera.offset.y = lerp(%Camera.offset.y, -500.0, 0.01)
	
	else:
		treeheight+=delta
		%HeightCounter.text = "Height: " + str(round_place(treeheight,2))
		%Tree.position.y -= delta*50
	pass

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

func spawn_sun() -> void:
	pass
	


