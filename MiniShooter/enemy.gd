extends Area2D

signal died

var start_pos = Vector2.ZERO
var speed = 0

@onready var screensize = self.get_viewport_rect().size

func start(pos : Vector2):
	speed = 0
	position  = Vector2(pos.x, -pos.y)
	start_pos = pos
	await self.get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	await tween.finished
	$MoveTimer.wait_time = randf_range(5, 20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(4, 20)
	$ShootTimer.start()

func explode():
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("explosion")
	set_deferred("monitoring", false)
	died.emit(5)
	await $AnimationPlayer.animation_finished
	queue_free()

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > screensize.y + 32:
		start(start_pos)

func _on_move_timer_timeout() -> void:
	speed = randf_range(75, 100)

func _on_shoot_timer_timeout() -> void:
	$ShootTimer.wait_time = randf_range(4, 20)
	$ShootTimer.start()
