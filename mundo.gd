extends "res://bloques.gd"

# Leyenda del MAPA:
# "#" Bloque sólido de nivel
# "." Moneda coleccionable (Puntaje)
# "o" Llave de invencibilidad (Modo Poder)
# "^" Pinchos (Enemigos)
# "?" Bloques de la ZONA FANTASMA (Plataformas flotantes translúcidas)

const MAPA = [
	"                                                                                                                                                                                                                                                                                                                                ",
	"                                                                                                                                                                                                                                                                                                                                ",
	"                                                                           .                                                                                                                                                                                    .                                                               ",
	"                                                                        ###                                                                                                                                                                                  ###                                                              ",
	"                                                                                                                                   .                                                                                                                                                                              ",
	"                     .                        .             o                                                             ###                                     .                                                 o                                                                             ",
	"                    ###                      ###           ###           ?   ?   ?   ?   ?                                                               ###                                            ###                                                ",
	"             .                ^                     ^                   ??? ??? ??? ??? ???            ^               o             .                         ^                   ^                         ###                 ^               ^               o            ",
	"            ###              ###                   ###                 ????? ????? ?????            ###             ###           ###                       ###                 ###                       #####               ###             ###             ###           ",
	"##################################^^###################################???######## ?##?#################^^^##################################^^###################################^^^^#################################################################",
	"######################################################################################################"
]

var moneda_escena = preload("res://moneda.tscn")
var llave_escena = preload("res://llave.tscn")
var pinchos_escena = preload("res://pinchos.tscn")

@onready var jugador = $Cubo
var intentos = 1
var puntaje = 0
var modo_poder = false


func _ready():
	construir()
	# Conexión de monedas
	for item in get_tree().get_nodes_in_group("monedas"):
		item.recogido.connect(_on_recogido)
	# Conexión de enemigos/pinchos
	for enemigo in get_tree().get_nodes_in_group("enemigos"):
		enemigo.toco_al_jugador.connect(_on_enemigo_toco)
	
	# Verificamos o creamos el TimerPoder por código de forma segura
	if not has_node("TimerPoder"):
		var timer = Timer.new()
		timer.name = "TimerPoder"
		timer.wait_time = 3.0 # Duración del poder en segundos
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(_on_timer_poder_timeout)
	else:
		$TimerPoder.timeout.connect(_on_timer_poder_timeout)


func construir():
	construir_bloques(MAPA, Color(0.05, 0.05, 0.15, 1))
	for fila in MAPA.size():
		for col in MAPA[fila].length():
			var escena = null
			match MAPA[fila][col]:
				".":
					escena = moneda_escena
				"o":
					escena = llave_escena
				"^":
					escena = pinchos_escena
			if escena:
				var nodo = escena.instantiate()
				nodo.position = Vector2(col + 0.5, fila + 0.5) * CELDA
				$Mapa.add_child(nodo)

func _on_recogido(valor, da_poder):
	puntaje += valor
	$HUD/Puntaje.text = "Monedas: %d" % puntaje
	if da_poder:
		activar_poder()
	if get_tree().get_nodes_in_group("monedas").size() == 1:
		$HUD/Mensaje.text = "¡Todas las monedas!"

func activar_poder():
	modo_poder = true
	print("poder: sí")
	# Reemplazamos el await por el start() del Timer del poder para manejar llaves seguidas
	$TimerPoder.start()


# Nueva función que recibe la señal timeout del Timer
func _on_timer_poder_timeout():
	modo_poder = false
	print("poder: no")

# Función que se ejecuta al tocar un pincho
func _on_enemigo_toco(_enemigo):
	# Si el cubo está muriendo, no hagan nada.
	if jugador.muriendo:
		return
	# Con poder el pincho no hace daño, no pasa nada.
	if modo_poder:
		return
	# Sin poder: un intento más y el cubo muere (vuelve al inicio con morir()).
	intentos += 1
	jugador.morir()
	# Actualicen el HUD con los intentos.
	$HUD/Mensaje.text = "Intentos: %d" % intentos
