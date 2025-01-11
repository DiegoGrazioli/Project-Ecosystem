extends Node2D
class_name foglia

@onready var foglia_solaria: PackedScene = preload("res://scenes/foglia_solaria.tscn")

var predisposition = Vector2()
var age = 0
var leaves = 0
var fertility = false
var pollins = false
var growth = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0, 1) == 0:
		pollins = true
		$Polline.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Timer.wait_time = Globals.wait_time
	if !fertility and !growth:
		$Timer.stop()
		$CollisionShape2D.disabled = true
		$Polline.visible = false


func _on_timer_timeout() -> void:
	age += 1
	if growth:
		$Skin.scale.x += 2
		$Skin.scale.y += 2
	
	if $Skin.scale.x >= 12:
		growth = false
		fertility = true
	
	if randi_range(0, 16 + leaves * 2) == 0 and fertility:
		var foglia = foglia_solaria.instantiate()
		
		var foglia_pos = Vector2(randi_range(predisposition.x - 4, predisposition.x + 4), randi_range(predisposition.y - 4, predisposition.y + 4))
		
		foglia.position = foglia_pos
		foglia.predisposition = foglia_pos
		$Leaves.add_child(foglia)
		leaves += 1
		
		if randi_range(0, 6) != 0:
			fertility = false
			$Skin.modulate = Color.html("#cbd94e")
