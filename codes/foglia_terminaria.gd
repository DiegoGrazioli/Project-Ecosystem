extends Node2D
class_name foglia2

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


func _on_timer_timeout() -> void:
	if growth:
		$Skin.scale.x += 3
		$Skin.scale.y += 3
	
	if $Skin.scale.x >= 16:
		growth = false
