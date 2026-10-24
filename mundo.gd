extends "res://bloques.gd"

# Leyenda del MAPA:
# "#" Bloque sólido de nivel
# "." Moneda coleccionable (Puntaje)
# "o" Llave de invencibilidad (Modo Poder)
# "^" Pinchos (Enemigos)
# "?" Bloques de la ZONA FANTASMA (Plataformas flotantes translúcidas)

const MAPA = [
	"                                                                                                                                                               ",
	"                                                                                                                                                               ",
	"                                                                                                                                                               ",
	"                                                                                                                  ######???#### ??###??#                       ",
	"                                                ..                                                            ##                                               #",
	"                                              ####                                                      ####                            ####                   #",
	"                                                                                                  ##                                                           #",
	"                    .       ....    ...  ....     .      .      .                              ####             ##                                          M  #",                   
	"                                        ####                         ...####               o                      o                        ..           ###    #",
	"                  ^^      ^       ^                           ^^     #######     ^             ^^    ^                ?    ?       ^   ##     ^                # ",
	"##########################################??##########???##############################???#######################################??#############################"
]
var moneda_escena = preload("res://moneda.tscn")
var llave_escena = preload("res://llave.tscn")
var pinchos_escena = preload("res://pinchos.tscn")
var meta_escena = preload("res://meta.tscn")
var zona_fantasma_escena = preload("res://zf.tscn")

@onready var jugador = $Cubo
var intentos = 1
var puntaje = 0
var modo_poder = false
var meta_nodo = null


func _ready():
	construir()
	
	# Buscar la meta automáticamente en el mapa una vez construido
	for child in $Mapa.get_children():
		if child.scene_file_path and "meta" in child.scene_file_path.to_lower():
			meta_nodo = child
			break

	# Conexión de monedas
	for item in get_tree().get_nodes_in_group("monedas"):
		item.recogido.connect(_on_recogido)
		
	# Conexión de enemigos/pinchos
	for enemigo in get_tree().get_nodes_in_group("enemigos"):
		enemigo.toco_al_jugador.connect(_on_enemigo_toco)
	
	# Inicializar los intentos en el HUD al arrancar
	if $HUD.has_method("actualizar_intentos"):
		$HUD.actualizar_intentos(intentos)
	
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
				"M": 
					escena = meta_escena 
				"?": 
					escena = zona_fantasma_escena 
			if escena:
				var nodo = escena.instantiate()
				nodo.position = Vector2(col + 0.5, fila + 0.5) * CELDA
				
				if MAPA[fila][col] == "^" or MAPA[fila][col] == "?":
					nodo.add_to_group("enemigos")
					
				$Mapa.add_child(nodo)


func _process(_delta: float) -> void:
	# Cálculo de la barra de progreso 
	if jugador and meta_nodo:
		var distancia_total = meta_nodo.global_position.x
		if distancia_total > 0:
			var distancia_recorrida = jugador.global_position.x
			var porcentaje = clamp((distancia_recorrida / distancia_total) * 100.0, 0.0, 100.0)
			
			if $HUD.has_method("actualizar_progreso"):
				$HUD.actualizar_progreso(porcentaje)

func _on_recogido(valor, da_poder):
	puntaje += valor
	
	# Actualizamos para usar el nuevo Hub 
	if $HUD.has_method("actualizar_puntaje"):
		$HUD.actualizar_puntaje(puntaje)
	
	if da_poder:
		activar_poder()
		
	if get_tree().get_nodes_in_group("monedas").size() == 1:
		print("¡Todas las monedas!")


func activar_poder():
	modo_poder = true
	print("poder: sí")
	$TimerPoder.start()


func _on_timer_poder_timeout():
	modo_poder = false
	print("poder: no")


# Función que se ejecuta al tocar un pincho
func _on_enemigo_toco(_enemigo):
	if jugador.muriendo:
		return
	if modo_poder:
		return
		
	intentos += 1
	jugador.morir()
	
	# Actualizamos los intentos usando el método limpio de nuestro nuevo HUD
	if $HUD.has_method("actualizar_intentos"):
		$HUD.actualizar_intentos(intentos)
