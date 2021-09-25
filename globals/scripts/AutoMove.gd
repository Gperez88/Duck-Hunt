extends Sprite

export (int) var velocity
export (int) var offset_left
export (int) var offset_right
export (int, "Left", "Right") var move_to = 0

var move = Vector2()

func _process(delta):
	if move_to == 0:
		if position.x <= offset_left:
			position.x = offset_right
	
		move.x -= 1
	else:
		if position.x >= offset_right:
			position.x = offset_left
	
		move.x += 1

	if move.length() > 0:
		move = move.normalized() * velocity

	position += move * delta
