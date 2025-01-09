extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	$Control/Time/Cicli.text = str(Globals.world_cycles)
	$Control/Time/Minuti.text = str(Globals.world_minutes)
	$Control/Time/Secondi.text = str(Globals.world_seconds)
