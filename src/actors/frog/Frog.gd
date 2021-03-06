extends Area2D

# signals
signal shooted


# export variables
export (float) var velocity = 500
export (int) var value = 1500


# onready variables
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var hit_timer: Timer = $HitTimer
onready var value_label: Label = $CanvasLayer/ValueLabel

# public variables


# private variables
const _side = ["left", "right"]

var _move_value = Vector2.ZERO
var _side_to_show = null
var _dead = false setget , is_dead


# setters and getters
func is_dead() -> bool:
	return _dead

# override methods
func _ready():
	_side_to_show = GlobalUtils.choose(_side)
	
	position.x = get_viewport_rect().size.x if _side_to_show == _side[0] else 0.0
	position.y = GlobalUtils.random_number_range(60, 300)
	
	animated_sprite.animation = "fly"
	animated_sprite.flip_h = false if _side_to_show == _side[0] else true


func _process(delta):
	if _side_to_show == _side[0]:
		_set_left()
	else:
		_set_right()
	
	_move(delta)


# public methods
func increase_velocity(multiplier: float):
	velocity += velocity * multiplier


# private methods
func _set_left():
	_move_value.x -= 1


func _set_right():
	_move_value.x += 1


func _move(delta: float):
	if _move_value.length() > 0:
		_move_value = _move_value.normalized() * velocity

	position += _move_value * delta


func _remove():
	queue_free()


# connect signals
func _on_VisibilityNotifier_viewport_exited(_viewport):
	_remove()


func _on_Frog_shooted():
	hit_timer.start()
	velocity = 100

	get_parent().emit_signal("frog_dead", value)
	
	value_label.text = str(value)
	value_label.set_position(position)
	value_label.show()
	
	animated_sprite.animation = "shooted"
	
	yield(hit_timer, "timeout")
	
	value_label.hide()
	
	_remove()


func _on_Frog_body_entered(_body):
	emit_signal("shooted")
