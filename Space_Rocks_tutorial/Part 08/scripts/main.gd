extends Node


var asteroid = preload("res://scenes/asteroid.tscn")
var explosion = preload("res://scenes/explosion.tscn")
onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var expl_sounds = get_node("expl_sounds")
onready var HUD = get_node("HUD")
onready var player = get_node("player")

func _ready():
	set_process(true)
	get_node("music").play()
	begin_next_level()

func begin_next_level():
	global.level += 1
	HUD.show_message("Wave %s" % global.level)
	for i in range(global.level):
		spawn_asteroid("big", spawns.get_child(i).get_pos(),
				   Vector2(0, 0))

func _process(delta):
	HUD.update(player)
	if asteroid_container.get_child_count() == 0:
		begin_next_level()

func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = global.break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(25) * offset
			var newvel = (vel + hit_vel.tangent() * offset) * 0.9
			spawn_asteroid(newsize, newpos, newvel)
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.play()
	expl_sounds.play("expl1")