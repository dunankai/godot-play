extends Area2D

@export var speed : float = 150
@export var cooldown = 0.25
@export var bullet_scene : PackedScene

@onready var screensize : Vector2 = get_viewport_rect().size

var can_shoot = true

signal died
signal shield_changed

@export var max_shield = 10
var shield = max_shield:
	set = set_shield

func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)
	if shield <= 0:
		hide()
		died.emit()

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	shield = max_shield
	self.show()
	$GunCooldown.wait_time = cooldown

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0, -8))

func _ready():
	position = Vector2(screensize.x / 2, screensize.y - 64)

func _process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
	
	if input.y > 0:
		$Ship/Boosters.scale.y = 0.75
		$Ship/Boosters.position.y = 13
	elif input.y < 0:
		$Ship/Boosters.scale.y = 1.5
		$Ship/Boosters.position.y = 19
	else:
		$Ship/Boosters.scale.y = 1.0
		$Ship/Boosters.position.y = 15
	
	position += input * speed * delta
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
	
	if Input.is_action_pressed("shoot"):
		shoot()

func _on_gun_cooldown_timeout() -> void:
	can_shoot = true


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.explode()
		shield -= max_shield / 2
