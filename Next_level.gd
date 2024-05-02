extends Area2D

var entered = false

export(String, FILE) var NEXT_LEVEL: String = ""

func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene(NEXT_LEVEL)


func _on_Next_level_body_entered(body):
	if body.is_in_group("Player") and NEXT_LEVEL != "":
		entered = true
		
func _on_Next_level_body_exited(body):
	if body.is_in_group("Player") and NEXT_LEVEL != "":
		entered = false
