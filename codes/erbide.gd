class_name creature extends CharacterBody2D

@export var existence = true

@onready var solaria: PackedScene = preload("res://scenes/solaria.tscn")

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
var secs = false #chi sa, sa
var dead = false
var impollinato = false

var vegetables_in_area = []

var sol

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Info/Control/VBoxContainer/SpecieContainer/SpecieFill.text = specie
	$Info/Control/VBoxContainer/DietaContainer/DietaFill.text = dieta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#aggiorna i timer al tempo globale
	$Timer.wait_time = Globals.wait_time
	$MoveStatus.wait_time = Globals.wait_time * 2
	$PollinCooldown.wait_time = Globals.wait_time * 4
	$BirthCooldown.wait_time = Globals.wait_time * 2
	
	#polline
	if impollinato:
		$Polline.visible = true
		if $PollinCooldown.is_stopped():
			$PollinCooldown.start()
	else:
		$Polline.visible = false
	
	#raggio di ricerca
	if hungry:
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
		if vegetables_in_area.size() > 0 and hungry:
			$EatArea/CollisionShape2D.disabled = false
			var closest = get_closest_vegetable()
			if closest:
				var direction = closest.global_position - global_position
				movement = direction.normalized()
				velocity = movement * speed * 5
			else:
				velocity = Vector2.ZERO
		move_and_collide(velocity)
		

func _on_timer_timeout() -> void:
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
	if body is foglia:
		vegetables_in_area.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is foglia:
		vegetables_in_area.pop_front()


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body is foglia and hungry:
		print("gnam")
		vegetables_in_area.erase(body)
		$EatArea/Cooldown.start()
		if body.pollins:
			print("lesgo")
			impollinato = true
			$Polline.visible = true
		else:
			print("non va")
		body.queue_free()
		$EatArea/CollisionShape2D.disabled = true
		hunger += 5
		hungry = false
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
