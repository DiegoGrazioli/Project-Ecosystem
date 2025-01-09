extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.world_cycles == null and Globals.world_minutes == null and Globals.world_seconds == null:
		Globals.world_cycles = 0
		Globals.world_minutes = 0
		Globals.world_seconds = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Zoom"):
		$Camera2D.zoom += Vector2(0.1, 0.1)
		$Camera2D.scale = Vector2(1 / $Camera2D.zoom.x, 1 / $Camera2D.zoom.y)
	elif Input.is_action_just_pressed("Dezoom"):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
		$Camera2D.scale = Vector2(1 / $Camera2D.zoom.x, 1 / $Camera2D.zoom.y)
	if Input.is_action_pressed("su"):
		$Camera2D.position.y -= 1
	if Input.is_action_pressed("giù"):
		$Camera2D.position.y += 1
	if Input.is_action_pressed("destra"):
		$Camera2D.position.x += 1
	if Input.is_action_pressed("sinistra"):
		$Camera2D.position.x -= 1


func _on_timer_timeout() -> void:
	Globals.world_seconds += 1
	if Globals.world_seconds == 60:
		Globals.world_seconds = 0
		Globals.world_minutes += 1
		if Globals.world_minutes == 10:
			Globals.world_minutes = 0
			Globals.world_cycles += 1
