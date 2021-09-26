extends Area2D


# signals
signal shooted
signal go_away


# loads
var DuckDirection = load("res://src/actors/duck/DuckDirection.gd")


# constants
const ORIGIN_Y = 120
enum DuckStates {FLYING, SHOTED, GOAWAY, OFFSCREEN}


# export variables
export (int, "easy", "medium", "hard") var type = 0
export (int) var value = 100
export (int) var velocity = 200


# onready variables
onready var change_direction_timer: Timer = $ChangeDirectionTimer
onready var gone_timer: Timer = $GoneTimer
onready var dead_timer: Timer = $DeadAnimationTimer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var value_label: Label = $CanvasLayer/ValueLabel

# public variables


# private variables
var _direction: DuckDirection = null
var _bound = Vector2.ZERO
var _change_direction: bool = false
var _current_state = DuckStates.FLYING setget ,get_current_state


# setters and getters
func get_current_state() -> int:
	return _current_state


# override methods
func _ready():
	_bound = get_viewport_rect().size
	_bound.y -= ORIGIN_Y
	_start()


func _process(delta):
	_move(delta)
	
	match _current_state:
		DuckStates.FLYING:
			if _out_of_bounds():
				_reverse_direction()
			elif _change_direction:
				_randomize_direction()
		DuckStates.GOAWAY:
			get_parent().emit_signal("duck_go_away")
			velocity = 300
			_set_direction(Vector2.UP)
		DuckStates.SHOTED:
			_set_direction(Vector2.DOWN)

# public methods


# private methods
func _start():
	change_direction_timer.start()
	gone_timer.start()

	_direction = DuckDirection.new()
	
	var x = GlobalUtils.random_number_range(60, 900)
	
	position =  Vector2(x, _bound.y)
	
	_init_direction()


func _init_direction():
	var next_direction = Vector2(
		randi() % 21 - 10, 
		(randi() % 10 + 1) * -1
	).normalized() * 50
	
	_set_direction(next_direction)


func _randomize_direction():
	var next_direction = Vector2(
		randi()%21 - 10, 
		randi()%21 - 10
	).normalized() * 50
	
	_set_direction(next_direction)


func _set_direction(next: Vector2):
	_direction.direction = next
	_change_direction = false
	
	if _current_state == DuckStates.FLYING:
		_change_animation_direction(_direction)


func _change_animation_direction(to_direction: DuckDirection):
	if to_direction.is_moving_up() && to_direction.is_moving_right():
		animated_sprite.animation = GameManager.DuckAnimations.UP
		
		if animated_sprite.flip_h:
			animated_sprite.flip_h = false
		
	elif !to_direction.is_moving_up() && to_direction.is_moving_right():
		animated_sprite.animation = GameManager.DuckAnimations.SIDE
		
		if animated_sprite.flip_h:
			animated_sprite.flip_h = false
		
	elif to_direction.is_moving_up() && !to_direction.is_moving_right():
		animated_sprite.animation = GameManager.DuckAnimations.UP
		animated_sprite.flip_h = true
		
	elif !to_direction.is_moving_up() && !to_direction.is_moving_right():
		animated_sprite.animation = GameManager.DuckAnimations.SIDE
		animated_sprite.flip_h = true


func _reverse_direction():
	var positive_random = GlobalUtils.random_number()
	var negative_random = GlobalUtils.random_number() * -1
	
	var next_direction = Vector2(positive_random, positive_random)
	
	if _direction.is_moving_up() && _direction.is_moving_right():
		next_direction = Vector2(negative_random, positive_random)
	elif !_direction.is_moving_up() && _direction.is_moving_right():
		next_direction = Vector2(negative_random, negative_random)
	elif _direction.is_moving_up() && !_direction.is_moving_right():
		next_direction = Vector2(positive_random, positive_random)
	elif !_direction.is_moving_up() && !_direction.is_moving_right():
		next_direction = Vector2(positive_random, negative_random)
	
	_set_direction(next_direction)


func _move(delta):
	if _direction.direction.length() > 0:
		_direction.direction = _direction.direction.normalized() * velocity 
	
	position += _direction.direction * delta
	
	if _current_state == DuckStates.FLYING:
		position.x = clamp(position.x, 0, _bound.x)
		position.y = clamp(position.y, 0, _bound.y)


func _out_of_bounds() -> bool:
	return (position.x <= 0 || position.x >= _bound.x ) || (position.y <= 0 || position.y >= _bound.y)


# connect signals
func _on_Duck_body_entered(_body):
	emit_signal("shooted")


func _on_Duck_shooted():
	dead_timer.start()

	get_parent().emit_signal("duck_dead", value)
	
	_current_state = DuckStates.SHOTED
	
	value_label.text = str(value)
	value_label.set_position(position)
	value_label.show()
	
	animated_sprite.animation = str(GameManager.DuckAnimations.SHOTED)
	
	yield(dead_timer, "timeout")
	
	value_label.hide()
	
	animated_sprite.animation = str(GameManager.DuckAnimations.DEAD)


func _on_Duck_go_away():
	_current_state = DuckStates.GOAWAY


func _on_VisibilityNotifier_viewport_exited(_viewport):
	queue_free()


func _on_GoneTimer_timeout():
	emit_signal("go_away")


func _on_ChangeDirectionTimer_timeout():
	_change_direction = true
