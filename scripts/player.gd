extends CharacterBody2D
@export var max_speed : int = 700
@export var jump_force : int = 1600
@export var acceleration : int = 700
@export var jump_buffer_time : int  = 15
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer_counter : int = 0


func _physics_process(delta):
	Engine.max_fps = 60 
	
	#gravity code
	if  !is_on_floor():
		pass
		velocity.y += gravity 
		if velocity.y > 2000:
			velocity.y = 2000
	#MOVE HORIZONTALLY CODE (accel set to max speed make so theres no accel)
	if Input.is_action_pressed("move_right"):
		velocity.x += acceleration
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x -= acceleration
		$AnimatedSprite2D.flip_h = true
	else:
		#for desceleration
		#velocity.x = lerp(velocity.x,0.0,0.2)
		velocity.x = 0
		
	#code for speed limit
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	#CODE FOR JUMPING
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_buffer_counter = jump_buffer_time
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	if jump_buffer_counter > 0:
		velocity.y = -jump_force 
		jump_buffer_counter = 0
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y *= 0.2 
	move_and_slide()
	$RichTextLabel.set_text(str("X:",velocity.x, " | Y:", velocity.y))
	animateplayerWIP(velocity)

func animateplayerWIP(velocity):
	#only play the jump animation if the jump button was pressed (idk may need to add a hurt animation l8r)
	if velocity.y < 1 and !is_on_floor() and Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("jump") 
	if velocity.y >= 0 and !is_on_floor():
		$AnimatedSprite2D.play("fall")
	if (((velocity.x < 10 and velocity.x > -10) and velocity.y == 0) and is_on_floor()):
		$AnimatedSprite2D.play("idle")
	if velocity.x != 0 and is_on_floor():
		#LEMBRAR DE ADICIONAR UM MULTIPLICADOR DE VELOCIDAAAADEEEEEE!!!!!!!!!!!!!!!!!!!!!
		#provavelmente vai ser tipo $animated2dsprite.frame.blablabla(insiralogicaaquilmao)
		$AnimatedSprite2D.play("run")
