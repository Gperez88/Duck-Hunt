extends Node

# signals
signal shotgun_shoot

# export variables

# onready variables
onready var shot_gun = $ShotGun
onready var hud = $Hud

# public variables

# private variables

# override methods
func _ready():
	pass # Replace with function body.

func _input(event):
	pass

# public methods

# private methods

# connect signals
func _on_Wold_shotgun_shoot():
	var bullet_position = shot_gun.get_bullets()
	
	hud.hide_bullet(bullet_position)
	
	# TODO: - evaluate if have bullet
	#		- evaluate if duck flying
	
