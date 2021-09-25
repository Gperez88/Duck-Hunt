extends CanvasLayer

# signals
# export variables

# onready variables
onready var score_label: Label = $ScoreLabel
onready var bullets = [
	$Bullets/BulletThree, 
	$Bullets/BulletTwo, 
	$Bullets/BulletOne
]
onready var duck_hits = [
	$DuckHits/DuckHitOne,
	$DuckHits/DuckHitTwo,
	$DuckHits/DuckHitThree,
	$DuckHits/DuckHitFour,
	$DuckHits/DuckHitFive,
	$DuckHits/DuckHitSix,
	$DuckHits/DuckHitSeven,
	$DuckHits/DuckHitOne,
	$DuckHits/DuckHitEight,
	$DuckHits/DuckHitNine,
	$DuckHits/DuckHitTen,
]

# public variables

# private variables
var _score: int = 0 setget set_score,get_score

# setters and getters
func set_score(value: int):
	_score += value
	# TODO: save score in GameManager.
	score_label.text = _parse_score(_score)

func get_score() -> int:
	return _score

# override methods
func _ready():
	_initScore()

# public methods
func hide_bullet(bullet_position: int):
	if bullets.size() -1 >= bullet_position:
		bullets[bullet_position].hide()

# private methods
func _initScore():
	# TODO: get score from GameManager.
	score_label.text = _parse_score(_score)

func _parse_score(value: int) -> String:
	return str("%08d" % value)
