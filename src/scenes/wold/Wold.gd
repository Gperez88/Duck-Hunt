extends Node

# signals

# warning-ignore:unused_signal
signal shotgun_shoot

# warning-ignore:unused_signal
signal duck_go_away

# warning-ignore:unused_signal
signal duck_dead(value)


# export variables
export (PackedScene) var EasyDuck
export (PackedScene) var MediumDuck
export (PackedScene) var HardDuck


# onready variables
onready var shot_gun = $ShotGun
onready var hud = $Hud


# public variables


# private variables
var _level = 1
var _duck = null


# override methods
func _ready():
	GameManager.init() # TODO: move to main scene
	_start()

# public methods


# private methods
func _start():
	# TODO: create dog
	_create_duck()


func _create_duck():
	if is_instance_valid(_duck) == false:
		var duck_type = _get_duck_type()
	
		match duck_type:
			GameManager.DuckTypes.EASY:
				_duck = EasyDuck.instance()
			GameManager.DuckTypes.MEDIUM:
				_duck = MediumDuck.instance()
			GameManager.DuckTypes.HARD:
				_duck = HardDuck.instance()
			_:
				_duck = EasyDuck.instance()
	
		_duck.z_index = 1
		
		add_child(_duck)
		
		# TODO: - reset shotgun
		#		- counter duck
		#		- evaluate if crate frog


func _get_duck_type() -> String:
	match _level:
		1, 2:
			return GameManager.DuckTypes.EASY
		3, 4, 5, 6:
			return GameManager.DuckTypes.MEDIUM
		7, 8, 9, 10:
			return GameManager.DuckTypes.HARD
		_:
			return GameManager.DuckTypes.EASY


# connect signals
func _on_Wold_shotgun_shoot():
	var bullet_position = shot_gun.get_bullets()
	
	hud.hide_bullet(bullet_position)
	
	# TODO: - evaluate if have bullet
	#		- evaluate if duck flying


func _on_Wold_duck_go_away():
	hud.show_info_dialog("Fly Away")


func _on_Wold_duck_dead(value):
	hud.set_score(value)
