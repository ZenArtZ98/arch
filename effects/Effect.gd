extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("hitEffect")
	
#func _process(delta):
#	if Input.is_action_just_pressed("Attack"):
#		animatedSprite.frame = 0
#		animatedSprite.play("Animate")

func _on_animation_finished():
	queue_free()
