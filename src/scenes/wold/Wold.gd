extends Node

# signals

# warning-ignore:unused_signal
signal shotgun_shoot

# warning-ignore:unused_signal
signal duck_go_away

# warning-ignore:unused_signal
signal duck_dead(value)

# warning-ignore:unused_signal
signal frog_dead(value)


# export variables
export (PackedScene) var EasyDuck
export (PackedScene) var MediumDuck
export (PackedScene) var HardDuck
export (PackedScene) var Frog

# onready variables
onready var shotgun = $ShotGun
onready var hud = $Hud
onready var remove_dog_timer: Timer = $RemoveDogTimer
onready var create_duck_timer: Timer = $CreateDuckTimer
onready var round_hide_timer: Timer = $RoundHideTimer
onready var wait_timer: Timer = $WaitTimer


# public variables


# private variables
var _level = 1
var _frog = null
var _duck = null
var _create_frog_timer = 0
var _duck_shown_counter = 0
var _duck_dead_counter = 0
var _create_frog_counter = 0


# override methods
func _ready():
	GameManager.init() # TODO: move to main scene
	_start()

# public methods


# private methods
func _start():

	_create_dog()


func _restart():
	_duck_shown_counter = 0
	_duck_dead_counter = 0
	
	_reload_shotgun()
	_reset_hit_ducks(true)
	_create_dog()


func _evaluate_game():
	if _is_finish_game() == false:
		if _is_next_level() == false:
			_create_duck()
		elif _is_pass_next_level():
			_generate_next_level()
		else:
			_game_over()
			# set_best_score()
	else:
		_finish()
		# set_best_score()


func _create_dog():
	# TODO: create dog
	
	remove_dog_timer.start()


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
		
		_duck_shown_counter += 1
		_create_frog_counter += 1
		
		_reload_shotgun()
		_blink_current_hit_duck()
		_create_frog()


func _create_frog():
	if _create_frog_counter == GameManager.CREATE_FROG_AFTER_DEAD_DUCK_COUNT:
		
		_frog = Frog.instance()
		_frog.z_index = 1
		_frog.set_process_unhandled_input(true)

		add_child(_frog)

		_create_frog_counter = 0
		_create_frog_timer = 0


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


func _get_duck_dead_to_pass_next_level() -> int:
	match _level:
		1, 2, 3, 4:
			return 5
		5, 6:
			return 6
		7, 8:
			return 8
		9, 10:
			return 10
		_: 
			return 5


func _reload_shotgun():
	shotgun.reload()
	hud.reload_shotgun()


func _reset_hit_ducks(full_reset: bool):
	hud.reset_hit_ducks(full_reset)


func _blink_current_hit_duck():
	if _duck_shown_counter <= GameManager.DUCK_COUNT:
		hud.blink_hit_duck_by_index(_duck_shown_counter -1)


func _finish():
	GameManager.end()
	
	# TODO: show finish dialog.


func _game_over():
	GameManager.game_over()
	
	# TODO: show game over dialog.
	# TODO: show try again label.


func _generate_next_level():
	if !is_instance_valid(_duck) && !is_instance_valid(_frog):
		wait_timer.start()
		
		GameManager.prepare()
		_level += 1
		
		yield($wait_timer, "timeout")
		
		if _duck_dead_counter == GameManager.DUCK_COUNT:
			pass
			# TODO: show perfect dialog.
			# show_dialog(true, $CanvasLayer/PerfectDialog, str("Perfect\n", PERFECT_VALUE))
		else:
			_restart()


func _is_pass_next_level() -> bool:
	return _duck_dead_counter >= _get_duck_dead_to_pass_next_level()


func _is_finish_game() -> bool:
	return _level >= GameManager.MAX_LEVEL


func _is_next_level() -> bool:
	return _duck_shown_counter >= GameManager.DUCK_COUNT


# connect signals
func _on_Wold_shotgun_shoot():
	var bullet_position = shotgun.get_bullets()
	
	hud.hide_bullet(bullet_position)
	
	# TODO: - evaluate if have bullet
	#		- evaluate if duck flying


func _on_Wold_duck_go_away():
	hud.show_info_dialog("Fly Away")


func _on_Wold_duck_dead(value):
	if _duck_shown_counter <= GameManager.DUCK_COUNT && is_instance_valid(_duck):
		
		hud.killer_hit_duck_by_index(_duck_shown_counter -1)
		
		hud.set_score(value)
		
		_duck_dead_counter += 1


func _on_RemoveDogTimer_timeout():
	# TODO: show round level dialog
	
	round_hide_timer.start()


func _on_RoundHideTimer_timeout():
	GameManager.start()
	
	# TODO: hide round level dialog
	
	create_duck_timer.start()


func _on_CreateDuckTimer_timeout():
	if GameManager.is_started():
		_evaluate_game()
