extends PathFollow2D

var speed: float = 150  # Birds move faster than termites
var damage_to_tree: int = 15
var reached_end = false
@onready var sprite = $AnimatedSprite2D

func _ready():
	set_rotates(false)  # Don't rotate with path
	set_loop(false)
	
	if sprite:
		sprite.play("default")
	
	# Set up input handling
	var area = $Area2D
	if area:
		area.input_event.connect(_on_input_event)

func _process(delta):
	if not reached_end:
		progress_ratio += (speed * delta) / get_parent().curve.get_baked_length()
		
		if progress_ratio >= 1.0:
			reached_end = true
			hurt_tree()

func hurt_tree():
	var tree = get_parent().get_parent()
	if tree:
		tree.take_damage(damage_to_tree)
		queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		$AudioStreamPlayer.play()
		
		queue_free()  # Kill the bird when clicked
