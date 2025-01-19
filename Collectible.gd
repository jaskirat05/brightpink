extends Area2D
class_name Collectible

@export var CollectibleType: String 
@export var value: float = 1.0

func _ready(): 
	input_pickable = true

