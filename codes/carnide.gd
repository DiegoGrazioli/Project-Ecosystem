class_name carnide extends CharacterBody2D

@export var existence = true

@onready var solaria: PackedScene = preload("res://scenes/solaria.tscn")
@onready var carnidino: PackedScene = preload("res://scenes/carnide.tscn")

signal death

#statistiche:
var specie = "Carnide"
var dieta = "Carnivoro"
var age = [0, 0, 0] #vita media: 1 ciclo, smette di crescere a 5 minuti = fertilità
var hunger = 20
var hunger_limit = 10
var life = 70
var pos = Vector2(position.x, position.y)
var speed = 0.1

var hungry = false
var gender
var secs = false #chi sa, sa
var fertility = true
var dead = false

var erbides_in_area = []
var hot_carnidi_in_area = []

var sol

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0, 1) == 0:
		gender = "male"
		$Skin.modulate = Color.html("#640035")
	else:
		gender = "female"
		$Skin.modulate = Color.html("#b50015")

	$Info/Control/VBoxContainer/SpecieContainer/SpecieFill.text = specie
	$Info/Control/VBoxContainer/DietaContainer/DietaFill.text = dieta
	$Info/Control/VBoxContainer/GenderContainer/GenderFill.text = gender

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#aggiorna i timer al tempo globale
	$Timer.wait_time = Globals.wait_time
	$MoveStatus.wait_time = Globals.wait_time * 2
	$BirthCooldown.wait_time = Globals.wait_time * 2
	$InHeat.wait_time = Globals.wait_time * 8
	$ErbiDetect/Agguato.wait_time = Globals.wait_time * 2
	
	#raggio di ricerca
	if hungry or (secs and fertility):
		if $Area2D/CollisionShape2D.shape.radius < 750:
			$Area2D/CollisionShape2D.shape.radius += 5
		else:
			$Area2D/CollisionShape2D.shape.radius = 1
	
	if life <= 0:
		dead = true
		$AnimationPlayer.play("death")
	else:
	#movimento
		var movement
		if erbides_in_area.size() > 0 and hungry and $ErbiDetect/Agguato.is_stopped():
			$EatArea/CollisionShape2D.disabled = false
			var closest = get_closest_erbide()
			if closest:
				var direction = closest.global_position - global_position
				movement = direction.normalized()
				velocity = movement * speed * 5
			else:
				velocity = Vector2.ZERO
		elif hot_carnidi_in_area.size() > 0 and secs and fertility:
			$EatArea/CollisionShape2D.disabled = false
			var closest = get_closest_hottie()
			if closest:
				var direction = closest.global_position - global_position
				movement = direction.normalized()
				velocity = movement * speed * 5
			else:
				velocity = Vector2.ZERO
		move_and_collide(velocity)
		

func _on_timer_timeout() -> void:
	if secs and fertility:
		print("sessssss")
		$SecsShape.disabled = false
	else:
		$SecsShape.disabled = true
	
	if !dead:
		#aumento di età
		age[2] += 1
		if age[2] == 60:
			age[2] = 0
			age[1] += 1
			if age[1] == 10:
				age[1] = 0
				age[0] += 1
		
		if age[0] > 0 and randi_range(0, 1) == 0:
			dead = true
		if age[1] > 3:
			$InHeat.start()
			secs = true
			
		#aggiorna info
		$Info/Control/VBoxContainer/EtaContainer/EtaFill.text = str(age[0]) + ", " + str(age[1]) + ", " + str(age[2])
		$Info/Control/VBoxContainer/FameContainer/FameFill.text = str(hunger) + "/20"
		$Info/Control/VBoxContainer/VitaContainer/HPFill.text = str(life) + "/70"
		
		#aggiorna dimensioni
		var s = age[1] * 60 + age[0] * 600 + age[2]
		var mod = float(sqrt(s) + 1)
		if mod < 12:
			$Skin.scale.x = mod * 2
			$Skin.scale.y = mod * 2
		
		#decadimento della fame
		if hunger < hunger_limit:
			hungry = true
		
		
		#perde vita
		if randi_range(0, 1) == 0 and hunger > 0:
			hunger -= 0.5
		if hunger < 1:
			life -= 1

func get_closest_erbide() -> Node2D:
	if erbides_in_area.size() == 0:
		return null
	erbides_in_area.sort_custom(_compare_distance)
	return erbides_in_area[0]

func get_closest_hottie() -> Node2D:
	if hot_carnidi_in_area.size() == 0:
		return null
	hot_carnidi_in_area.sort_custom(_compare_distance)
	return hot_carnidi_in_area[0]

func _compare_distance(a: Node2D, b: Node2D) -> int:
	var dist_a = position.distance_to(a.position)
	var dist_b = position.distance_to(b.position)
	if dist_a < dist_b:
		return -1
	elif dist_a > dist_b:
		return 1
	else:
		return 0

func _on_hover_mouse_entered() -> void:
	$Info.visible = true


func _on_hover_mouse_exited() -> void:
	$Info.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is erbide:
		erbides_in_area.append(body)
	if body is carnide and body.gender != gender and body.secs:
		hot_carnidi_in_area.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is erbide:
		erbides_in_area.erase(body)
	if body is carnide:
		hot_carnidi_in_area.erase(body)


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body is erbide and hungry:
		erbides_in_area.erase(body)
		$EatArea/Cooldown.start()
		body.queue_free()
		$EatArea/CollisionShape2D.disabled = true
		hunger += 5
		hungry = false
		$MoveStatus.start()
	if body is carnide and secs and fertility and body.fertility:
		print("*turtle noise*")
		$EatArea/Cooldown.start()
		$EatArea/CollisionShape2D.disabled = true
		if gender == "female":
			var number_of_fioi = [randi_range(0, 1), randi_range(0, 1), randi_range(0, 1)]
			for i in number_of_fioi:
				if i == 0:
					print("birth")
					var erb = carnidino.instantiate()
					erb.position = position
					get_parent().add_child(erb)
					fertility = false
					body.fertility = false
				else:
					print("abirth")
			
		secs = false
		$MoveStatus.start()


func _on_cooldown_timeout() -> void:
	$EatArea/CollisionShape2D.disabled = false


func _on_move_status_timeout() -> void:
	if hungry or !$ErbiDetect/Agguato.is_stopped():
		$MoveStatus.stop()
	else:
		var movement
		if !hungry and !secs:
			if randi_range(0, 1) == 0:
				movement = Vector2(0, 0)
			else:
				movement = Vector2(randi_range(-1, 1), randi_range(-1, 1))
			velocity = movement * speed
	if !$ErbiDetect/Agguato.is_stopped():
		velocity = Vector2.ZERO

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("death", position)
	queue_free()
	

func _on_birth_cooldown_timeout() -> void:
	if randi_range(0, 1) == 0:
		get_parent().add_child(sol)


func _on_in_heat_timeout() -> void:
	if secs:
		secs = false
	else: 
		secs = true


func _on_erbi_detect_body_entered(body: Node2D) -> void:
	if body is erbide and $ErbiDetect/Agguato.is_stopped():
		$ErbiDetect/Agguato.start()


func _on_erbi_detect_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_agguato_timeout() -> void:
	var closest = get_closest_erbide()
	if closest:
		var direction = closest.global_position - global_position
		var movement = direction.normalized()
		velocity = movement * speed * 10
	move_and_collide(velocity)
