extends Sprite

# signals


# export variables
export (int) var velocity
export (int) var offset_left
export (int) var offset_right
export (int, "Left", "Right") var move_to = 0


# onready variables


# public variables


# private variables


# public variables
var move = Vector2.ZERO


# override methods
func _process(delta):
	if move_to == 0:
		_set_left()
	else:
		_set_right()

	_move(delta)


# public methods


# private methods
func _set_right():
	if position.x >= offset_right:
		position.x = offset_left

	move.x += 1


func _set_left():
	if position.x <= offset_left:
		position.x = offset_right

	move.x -= 1


func _move(delta: float):
	if move.length() > 0:
		move = move.normalized() * velocity

	position += move * delta
