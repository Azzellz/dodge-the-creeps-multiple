extends Node

@export var mob_scene: PackedScene
var score

## 游戏结束
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Sounds/Bgm.stop()
	$Sounds/Death.play()
	
## 开始新的游戏
func new_game():
	score = 0
	$Player.start_game($StartPosition.position)
	$StartTimer.start()
	# 初始化HUD
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# 删除小怪
	get_tree().call_group("mobs", "queue_free")
	# 播放音乐
	$Sounds/Bgm.play()
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout() -> void:
		# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
