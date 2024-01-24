extends Area2D


var scene = preload("res://Player Character/Attacks/Slash Attack 2/Attack_2.tscn")

@onready var animator = $AnimatedSprite2D
@onready var timer = $Timer


func _ready():
	animator.play("default")


func _process(delta):
	if Input.is_action_just_pressed("attack") and animator.visible and timer.is_stopped():
		var attack = scene.instantiate()
		add_child(attack)
		animator.visible = false
		attack.tree_exited.connect(_on_animation_stopped)
		attack.get_node("AnimatedSprite2D").flip_h = animator.flip_h
		if animator.flip_h: attack.position.x = 0 - attack.position.x


# Problem 1: The child exits before their animation has finished. Every child animation needs to 
#	finish before the parent is finished.
func _on_animated_sprite_2d_animation_finished():
	if animator.visible: queue_free()


func _on_animation_stopped():
	animator.visible = true
	queue_free()
