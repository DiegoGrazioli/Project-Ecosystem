extends CharacterBody2D

@onready var foglia_solaria: PackedScene = preload("res://scenes/foglia_solaria.tscn")
#onready var vaniscenza blah blah blah

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$Timer.wait_time = Globals.wait_time

func _on_timer_timeout() -> void:
	var random = randi_range(0, 6)
	if random == 0:
		var pianta = foglia_solaria.instantiate()
		pianta.position = Vector2(randi_range(-16, 16), randi_range(-16, 16))
		get_parent().add_child(pianta)
	elif random == 1:
		pass ################################### SERVE PER ALTRA PIANTA
	elif random == 2:
		pass ################################### SERVE PER ALTRA PIANTA
		
	if randi_range(0, 1) == 0:
		queue_free()
		
