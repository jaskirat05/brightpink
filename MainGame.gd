extends Node2D

var height: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$HeightCounter/Timer.start()
	$Button.text = ("amogus")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(height)
	#print($"HeightCounter".text)


func _on_timer_timeout():
	print("peen") # Replace with function body.
	height += 1
	$HeightCounter.text = "Height: " + str(height)

