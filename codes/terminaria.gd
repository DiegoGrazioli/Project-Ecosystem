extends CharacterBody2D

class_name pianta2

@export var existence = true


@onready var foglia_terminaria: PackedScene = preload("res://scenes/foglia_terminaria.tscn")

#statistiche:
var specie = "Terminaria"
var dieta = "Spore"
var age = [0, 0, 0]
var life = 100
var leaves = 0
var hunger = 10
var hunger_limit = 5
var hungry = false
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Info/Control/VBoxContainer/SpecieContainer/SpecieFill.text = specie
	$Info/Control/VBoxContainer/VitaContainer/HPFill.text = str(life)
	$Info/Control/VBoxContainer/DietaContainer/DietaFill.text = dieta
	$Info/Control/VBoxContainer/FameContainer/FameFill.text = str(hunger)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var foglie = $Leaves
	if  foglie.get_child_count() == 0:
		var foglia = foglia_terminaria.instantiate()
		var foglia_pos = Vector2(0, 12)
		foglia.position = foglia_pos
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
	$Info/Control/VBoxContainer/FameContainer/FameFill.text = str(hunger)
	if life >= 0:
		$Info/Control/VBoxContainer/VitaContainer/HPFill.text = str(life)
	
	if hunger < hunger_limit:
		hungry = true
	
	if randi_range(0, 1) == 0:
		if hunger > 0:
			hunger -= 0.5
		if hunger < hunger_limit:
			life -= 1
	
	if life <= 0:
		dead = true
		$AnimationPlayer.play("death")

func _on_hover_mouse_entered() -> void:
	$Info.visible = true


func _on_hover_mouse_exited() -> void:
	$Info.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
