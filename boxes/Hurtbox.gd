extends Area2D


const HitEffect = preload("res://effects/HitEffect.tscn")

var invicible = false setget set_invisible

onready var timer = $Timer

signal invicibility_started
signal invicibility_end

func set_invisible(value):
	invicible = value
	if invicible == true:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_end")

func start_invicibility(duration):
	self.invicible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invicible = false

func _on_Hurtbox_invicibility_started():
	set_deferred("monitorable", false)

func _on_Hurtbox_invicibility_end():
	monitorable = true
