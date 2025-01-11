extends CharacterBody2D

class_name pianta

@export var existence = true


@onready var foglia_solaria: PackedScene = preload("res://scenes/foglia_solaria.tscn")

#statistiche:
var specie = "Solaria"
var dieta = "Sole"
var age = [0, 0, 0]
var leaves = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Info/Control/VBoxContainer/SpecieContainer/SpecieFill.text = specie
	$Info/Control/VBoxContainer/DietaContainer/DietaFill.text = dieta
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if leaves == 0:
		var foglia = foglia_solaria.instantiate()
		var foglia_pos = Vector2(randi_range(-16, 16), randi_range(-16, 16))
		foglia.position = foglia_pos
		foglia.predisposition = foglia_pos
		$Leaves.add_child(foglia)
		leaves += 1
	
	$Timer.wait_time = Globals.wait_time

func _on_timer_timeout() -> void:
	#aumento di età
	age[2] += 1
	if age[2] == 60:
		age[2] = 0
		age[1] += 1
		if age[1] == 10:
			age[1] = 0
			age[0] += 1
	#aggiorna info
	$Info/Control/VBoxContainer/EtaContainer/EtaFill.text = str(age[0]) + ", " + str(age[1]) + ", " + str(age[2])

func _on_hover_mouse_entered() -> void:
	$Info.visible = true


func _on_hover_mouse_exited() -> void:
	$Info.visible = false
