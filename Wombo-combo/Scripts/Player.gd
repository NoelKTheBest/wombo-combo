extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var scene = preload("res://Player Character/Attacks/Slash Attack 1/Attack_1.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var time_left
var attack = false
var transition = false
@onready var animator = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitbox = $Hitbox
@onready var hitbox_anim = $Hitbox/AnimationPlayer
@onready var collider = $CollisionShape2D
@onready var collider_anim = $CollisionShape2D/AnimationPlayer
@onready var hurtbox_anim = $Hurtbox/AnimationPlayer
@onready var tree = $AnimationTree


func _ready() -> void:
	$AnimationTree.active = true
	hitbox.visible = false
	collider.position = Vector2(0, 5)


func _process(delta):
	if velocity.x < 0:
		sprite.flip_h = true
		hitbox.position = Vector2(25, 3)
	elif velocity.x > 0:
		sprite.flip_h = false
		hitbox.position = Vector2(-5, 3)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and !attack and !transition:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# I want to make the animator transition back to idle after hitting the attack button again
	if Input.is_action_just_pressed("attack") and !attack:# and animator.visible:
		attack = true
		#timer.start(transition_1)
	elif Input.is_action_just_pressed("attack") and attack:
		#if timer.time_left > 0:
		transition = true
	
	move_and_slide()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Hit":
		tree.active = true
	#print("transition: " + str(transition))
	attack = false
	transition = false


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name == "Idle":
		print("idle") 
	
	if sprite.flip_h:
		match anim_name:
			"Attack 1":
				#print("left attack 1")
				hitbox_anim.play("left_hitbox_1")
				collider_anim.play("lefthurt1")
				hurtbox_anim.play("collision_and_hurtbox_animations/lefthurt1")
			"Attack 2":
				#print("left attack 2")
				hitbox_anim.play("left_hitbox_2")
				collider_anim.play("lefthurt2")
				hurtbox_anim.play("collision_and_hurtbox_animations/lefthurt2")
			"Attack 3":
				#print("left attack 3")
				hitbox_anim.play("left_hitbox_3")
				collider_anim.play("lefthurt3")
				hurtbox_anim.play("collision_and_hurtbox_animations/lefthurt3")
	else:
		match anim_name:
			"Attack 1":
				#print("right attack 1")
				hitbox_anim.play("right_hitbox_1")
				collider_anim.play("righthurt1")
				hurtbox_anim.play("collision_and_hurtbox_animations/righthurt1")
			"Attack 2":
				#print("right attack 2")
				hitbox_anim.play("right_hitbox_2")
				collider_anim.play("righthurt2")
				hurtbox_anim.play("collision_and_hurtbox_animations/righthurt2")
			"Attack 3":
				#print("right attack 3")
				hitbox_anim.play("right_hitbox_3")
				collider_anim.play("righthurt3")
				hurtbox_anim.play("collision_and_hurtbox_animations/righthurt3")
	#hitbox_anim.play("right_hitbox_1")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy Hitbox") and area.visible:
		print(area.get_parent().name)
		#tree.active = false
		#animator.play("Hit")
	else:
		print("do nothing")
