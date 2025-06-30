extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const transition_1 = 0.65
const transition_2 = 0.4


var scene = preload("res://Player Character/Attacks/Slash Attack 1/Attack_1.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var animation = "Idle"
var time_left
var attack = false
var transition = false
@onready var animator = $AnimatedSprite2D
@onready var sprite = $Sprite2D
@onready var timer = $Timer

func _process(delta):
	#if !animator.is_playing():
	#	animator.play(animation)
	
	# I want to make the animator transition back to idle after hitting the attack button again
	if Input.is_action_just_pressed("attack") and !attack:# and animator.visible:
		attack = true
		timer.start(transition_1)
	elif Input.is_action_just_pressed("attack") and attack:
		if timer.time_left > 0:
			transition = true
			print("Transition")
	#	timer.start(transition_1)
	#	attack_count = 1
	#	print("one")
	#elif Input.is_action_just_pressed("attack"):# and attack_count == 1:# and time_left > 0:
	#	timer.start(transition_2)
	#	attack_count = 2
	#	print("two")
	#elif Input.is_action_just_pressed("attack") and attack_count == 2 and time_left > 0:
	#	timer.start(0.4)
	#	attack_count = 3
		
		#var attack = scene.instantiate()
		#add_child(attack)
		#animator.visible = false
		#attack.tree_exited.connect(_on_animation_stopped)
		#attack.get_node("AnimatedSprite2D").flip_h = animator.flip_h
		#if animator.flip_h: attack.position.x = 0 - attack.position.x
	
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	#if velocity.x != 0 and animation != "Jump" and animation != "Fall":
	#	animator.play("Run")
	#elif velocity.x == 0 and animation != "Jump" and animation != "Fall":
	#	animator.play("Idle")
	
	#if velocity.y > 0 && animation != "Fall":
	#	animator.play("Fall")
	
	#animation = animator.animation
	time_left = timer.time_left
	#print(time_left)
	#print("count: " + str(attack_count))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	#else:
	#	animation = "Idle"
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#animator.play("Jump")
		#animation = animator.animation
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func _on_animation_stopped():
	animator.visible = true


func _on_timer_timeout() -> void:
	#if !attack: transition = false
	print(transition)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	attack = false
	transition = false
