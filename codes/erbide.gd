extends CharacterBody2D

@export var existence = true

#statistiche:
var specie = "Erbide"
var dieta = "Erbivoro"
var age = [0, 0, 0] #vita media: 1 ciclo, smette di crescere a 5 minuti = fertilità
var hunger = 10
var life = 100
var pos = Vector2(position.x, position.y)
var speed = 500

var hungry = false
var secs = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Info/Control/VBoxContainer/SpecieContainer/SpecieFill.text = specie
	$Info/Control/VBoxContainer/DietaContainer/DietaFill.text = dieta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	$Info/Control/VBoxContainer/FameContainer/FameFill.text = str(hunger) + "/10"
	$Info/Control/VBoxContainer/VitaContainer/HPFill.text = str(life) + "/100"
	
	#aggiorna dimensioni
	var s = age[1] * 60 + age[0] * 600 + age[2]
	var mod = float(sqrt(s) + 1)
	if mod < 16:
		$Skin.scale.x = mod * 4
		$Skin.scale.y = mod * 4

	#movimento
	var movement
	if !hungry and !secs:
		if randi_range(0, 1) == 0:
			movement = Vector2(0, 0)
		else:
			movement = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		velocity = movement * speed
	move_and_slide()

	#decadimento della fame
	if hunger < 3:
		hungry = true								################################AGGIUNGI "IN CERCA DI CIBO"
	
	if randi_range(0, 1) == 0 and hunger > 0:
		hunger -= 0.5
		if hunger < 1:
			life -= 1
		

func _on_hover_mouse_entered() -> void:
	$Info.visible = true


func _on_hover_mouse_exited() -> void:
	$Info.visible = false
