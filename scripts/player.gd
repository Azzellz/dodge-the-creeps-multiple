extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var Anim: AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	screen_size = get_viewport_rect().size
	Anim = $AnimatedSprite2D

func start_game(pos):
	self.position = pos
	self.show()
	$CollisionShape2D.disabled = false

## 检查输入并且移动
func check_input_and_move(delta:float) -> void:
	# 检验输入
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# 播放动画
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		Anim.play()
	else:
		Anim.stop()
	
	# 移动
	self.position += velocity * delta
	self.position = self.position.clamp(Vector2.ZERO, screen_size)
	
	# 根据移动方向播放不同的动画(翻转动画)
	if velocity.x != 0:
		Anim.animation = 'walk'
		Anim.flip_v = false
		Anim.flip_h = velocity.x < 0
	elif  velocity.y != 0:
		Anim.animation = 'up'
		Anim.flip_v = velocity.y > 0
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_input_and_move(delta)


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
