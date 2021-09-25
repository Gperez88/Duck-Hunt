extends Node

# signals
signal shotgun_shoot

# export variables
export (PackedScene) var EasyDuck

# onready variables
onready var shot_gun = $ShotGun
onready var hud = $Hud

# public variables

# private variables
var _level = 1
var _duck = null

# override methods
func _ready():
	GameManager.init()
	_start()

# public methods

# private methods
func _start():
	# TODOL create dog
	_create_duck()

func _create_duck():
	if !is_instance_valid(_duck):
		var duck_type = _get_duck_type()
	
		match duck_type:
			GameManager.DuckTypes.EASY, _:
				_duck = EasyDuck.instance()
	
		_duck.z_index = 1
		
		add_child(_duck)
		
		# TODO: - reset shotgun
		#		- counter duck
		#		- evaluate if crate frog

func _get_duck_type() -> String:
	match _level:
		1, 2, _:
			return GameManager.DuckTypes.EASY
#		3, 4, 5, 6:
#			return global_variable.TypeDuck.MEDIUM
#		7, 8, 9, 10:
#			return global_variable.TypeDuck.HARD
#		_:
#			return global_variable.TypeDuck.EASY

# connect signals
func _on_Wold_shotgun_shoot():
	var bullet_position = shot_gun.get_bullets()
	
	hud.hide_bullet(bullet_position)
	
	# TODO: - evaluate if have bullet
	#		- evaluate if duck flying
	
