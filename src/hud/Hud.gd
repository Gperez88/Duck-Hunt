extends CanvasLayer

class_name Hud

# signals
signal info_popup_hide(ref_code)

# export variables


# onready variables
onready var score_label: Label = $ScoreLabel
onready var info_dialog: PopupDialog = $InfoPopup
onready var info_content_label: Label = $InfoPopup/ContentLabel
onready var try_again_label: Label = $TryAgainLabel
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
func reset_score():
	_score = 0
	score_label.text = _parse_score(_score)


func reload_shotgun():
	for bullet in bullets:
		bullet.show()


func hide_bullet(bullet_position: int):
	if bullets.size() -1 >= bullet_position:
		bullets[bullet_position].hide()


func reset_hit_ducks():
	for hit in duck_hits:
		hit.set_idle_state()


func idle_hit_duck_by_index(index: int):
	if duck_hits.size() -1 >= index:
		duck_hits[index].set_idle_state()


func blink_hit_duck_by_index(index: int):
	if duck_hits.size() -1 >= index:
		duck_hits[index].set_blink_state()


func killer_hit_duck_by_index(index: int):
	if duck_hits.size() -1 >= index:
		duck_hits[index].set_killer_state()


func show_info_dialog(content: String, ref_code: int = -1, timer_hide = 2):
	info_content_label.text = content
	
	info_dialog.popup()
	
	var timer = GlobalUtils.create_timer(timer_hide)
	
	yield(timer, "timeout")

	info_dialog.hide()
	
	emit_signal("info_popup_hide", ref_code)


func show_try_again_label():
	try_again_label.show()


func hide_try_again_label():
	try_again_label.hide()


# private methods
func _initScore():
	# TODO: get score from GameManager.
	score_label.text = _parse_score(_score)


func _parse_score(value: int) -> String:
	return str("%07d" % value)


# connect signals
