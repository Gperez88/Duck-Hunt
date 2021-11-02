extends Sprite

# signals


# export variables


# onready variables
onready var animation_player: AnimationPlayer = $AnimationPlayer


# public variables


# private variables


# override methods
func _ready():
	set_idle_state()


# public methods
func set_idle_state():
	_set_state("idle")


func set_blink_state():
	_set_state("blink")


func set_killer_state():
	_set_state("killer")


# private methods
func _set_state(anim: String):
	animation_player.play(anim)
