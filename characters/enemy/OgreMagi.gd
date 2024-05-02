extends KinematicBody2D

export var ACCELERATION = 200
export var MAX_SPEED = 60
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE,
	DEATH,
	ATTACK
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox

func _ready():
	animationTree.active = true

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

				animationTree.set("parameters/Run/blend_position", direction)
				animationTree.set("parameters/Attack/blend_position", direction)
				animationState.start("Run")
			else:
				state = IDLE
				animationState.start("Idle")
		DEATH:
			death_anim()
			
		ATTACK:
			attack()
			
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 135
	hurtbox.start_invicibility(0.5)
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	state = DEATH
	
func death_anim():
	animationState.travel("Death")
	
func death_animation_finished():
	queue_free()
	
func attack():
	animationState.start("Attack")
