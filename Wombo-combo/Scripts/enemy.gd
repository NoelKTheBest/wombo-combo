extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

var current_anim = "idle"
var player_position
@onready var animator = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var hitbox = $Area2D/CollisionShape2D


func _ready() -> void:
	animator.play(current_anim)


func _process(delta: float) -> void:
	if velocity.x < 0: 
		animator.flip_h = true
		collider.position = Vector2(16, 0)
		hitbox.position = Vector2(16, 1.5)
	elif velocity.x > 0: 
		animator.flip_h = false
		collider.position = Vector2(0, 0)
		hitbox.position = Vector2(0, 1.5)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction
	var target_position = (player_position - position).normalized()
	
	if position.distance_to(player_position) > 35:
		if visible: 
			velocity.x = target_position.x * SPEED
			animator.play("run")
		move_and_slide()
	
	#print(position.distance_to(player_position))


func find_player(player_pos: Vector2) -> void:
	player_position = player_pos


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.visible:
		animator.play("hurt")
	print(area.name + ": " + str(area.visible))


func _on_animated_sprite_2d_animation_finished() -> void:
	animator.play("idle")
