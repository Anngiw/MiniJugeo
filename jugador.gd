extends CharacterBody2D
# Solución del Taller 3 .

@export var speed = 300.0       # px/s hacia la derecha
@export var gravedad = 2400.0   # px/s²
@export var salto = 980.0       # px/s hacia arriba
@export var giro = 300.0        # grados por segundo en el aire
@export var meta_x = 4000.0     # dónde termina el nivel

var inicio = Vector2.ZERO
var muriendo = false
var intentos = 1

@onready var sprite = $AnimatedSprite2D
@onready var musica = $Musica
@onready var sonido_explosion = $Explosion


func _ready():
	inicio = position
	musica.play()    # una sola vez: el archivo ya viene en bucle
	actualizar_hud()


func _physics_process(delta):
	if muriendo:
		return
	mover(delta)
	if is_on_wall():
		morir()
		return
	girar(delta)
	if position.y > 800:
		morir()
		return


func mover(delta):
	velocity.x = speed
	if is_on_floor():
		if Input.is_action_pressed("saltar"):
			velocity.y = -salto
	else:
		velocity.y += gravedad * delta
	move_and_slide()


# Nivel 1: gira en el aire (lo decide is_on_floor, no la tecla). Nivel 2: aterriza derecho. Mariana
func girar(delta):
	if not is_on_floor():
		sprite.rotation += deg_to_rad(giro) * delta
	else:
		sprite.rotation = snappedf(sprite.rotation, PI / 2)


# Nivel 3 Jaider
func progreso() -> int:
	return int(clampf((position.x - inicio.x) / (meta_x - inicio.x), 0.0, 1.0) * 100)


func morir():
	muriendo = true
	print("Intento %d: %d%%" % [intentos, progreso()])
	velocity = Vector2.ZERO
	musica.stop()
	sonido_explosion.play()
	sprite.rotation = 0.0
	sprite.play("explotar")
	await sprite.animation_finished
	position = inicio
	sprite.play("normal")
	intentos += 1
	actualizar_hud()
	musica.play()    # en Geometry Dash la música sí vuelve a empezar con cada intento
	muriendo = false


func actualizar_hud():
	var hud_mensaje = get_node_or_null("../HUD/Mensaje")
	if hud_mensaje:
		hud_mensaje.text = "Intento %d" % intentos
