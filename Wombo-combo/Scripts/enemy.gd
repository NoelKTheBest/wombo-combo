extends CharacterBody2D

@export var dash_distance = 70
var attack_distance = 30

const JUMP_VELOCITY = -400.0

var speed = 100
var current_anim = "idle"
var current_state = "idle"
var player_position : Vector2
var attack_count = 0
var close_to_player = false
var close_for_dash = false
var attacking = false
var was_hit = false
var player_is_dead = false
var frame = 0
var dash_frame = 0

@onready var animator = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var hurtbox = $Hurtbox/CollisionShape2D


func _ready() -> void:
	animator.play(current_anim)
	close_to_player = false
	hitbox.visible = false


func _process(delta: float) -> void:
	if velocity.x < 0: 
		animator.flip_h = true
		collider.position = Vector2(16, 0)
		if !attacking: hitbox.position = Vector2(16, 1.5)
		hurtbox.position = Vector2(16, 1.5)
		attack_distance = 20
	elif velocity.x > 0: 
		animator.flip_h = false
		collider.position = Vector2(0, 0)
		if !attacking: hitbox.position = Vector2(0, 1.5)
		hurtbox.position = Vector2(0, 1.5)
		attack_distance = 30
	
	if close_to_player:
		if attack_count < 3:
			if !attacking and !was_hit:
				current_state = "attacking"
				animator.play("attack")
				attacking = true
				attack_count += 1
				hitbox.position = Vector2(-10, 1.5) if animator.flip_h == true else Vector2(28, 1.5)
				#hitbox.visible = true
		elif attack_count == 3:
			if !attacking and !was_hit:
				current_state = "dash attack"
				animator.play("dash_attack")
				attacking = true
				attack_count = 0
				hitbox.position = Vector2(-15, 1.5) if animator.flip_h == true else Vector2(33, 1.5)
				#hitbox.visible = true
	elif close_for_dash:
		if attack_count < 3 and !attacking:
			current_state = "run"
		elif attack_count == 3:
			if !attacking and !was_hit:
				current_state = "dash attack"
				animator.play("dash_attack")
				attacking = true
				attack_count = 0
				hitbox.position = Vector2(-15, 1.5) if animator.flip_h == true else Vector2(33, 1.5)
				#hitbox.visible = true
	elif !close_for_dash and !attacking:
		current_state = "run"
	elif player_is_dead:
		current_state = "idle"
	
	if current_state == "run" and !attacking and !was_hit:
		animator.play("run")
	
	if was_hit:
		speed = 0
	else:
		speed = 100
	
	$Label.text = current_state


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction
	var target_position = (player_position - position).normalized()
	var distance_to = position.distance_to(player_position)
	
	if distance_to > attack_distance:
		if current_state == "run": 
			velocity.x = target_position.x * speed
			move_and_slide()
		close_to_player = false
	elif distance_to < attack_distance:
		close_to_player = true
	
	if distance_to < attack_distance:
		close_for_dash = true
	elif distance_to < dash_distance and distance_to > attack_distance:
		close_for_dash = true
	elif distance_to > dash_distance:
		close_for_dash = false
	
	if close_for_dash and current_state == "dash attack":
		speed = 200
		velocity.x = target_position.x * speed
		move_and_slide()
	
	#print(position.distance_to(player_position))


func find_player(player_pos: Vector2) -> void:
	player_position = player_pos


func _on_animated_sprite_2d_animation_finished() -> void:
	animator.play("idle")
	attacking = false
	speed = 100
	was_hit = false
	hitbox.visible = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	#if area.visible and area.name == "Hitbox":
	#	animator.play("hurt")
	#	was_hit = true
	if area.is_in_group("Player Hitbox") and area.visible:
		animator.play("hurt")
		was_hit = true
	#print(area.name + ": " + str(area.visible))


func _on_animated_sprite_2d_frame_changed() -> void:
	if current_state != "attacking": frame = 0
	if current_state != "dash attack": dash_frame = 0
	
	if current_state == "attacking": 
		frame += 1
		print(frame)
	
	if current_state == "dash attack":
		dash_frame += 1
		print(dash_frame)
	
	if frame == 5:
		hitbox.visible = true
	
	if frame == 11:
		frame = 0
		hitbox.visible = false
	
	if dash_frame == 5:
		hitbox.visible = true
	
	if dash_frame == 11:
		dash_frame = 0
		hitbox.visible = false
