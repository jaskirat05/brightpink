extends PathFollow2D

signal path_completed
signal clicked

@onready var sprite = $AnimatedSprite2D
var speed: float = 150
var damage: int = 10
var is_adult: bool = false  # Set this to true for adult Timmy in the scene
var reached_end: bool = false

func _ready():
    set_rotates(false)  # Don't rotate with path
    set_loop(false)    # Don't loop the path
    
    if sprite:
        sprite.play("default")
    
    var area = $Area2D
    if area:
        area.input_event.connect(_on_input_event)

func _process(delta):
    if not reached_end:
        # Move along the path
        progress_ratio += (speed * delta) / get_parent().curve.get_baked_length()
        
        # Check if reached the end
        if progress_ratio >= 1.0:
            reached_end = true
            emit_signal("path_completed")
            if not is_adult:  # Only queue_free if not adult Timmy
                queue_free()

func _on_input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        emit_signal("clicked")
