extends Area2D

@export var speed : float = 150

func start(pos : Vector2) -> void:
	self.position = pos

func _process(delta: float) -> void:
	self.position.y += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		queue_free()
		area.shield -= 1
