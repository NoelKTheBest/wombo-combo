extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var scene = preload("res://Player Character/Attacks/Slash Attack 1/Attack_1.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var time_left
var attack = false
var transition = false
@onready var animator = $AnimatedSprite2D
@onready var sprite = $Sprite2D
@onready var hitbox = $Area2D
@onready var hurtbox = $CollisionShape2D
var righthitbox = Vector2(25, 3)
var lefthitbox

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
	#print(anim_name)
	#print("transition: " + str(transition))
	attack = false
	transition = false
