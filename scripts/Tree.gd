extends Sprite2D

@onready var termite_scene = preload("res://scenes/termite.tscn")
@onready var bird_scene = preload("res://scenes/bird.tscn")
@onready var young_timmy_scene = preload("res://scenes/tim_kid.tscn")
@onready var teen_timmy_scene = preload("res://scenes/teen_tim.tscn")
@onready var adult_timmy_scene = preload("res://scenes/adult_timmy.tscn")

# Variable to track tree's health
var health: int = 100
var treeHeight:float=0.00
@onready var parentGame=get_parent()
var spawn_timer: Timer
var termite_paths: Array[Node] = []
var bird_paths: Array[Node] = []
var tim_paths:Array[Node]=[]
var is_adult_timmy_active: bool = false
var is_any_timmy_active: bool = false
var camera_root_position: float = 100  # Position for viewing roots
var young_timy_done:bool=false
var teen_timy_done:bool=false
var adult_timmy_at_end: bool = false  # New variable to track if adult Timmy reached end

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
			elif "tim" in child.name.to_lower():
				tim_paths.append(child)
	
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
	if not is_any_timmy_active:
		# Only spawn enemies if no Timmy is active
		var bird_chance = min(0.5 + (current_height / 500.0), 0.7)  # Max 70% chance for birds
		if randf() < bird_chance:
			spawn_bird()
		else:
			spawn_termite()
	_start_new_timer()

func remove_all_enemies():
	# Remove all termites
	var termites = get_tree().get_nodes_in_group("termite")
	for termite in termites:
		termite.queue_free()
	
	# Remove all birds
	var birds = get_tree().get_nodes_in_group("bird")
	for bird in birds:
		bird.queue_free()

func is_any_tim_active():
	return get_tree().get_nodes_in_group("timmy").size() > 0 or is_adult_timmy_active

func spawn_termite():
	if termite_paths.is_empty() or not termite_scene:
		return
		
	var random_path = termite_paths[randi() % termite_paths.size()]
	print("Spawning termite on path ", random_path.name)
	
	var termite = termite_scene.instantiate()
	termite.speed = base_enemy_speed * speed_multiplier  # Apply speed multiplier
	termite.progress = 0
	termite.add_to_group("termite")
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
	bird.add_to_group("bird")
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
	if not is_adult_timmy_active:  # Only take normal damage if adult Timmy isn't active
		health -= amount
	else:
		# If adult Timmy is active, always take damage
		health -= amount
	
	# Check health thresholds for Timmy spawns
	if health <= 80 and health > 60 and not has_active_timmy():
		spawn_young_timmy()
	elif health <= 60 and health > 50 and not has_active_timmy():
		spawn_teen_timmy()
	elif health <= 50 and not is_adult_timmy_active:
		spawn_adult_timmy()
	
	health = clamp(health, 0, 100)
	modulate = Color(1, float(health)/100, float(health)/100, 1)
	
	# Check if health reached zero
	if health <= 0:
		# Make sure we're at exactly 0
		health = 0
		restart_game()

func _process(delta):	
	treeHeight=parentGame.treeHeight()
	if treeHeight>100.0 and not is_adult_timmy_active:  # Only spawn if not already active
		spawn_adult_timmy()
	
	# Handle adult Timmy's damage only when at end of path
	if is_adult_timmy_active and adult_timmy_at_end and health > 0:
		health = max(0, health - delta * 2)  # Slower damage rate
		modulate = Color(1, float(health)/100, float(health)/100, 1)

func has_active_timmy() -> bool:
	return get_tree().get_nodes_in_group("timmy").size() > 0 or is_adult_timmy_active

func spawn_young_timmy():
	if young_timmy_scene and not tim_paths.is_empty() and not young_timy_done:
		var random_path =tim_paths[randi() % tim_paths.size()]
		var timmy = young_timmy_scene.instantiate()
			
		timmy.add_to_group("timmy")
		timmy.connect("path_completed", _on_young_timmy_completed)
		random_path.add_child(timmy)
		is_any_timmy_active = true
		remove_all_enemies()

func spawn_teen_timmy():
	if teen_timmy_scene and not tim_paths.is_empty() and not teen_timy_done:
		var random_path = tim_paths[randi() % tim_paths.size()]
		var timmy = teen_timmy_scene.instantiate()
		timmy.add_to_group("timmy")
		timmy.connect("path_completed", _on_teen_timmy_completed)
		random_path.add_child(timmy)
		is_any_timmy_active = true
		remove_all_enemies()

func spawn_adult_timmy():
	if adult_timmy_scene and not tim_paths.is_empty():
		var random_path = tim_paths[randi() %tim_paths.size()]
		var timmy = adult_timmy_scene.instantiate()
		timmy.is_adult = true  # Set the flag here
		timmy.add_to_group("timmy")
		is_adult_timmy_active = true
		is_any_timmy_active = true
		timmy.connect("clicked", _on_adult_timmy_clicked)
		timmy.connect("path_completed", _on_adult_timmy_reached_end)
		random_path.add_child(timmy)
		remove_all_enemies()

func _on_young_timmy_completed():
	is_any_timmy_active = false
	health = 100  # Restore health to full when young timmy reaches end
	young_timy_done=true

func _on_teen_timmy_completed():
	is_any_timmy_active = false
	health = max(health + 20, 100)  
	teen_timy_done=true# Restore some health when teen timmy reaches end

func _on_adult_timmy_clicked():
	health += 1  # Gain 1 HP when clicking adult Timmy

func _on_adult_timmy_reached_end():
	adult_timmy_at_end = true  # Set flag when Timmy reaches end

func restart_game():
	# Reset all flags first
	is_adult_timmy_active = false
	adult_timmy_at_end = false
	is_any_timmy_active = false
	young_timy_done = false
	teen_timy_done = false
	
	# Remove all enemies and Timmys
	remove_all_enemies()
	var timmys = get_tree().get_nodes_in_group("timmy")
	for timmy in timmys:
		if is_instance_valid(timmy):
			timmy.queue_free()
	
	# Get the current scene file path
	var current_scene = get_tree().current_scene.scene_file_path
	
	# Change scene with a small delay to ensure cleanup
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(current_scene)
