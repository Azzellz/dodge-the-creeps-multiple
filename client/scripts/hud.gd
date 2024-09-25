extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

## 对外暴露显示消息的方法
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

## 显示游戏结束
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
## 更新分数
func update_score(score:int) -> void:
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
