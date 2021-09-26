extends Node2D

# signals

# export variables

# onready variables
onready var animation_player: AnimationPlayer = $AnimationPlayer

# public variables

# private variables

# override methods
func _ready():
	animation_player.play("idle")

# public methods

# private methods
