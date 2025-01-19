extends "res://scripts/basetim.gd"

var damage_timer: float = 0
var damage_interval: float = 0.5  # Deal damage every 0.5 seconds

func _ready():
	super._ready()
	speed = 100  # Slowest speed
	is_adult = true  # Set this flag in _ready

func _process(delta):
	super._process(delta)
	
	# Only damage tree when reached end of path
	if reached_end:
		# Find the tree and damage it
		var tree = get_parent().get_parent()
		if tree:
			if tree.health > 0:
				damage_timer += delta
				if damage_timer >= damage_interval:
					damage_timer = 0
					tree.take_damage(damage)
			elif tree.health <= 0:
				queue_free()  # Remove adult Timmy when tree dies

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("clicked")
