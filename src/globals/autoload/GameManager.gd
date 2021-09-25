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

const SHOTGUN_BULLET = 3

# variables
var game_state = GameStates.PREPARED

func init():
	randomize()
	# TODO: init game prefs

