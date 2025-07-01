extends CharacterBody2D


const SPEED = 50
const JUMP_VELOCITY = -400.0

var current_anim = "idle"
var player_position
@onready var animator = $AnimatedSprite2D


func _ready() -> void:
	animator.play(current_anim)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction
	var target_position = (player_position - position).normalized()
	
	if position.distance_to(player_position) > 35:
		if visible: velocity.x = target_position.x * SPEED
		move_and_slide()
	
	print(position.distance_to(player_position))


func find_player(player_pos: Vector2) -> void:
	player_position = player_pos
