extends CharacterBody2D

var speed = 300.0
var life = 100.0
var damage = 1
var atk_speed = 1
var movespeed = 1
var experience = 0
var level = 1

var current_life: float = life
var is_alive: bool = true  

signal player_died  

@onready var attraction_area: Area2D = $AttractionArea

func _ready():
	attraction_area.body_entered.connect(_on_AttractionArea_body_entered)

func _physics_process(delta: float) -> void:
	if is_alive:  
		var directionx := Input.get_axis("ui_left", "ui_right")
		var directiony := Input.get_axis("ui_up", "ui_down")
		if directionx:
			velocity.x = directionx * speed * movespeed
		else:
			velocity.x = move_toward(velocity.x, 0, speed * movespeed)
		if directiony:
			velocity.y = directiony * speed * movespeed
		else:
			velocity.y = move_toward(velocity.y, 0, speed * movespeed)
	
		move_and_slide()
		if Input.is_action_just_pressed("kill_enemies"):
			kill_all_enemies()

func kill_all_enemies():
	var enemies = get_tree().get_nodes_in_group("NPC")
	for enemy in enemies:
		if enemy.has_method("die"):
			enemy.die()
			
func take_damage(amount: float):
	current_life -= amount
	print(current_life)
	if current_life <= 0:
		die() 

func die():
	is_alive = false 
	emit_signal("player_died") 
	queue_free()  

func _on_AttractionArea_body_entered(body):
	print("Detect body entered:", body.name)  
	if body.is_in_group("Item"):
		print("DetectG")
		body.set_target(self)

func gain_experience(amount):
	experience += amount
	print("Gained experience:", amount)
	print("Total experience:", experience)