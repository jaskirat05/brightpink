extends Sprite2D

@onready var termite_scene = preload("res://scenes/termite.tscn")
@onready var bird_scene = preload("res://scenes/bird.tscn")

# Variable to track tree's health
var health: int = 100
var spawn_timer: Timer
var termite_paths: Array[Node] = []
var bird_paths: Array[Node] = []

# Difficulty scaling variables
var current_height: float = 0
var base_spawn_time: float = 2.0
var min_spawn_time: float = 0.5
var base_enemy_speed: float = 100
var speed_multiplier: float = 1.0

func _ready():
	# Get all Path2D nodes and categorize them
	for child in get_children():
		if child is Path2D:
			if "termite" in child.name.to_lower():
				termite_paths.append(child)
			elif "bird" in child.name.to_lower():
				print("Adding bird path")
				bird_paths.append(child)
	
	print("Found ", termite_paths.size(), " termite paths")
	print("Found ", bird_paths.size(), " bird paths")
	
	# Create and start the spawn timer
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	_start_new_timer()
	print("Timer started")

func update_difficulty(height: float):
	current_height = height
	# Increase speed multiplier based on height (adjust values as needed)
	speed_multiplier = 1.0 + (height / 100.0)  # Increase speed by 1% every 1 unit of height
	speed_multiplier = min(speed_multiplier, 3.0)  # Cap at 3x speed
	
	print("Height: ", height, " Speed multiplier: ", speed_multiplier)

func _start_new_timer():
	# Reduce spawn time based on height (adjust values as needed)
	var spawn_time = base_spawn_time - (current_height / 200.0)  # Reduce time by 0.005s per unit of height
	spawn_time = max(spawn_time, min_spawn_time)  # Don't go below minimum spawn time
	spawn_timer.start(spawn_time)
	print("Next spawn in ", spawn_time, " seconds")

func _on_spawn_timer_timeout():
	# Increase bird spawn chance with height
	var bird_chance = min(0.5 + (current_height / 500.0), 0.7)  # Max 70% chance for birds
	if randf() < bird_chance:
		spawn_bird()
	else:
		spawn_termite()
	_start_new_timer()

func spawn_termite():
	if termite_paths.is_empty() or not termite_scene:
		return
		
	var random_path = termite_paths[randi() % termite_paths.size()]
	print("Spawning termite on path ", random_path.name)
	
	var termite = termite_scene.instantiate()
	termite.speed = base_enemy_speed * speed_multiplier  # Apply speed multiplier
	termite.progress = 0
	random_path.add_child(termite)
	print("Termite spawned with speed: ", termite.speed)

func spawn_bird():
	if bird_paths.is_empty() or not bird_scene:
		return
		
	var random_path = bird_paths[randi() % bird_paths.size()]
	print("Spawning bird on path ", random_path.name)
	
	var bird = bird_scene.instantiate()
	bird.speed = (base_enemy_speed * 1.5) * speed_multiplier  # Birds are 50% faster than termites
	bird.progress = 0
	bird.rotates = false
	
	var sprite = bird.get_node("AnimatedSprite2D")
	if sprite:
		if "right" in random_path.name.to_lower():
			sprite.flip_h = false
			sprite.rotation_degrees = 90
		else:
			sprite.flip_h = true
			sprite.rotation_degrees = 90
	
	random_path.add_child(bird)
	print("Bird spawned with speed: ", bird.speed)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(0, health)
	print("Tree took damage! Health: ", health)
	
	modulate = Color(1, float(health)/100, float(health)/100, 1)
	
	if health <= 0:
		print("Tree has been destroyed!")
		get_tree().reload_current_scene()
