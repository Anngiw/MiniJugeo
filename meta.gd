extends Area2D

var nivel_terminado = false
var cubo_atrapado = null
var tiempo_transcurrido = 0.0

@onready var sprite = $Sprite2D 

func _ready():
	body_entered.connect(_on_body_entered)
	set_process_input(false)

func _process(delta):
	# Si el nivel ya terminó y atrapamos al cubo, ejecutamos la animación de arrastre y giro
	if nivel_terminado and cubo_atrapado != null:
		tiempo_transcurrido += delta
		
		# Atraemos la posición del cubo suavemente hacia el centro exacto del vórtice
		cubo_atrapado.global_position = cubo_atrapado.global_position.lerp(global_position, delta * 5.0)
		
		# Hacemos que el cubo gire rápidamente sobre sí mismo mientras es absorbido
		if cubo_atrapado.has_node("AnimatedSprite2D"):
			var sprite_cubo = cubo_atrapado.get_node("AnimatedSprite2D")
			sprite_cubo.rotation += deg_to_rad(720) * delta # Gira 2 vueltas por segundo
			
			# Reducimos su escala progresivamente hasta desaparecer
			var escala_actual = sprite_cubo.scale.x - (delta * 1.5)
			if escala_actual < 0.0:
				escala_actual = 0.0
			sprite_cubo.scale = Vector2(escala_actual, escala_actual)
		
		# Después de 1 segundo de animación, mostramos el mensaje final y esperamos la barra espaciadora
		if tiempo_transcurrido > 1.0 and not is_processing_input():
			cubo_atrapado.visible = false
			
			var hud_mensaje = get_tree().root.get_node_or_null("Mundo/HUD/Control/Mensaje")
			if hud_mensaje:
				hud_mensaje.text = "¡Nivel Completado!\nPresiona [Espacio] para continuar"
				hud_mensaje.visible = true
			
			set_process_input(true)
		return

	# Efecto de pulso normal del vórtice mientras espera al jugador
	if not nivel_terminado and sprite:
		var pulso = sin(Time.get_ticks_msec() * 0.005) * 0.03
		var escala_base = 0.6
		sprite.scale = Vector2(escala_base + pulso, escala_base + pulso)

func _on_body_entered(body):
	if body.name == "Cubo" and not nivel_terminado:
		if "muriendo" in body and body.muriendo:
			return
			
		if body.global_position.y > global_position.y + 200:
			return
			
		nivel_terminado = true
		cubo_atrapado = body
		print("¡El vórtice está arrastrando al cubo!")
		body.set_process(false)
		body.set_physics_process(false)
		if body.has_node("CollisionShape2D"):
			body.get_node("CollisionShape2D").set_deferred("disabled", true)

func _input(event):
	if nivel_terminado and event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			print("¡Cambiando al siguiente nivel!")
			get_tree().reload_current_scene()
