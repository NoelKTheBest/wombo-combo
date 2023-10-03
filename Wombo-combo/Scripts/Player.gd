extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animated_sprite_2d_animation_changed():
	pass # Replace with function body.


func _on_animated_sprite_2d_sprite_frames_changed():
	pass # Replace with function body.


func _on_animated_sprite_2d_frame_changed():
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished(extra_arg_0):
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
