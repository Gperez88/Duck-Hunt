extends RigidBody2D

class_name ShotGun 

# signals

# export variables

# onready variables
onready var _shoot_timer: Timer = $Timer
onready var _bullet_collision: CollisionShape2D = $CollisionShape 
onready var _shot_fash: ColorRect = $CanvasLayer/FlashColorRect

# public variables

# private variables
var _shooting_up = false setget ,is_shoting_up
var _bullets = 3 setget ,get_bullets # TODO: get count from GameManager

# setters and getters
func is_shoting_up() -> bool:
	return _shooting_up

func get_bullets() -> int:
	return _bullets

# override methods
func _unhandled_input(event):
	var started_game = true # TODO: evaluate if game is started on GameManager.
	
	if !started_game || _bullets == 0:
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			shoot(event.position)

# public methods
func shoot(position: Vector2):
	_bullets -= 1
	_shooting_up = true

	get_parent().emit_signal("shotgun_shoot")
	
	_shoot_timer.start()
	
	_bullet_collision.show()
	_bullet_collision.disabled = false
	_bullet_collision.position = position
	
	_shot_fash.show()
	# TODO: play sound fx.
	
# private methods

# connect signals
func _on_ShotTimer_timeout():
	_shooting_up = false
	
	_bullet_collision.hide()
	_bullet_collision.disabled = true
	
	_shot_fash.hide()
