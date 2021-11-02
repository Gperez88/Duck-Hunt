extends Node

# constants
enum GameStates {
	PREPARED,
	STARTED, 
	PAUSED,  
	GAME_OVER, 
	ENDED
}
enum SideShow {
	LEFT, 
	RIGHT, 
	CENTER
}

const DuckTypes = {
	EASY="easy", 
	MEDIUM="medium", 
	HARD="hard"
}

const DuckAnimations = {
	DEAD="dead", 
	SHOTED="shooted", 
	SIDE="side", 
	UP="up"
}

const MAX_LEVEL = 10
const DUCK_COUNT = 10
const PERFECT_VALUE = 10000
const CREATE_FROG_AFTER_DEAD_DUCK_COUNT = 3
const SHOTGUN_BULLETS = 3

# private variables
var _game_state = GameStates.PREPARED setget , get_game_state


# constructor
func init():
	randomize()
	# TODO: init game prefs

# setters and getters
func get_game_state() -> int:
	return _game_state


# public methods
func prepare():
	_game_state = GameStates.PREPARED


func pause():
	_game_state = GameStates.PAUSED


func start():
	_game_state = GameStates.STARTED


func game_over():
	_game_state = GameStates.GAME_OVER


func end():
	_game_state = GameStates.ENDED


func is_prepared() -> bool:
	return _game_state == GameStates.PREPARED


func is_started() -> bool:
	return _game_state == GameStates.STARTED


func is_paused() -> bool:
	return _game_state == GameStates.PAUSED


func is_game_over() -> bool:
	return _game_state == GameStates.GAME_OVER


func is_ended() -> bool:
	return _game_state == GameStates.ENDED
