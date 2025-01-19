extends PathFollow2D

# Exported variables to control speed and damage
var speed: float = 100       # Speed of the termite's movement	
var damage_to_tree: int = 10  # Damage dealt to the tree when termite reaches the top
var reached_top = false      # Has the termite reached the top of the tree?
@onready var sprite = $AnimatedSprite2D  # Reference to the animated sprite

func _ready():
	# Initialize path following properties
	set_rotates(true)  # Make termite rotate with the path
	set_loop(false)    # Don't loop the path
	
	# Start at random position on path
	randomize()
	progress_ratio = randf()  # Random position between 0 and 1
	
	# Start the animation
	if sprite:
		sprite.play("default")
	
	# Set up input handling
	var area = $Area2D
	if area:
		area.input_event.connect(_on_input_event)

func _process(delta):
	if not reached_top:
		# Move along the path
		progress_ratio += (speed * delta) / get_parent().curve.get_baked_length()
		
		# Check if reached the end
		if progress_ratio >= 1.0:
			reached_top = true
			hurt_tree()

func hurt_tree():
	# Find the Tree node (going up through TreeControl)
	var tree = get_parent().get_parent()  # From TERMITE to Path2D to Tree
	if tree:
		tree.take_damage(damage_to_tree)
		queue_free()  # Remove the termite after damage

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		queue_free()  # Kill the termite when clicked
