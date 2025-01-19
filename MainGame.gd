extends Node2D

var treeheight: float = 0 
var treeheightstart: float = 0
var screenheight: float = 0
var BlackFadeAlpha: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	treeheightstart = %FarBackgroundUnfinished.texture.get_height()
	$BlackFadeBox/BlackFadeAnimationPlayer.play("fade_to_normal")
	get_window().position.y = 20 #because the stupid window bar always starts off screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	treeheight+=delta
	%HeightCounter.text = "Height: " + str(round_place(treeheight,2))
	%FarBackgroundUnfinished.position.y += delta*50
	pass

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))




