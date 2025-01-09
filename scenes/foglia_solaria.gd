extends Node2D

@onready var foglia_solaria: PackedScene = preload("res://scenes/foglia_solaria.tscn")

var predisposition = Vector2()
var age = 0
var leaves = 0
var fertility = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Timer.wait_time = Globals.wait_time


func _on_timer_timeout() -> void:
	age += 1
	
	if randi_range(0, 24 + leaves * 2) == 0 and fertility:
		var foglia = foglia_solaria.instantiate()
		# destra o sinistra? x
		
		var foglia_pos = Vector2(randi_range(predisposition.x - 6, predisposition.x + 6), randi_range(predisposition.y - 6, predisposition.y + 6))
		
		foglia.position = foglia_pos
		foglia.predisposition = foglia_pos
		$Leaves.add_child(foglia)
		leaves += 1
		if randi_range(0, 1) == 0:
			fertility = false
