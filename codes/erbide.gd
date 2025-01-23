class_name erbide extends CharacterBody2D

@export var existence = true

@onready var solaria: PackedScene = preload("res://scenes/solaria.tscn")
@onready var erbidino: PackedScene = preload("res://scenes/erbide.tscn")

signal death

#statistiche:
var specie = "Erbide"
var dieta = "Erbivoro"
var age = [0, 0, 0] #vita media: 1 ciclo, smette di crescere a 5 minuti = fertilità
var hunger = 10
var hunger_limit = 5
var life = 100
var pos = Vector2(position.x, position.y)
var speed = 0.1

var hungry = false
var gender
var secs = false #chi sa, sa
var fertility = true
var dead = false
var impollinato = false
var alert = false

var vegetables_in_area = []
var hot_erbidi_in_area = []
var dangerous_carnidi_in_area = []

var sol

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0, 1) == 0:
		gender = "male"
		$Skin.modulate = Color.html("#ae81bc")
	else:
		gender = "female"
		$Skin.modulate = Color.html("#ce787d")

	$Info/Control/VBoxContainer/SpecieContainer/SpecieFill.text = specie
	$Info/Control/VBoxContainer/DietaContainer/DietaFill.text = dieta
	$Info/Control/VBoxContainer/GenderContainer/GenderFill.text = gender

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#aggiorna i timer al tempo globale
	$Timer.wait_time = Globals.wait_time
	$MoveStatus.wait_time = Globals.wait_time * 2
	$PollinCooldown.wait_time = Globals.wait_time * 4
	$BirthCooldown.wait_time = Globals.wait_time * 2
	$InHeat.wait_time = Globals.wait_time * 8
	
	#polline
	if impollinato:
		$Polline.visible = true
		if $PollinCooldown.is_stopped():
			$PollinCooldown.start()
	else:
		$Polline.visible = false
	
	#raggio di ricerca
	if hungry or (secs and fertility) or alert:
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
		if alert:
			var closest = get_closest_carnide()
			if closest:
				var direction = global_position - closest.global_position
				movement = direction.normalized()
				velocity = movement * speed * 5
		elif vegetables_in_area.size() > 0 and hungry:
			$EatArea/CollisionShape2D.disabled = false
			var closest = get_closest_vegetable()
			if closest:
				var direction = closest.global_position - global_position
				movement = direction.normalized()
				velocity = movement * speed * 5
			else:
				velocity = Vector2.ZERO
		elif hot_erbidi_in_area.size() > 0 and secs and fertility:
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
		$Info/Control/VBoxContainer/FameContainer/FameFill.text = str(hunger) + "/10"
		$Info/Control/VBoxContainer/VitaContainer/HPFill.text = str(life) + "/100"
		
		#aggiorna dimensioni
		var s = age[1] * 60 + age[0] * 600 + age[2]
		var mod = float(sqrt(s) + 1)
		if mod < 16:
			$Skin.scale.x = mod * 4
			$Skin.scale.y = mod * 4
		
		#decadimento della fame
		if hunger < hunger_limit:
			hungry = true
		
		
		#perde vita
		if randi_range(0, 1) == 0 and hunger > 0:
			hunger -= 0.5
		if hunger < 1:
			life -= 1

func get_closest_vegetable() -> Node2D:
	if vegetables_in_area.size() == 0:
		return null
	vegetables_in_area.sort_custom(_compare_distance)
	return vegetables_in_area[0]
	
func get_closest_carnide() -> Node2D:
	if dangerous_carnidi_in_area.size() == 0:
		return null
	dangerous_carnidi_in_area.sort_custom(_compare_distance)
	return dangerous_carnidi_in_area[0]

func get_closest_hottie() -> Node2D:
	if hot_erbidi_in_area.size() == 0:
		return null
	hot_erbidi_in_area.sort_custom(_compare_distance)
	return hot_erbidi_in_area[0]

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
	if body is foglia or body is foglia2:
		vegetables_in_area.append(body)
	if body is erbide and body.gender != gender and body.secs:
		hot_erbidi_in_area.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is foglia or body is foglia2:
		vegetables_in_area.erase(body)
	if body is erbide:
		hot_erbidi_in_area.erase(body)


func _on_eat_area_body_entered(body: Node2D) -> void:
	if (body is foglia or body is foglia2) and hungry:
		vegetables_in_area.erase(body)
		$EatArea/Cooldown.start()
		if body.pollins:
			impollinato = true
			$Polline.visible = true
		body.queue_free()
		$EatArea/CollisionShape2D.disabled = true
		hunger += 5
		hungry = false
		$MoveStatus.start()
	if body is erbide and secs and fertility and body.fertility:
		print("*turtle noise*")
		$EatArea/Cooldown.start()
		$EatArea/CollisionShape2D.disabled = true
		if gender == "female":
			var number_of_fioi = [randi_range(0, 1), randi_range(0, 1), randi_range(0, 1)]
			for i in number_of_fioi:
				if i == 0:
					print("birth")
					var erb = erbidino.instantiate()
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
	if hungry:
		$MoveStatus.stop()
	else:
		var movement
		if !hungry and !secs:
			if randi_range(0, 1) == 0:
				movement = Vector2(0, 0)
			else:
				movement = Vector2(randi_range(-1, 1), randi_range(-1, 1))
			velocity = movement * speed


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("death", position)
	queue_free()


func _on_pollin_cooldown_timeout() -> void:
	if randi_range(0, 2) == 0:
		$PollinCooldown.stop()
		impollinato = false
		print("fine")
	else:
		print("mada mada")
	sol = solaria.instantiate()
	sol.position = position - Vector2(32, 32)
	get_parent().add_child(sol)
	

func _on_birth_cooldown_timeout() -> void:
	if randi_range(0, 1) == 0:
		get_parent().add_child(sol)


func _on_in_heat_timeout() -> void:
	if secs:
		secs = false
	else: 
		secs = true


func _on_erbi_detect_body_entered(body: Node2D) -> void:
	if body is carnide:
		alert = true
		dangerous_carnidi_in_area.append(body)


func _on_erbi_detect_body_exited(body: Node2D) -> void:
	if body is carnide:
		dangerous_carnidi_in_area.erase(body)
	if dangerous_carnidi_in_area.size() == 0:
		alert = false
