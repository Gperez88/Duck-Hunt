class_name DuckDirection 

# variables
var direction = Vector2.ZERO

# override methods
func _init():
	direction = Vector2()

# public methods
func is_moving_right() -> bool:
	return direction.x > 0

func is_moving_up() -> bool:
	return direction.y < 0
