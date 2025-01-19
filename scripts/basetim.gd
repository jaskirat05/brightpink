extends PathFollow2D

signal path_completed
signal clicked

@onready var sprite = $AnimatedSprite2D
var speed: float = 150
var damage: int = 10
var is_adult: bool = false
var reached_end: bool = false

func _ready():
	set_rotates(false)
	set_loop(false)
	if sprite:
		sprite.play("default")
		sprite.flip_v=true
	
	var area = $Area2D
	if area:
		area.input_event.connect(_on_input_event)

func _process(delta):
	if not reached_end:
		progress_ratio += (speed * delta) / get_parent().curve.get_baked_length()
		
		if progress_ratio >= 1.0:
			reached_end = true
			emit_signal("path_completed")
			if not is_adult:  # Only remove if not adult
				queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("clicked")
