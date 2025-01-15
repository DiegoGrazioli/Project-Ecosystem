extends CharacterBody2D

class_name funghinoide

@onready var solaria: PackedScene = preload("res://scenes/solaria.tscn")
@onready var funghino: PackedScene = preload("res://scenes/funghinoide.tscn")
#onready var vaniscenza blah blah blah

#statistiche:
var specie = "Funghinoide"
var dieta = "Sole, cadaveri"
var age = [0, 0, 0]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$Timer.wait_time = Globals.wait_time

func _on_timer_timeout() -> void:
	var random = randi_range(0, 12)
	if random == 0:
		print("pianta")
		var pianta = solaria.instantiate()
		pianta.position = Vector2(position.x + randi_range(-32, 32),position.y + randi_range(-32, 32))
		get_parent().add_child(pianta)
		if randi_range(0, 10) != 0:
			queue_free()
	elif random == 1 or random == 2 or random == 3:
		print("fungho")
		var fun = funghino.instantiate()
		fun.position = Vector2(position.x + randi_range(-32, 32), position.y + randi_range(-32, 32))
		get_parent().add_child(fun)
		if randi_range(0, 4) != 0:
			queue_free()
	elif random == 4:
		pass ################################### SERVE PER ALTRA PIANTA
	elif random == 5:
		pass ################################### SERVE PER ALTRA PIANTA
		
