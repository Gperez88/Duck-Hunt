extends Area2D

class_name Duck 

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

# onready variables
onready var change_direction_timer: Timer = $ChangeDirectionTimer
onready var gone_timer: Timer = $GoneTimer
onready var dead_timer: Timer = $DeadAnimationTimer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var value_label: Label = $CanvasLayer/ValueLabel

# public variables
var bound
var velocity
var direction: DuckDirection
var side_show
var current_state = DuckStates.FLYING

# private variables
var _change_direction = false

# setters and getters

# override methods
func _ready():
	bound = get_viewport_rect().size
	bound.y -= ORIGIN_Y
	_start()

func _process(delta):
	_move(delta)
	
	match current_state:
		DuckStates.FLYING:
			if _out_of_bounds():
				_reverse_direction()
			elif _change_direction:
				_randomize_direction()
		DuckStates.GOAWAY:
			# TODO: notify duck go away.
			velocity = 300
			_set_direction(Vector2(0, -1)) #direction up
		DuckStates.SHOTED:
			_set_direction(Vector2(0, 1)) #direction down

# public methods

# private methods
func _start():
	change_direction_timer.start()
	gone_timer.start()

	velocity = _get_velocity()
	direction = DuckDirection.new()
	
	var x = GlobalUtils.random_number(60, 900)
	
	position =  Vector2(x, bound.y)
	
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
	direction.direction = next
	_change_direction = false
	
	if current_state == DuckStates.FLYING:
		_change_animation_direction(direction)

func _change_animation_direction(to_direction: DuckDirection):
	if to_direction.is_moving_up() && to_direction.is_moving_right():
		animated_sprite.animation = str(GameManager.DuckAnimations.UP)
		
		if animated_sprite.flip_h:
			animated_sprite.flip_h = false
		
	elif !to_direction.is_moving_up() && to_direction.is_moving_right():
		animated_sprite.animation = str(GameManager.DuckAnimations.SIDE)
		
		if animated_sprite.flip_h:
			animated_sprite.flip_h = false
		
	elif to_direction.is_moving_up() && !to_direction.is_moving_right():
		animated_sprite.animation = str(GameManager.DuckAnimations.UP)
		animated_sprite.flip_h = true
		
	elif !to_direction.is_moving_up() && !to_direction.is_moving_right():
		animated_sprite.animation = str(GameManager.DuckAnimations.SIDE)
		animated_sprite.flip_h = true

func _reverse_direction():
	var negative_random = (randi() % 10 + 1) * -1
	var positive_random = randi() % 10 + 1
	
	var next_direction = Vector2(positive_random, positive_random)
	
	if direction.is_moving_up() && direction.is_moving_right():
		next_direction = Vector2(negative_random, positive_random)
	elif !direction.is_moving_up() && direction.is_moving_right():
		next_direction = Vector2(negative_random, negative_random)
	elif direction.is_moving_up() && !direction.is_moving_right():
		next_direction = Vector2(positive_random, positive_random)
	elif !direction.is_moving_up() && !direction.is_moving_right():
		next_direction = Vector2(positive_random, negative_random)
	
	_set_direction(next_direction)


func _move(delta):
	if direction.direction.length() > 0:
		direction.direction = direction.direction.normalized() * velocity 
	
	position += direction.direction * delta
	
	if current_state == DuckStates.FLYING:
		position.x = clamp(position.x, 0, bound.x)
		position.y = clamp(position.y, 0, bound.y)

func _out_of_bounds() -> bool:
	return (position.x <= 0 || position.x >= bound.x ) || (position.y <= 0 || position.y >= bound.y)
	
func _get_velocity() -> int:
	match type:
		0:
			return 200
		1:
			return 300
		2:
			return 500
		_:
			return 200

func _get_value() -> int:
	match type:
		0:
			return 100
		1:
			return 500
		2:
			return 1000
		_:
			return 100

# connect signals
func _on_Duck_body_entered(body):
	emit_signal("shooted")

func _on_Duck_shooted():
	dead_timer.start()
	# TODO: emite signal "druck_shoted"
	current_state = DuckStates.SHOTED
	value_label.text = str(_get_value())
	value_label.set_position(position)
	value_label.show()
	animated_sprite.animation = str(GameManager.DuckAnimations.SHOTED)
	yield(dead_timer, "timeout")
	value_label.hide()
	animated_sprite.animation = str(GameManager.DuckAnimations.DEAD)

func _on_Duck_go_away():
	current_state = DuckStates.GOAWAY

func _on_VisibilityNotifier_viewport_exited(viewport):
	queue_free()

func _on_GoneTimer_timeout():
	emit_signal("go_away")

func _on_ChangeDirectionTimer_timeout():
	_change_direction = true

