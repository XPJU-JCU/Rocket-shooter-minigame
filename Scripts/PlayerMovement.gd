extends CharacterBody2D

@export var speed = 850
@export var rotation_speed = 7 
var rotation_direction = 0

@export var hp : int = Global.hp:
	set(newhp):
		hp = newhp
		if(hp == 0):
			get_tree().reload_current_scene()	
			hp+=1
			Global.score = 0

@onready var projectile = preload("res://Bullet.tscn")
@export var spawnpoint : Sprite2D

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):	
	rotation += rotation_direction * rotation_speed * delta
	get_input()
	move_and_slide()
	
func shoot():
	var instance = projectile.instantiate()
	instance.dir = spawnpoint.global_rotation 
	instance.spawnPos = spawnpoint.global_position
	instance.spawnRot = rotation
	get_tree().current_scene.add_child(instance)	

func checkEntry(body : Node2D):
	for i in body.get_groups():
		if (i == "Enemies"):
			hp-=1
			Global.hp -= 1
		if (i == "Shield_collectible"):
			hp+=1
			Global.hp += 1
			body.queue_free()

func _on_area_2d_body_entered(body: Node2D):
	checkEntry(body)
			
func _on_area_2d_area_entered(area: Area2D):
	checkEntry(area)
