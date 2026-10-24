extends RefCounted
# Todos los niveles del juego. Para agregar un nivel nuevo:
#   1) dibuja su mapa abajo (todas las filas con el mismo largo, 11 filas),
#   2) agrégalo al match de obtener() y sube el número en total().
#
# Leyenda del mapa:
#   "#" Bloque sólido        "." Moneda              "o" Llave de invencibilidad (3 s)
#   "^" Pinchos (letales)    "?" Zona fantasma (letal; los pozos del piso también la usan)
#   "M" Meta (vórtice)       " " Vacío
#
# Reglas físicas para diseñar (velocidad 300-380 px/s, celda = 64 px):
#   - El salto sube ~3 celdas y recorre ~4,3 celdas (nivel 2) o ~4,8 (nivel 3).
#   - Pozos de hasta 3-4 celdas; pinchos sueltos separados por >= 5-6 celdas.
#   - Un escalón de 1 celda se debe saltar (chocar de frente mata).

const NIVEL_1 = [
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

const NIVEL_2 = [
	"                                                                                                                                                                                                               #",
	"                                                                                                                                                                                                               #",
	"                                                                                                                                                                                                               #",
	"                                                                                                                                                                                                               #",
	"                                                                                                                                                                            ......                             #",
	"                          ..       .                           .                                                                            .....................                                              #",
	"                                  . .      .....              . .    ...............                                  ...  ...  ...                                            ^                               #",
	"                         .  .                                                                                    ...                                                        ######                             #",
	"                                 .   .                 ####  .   .                      ?           ??                                                                   #########                             #",
	"              ^     ^     ^^            o   ^^^     #######           ^     ^     ^    ...   ^     ....   ^    ##   ##   ##   ##   ##  o     ^     ^^     ^     ^     ############              ^     ^^    M  #",
	"##################################???#########################???##############################################???????????????????????##################################################???#####################"
]

const NIVEL_3 = [
	"                                                                                                                                                                                                                                                   #",
	"                                                                                                                                                                                                                                                   #",
	"                                                                                                                                                                                                                                                   #",
	"                                                                                                                                                                                                                                                   #",
	"                                    ..                                                                                                                                                                                                             #",
	"                                   .  .                                                 ..............                                               ...  ...                 .......................                                              #",
	"                                                                                                                    ###################         ...            ...  ...                                                                            #",
	"                                                                                                                                                                                                                                                   #",
	"                                  .    .                      ?           ???                     ####               .................                  ##                                               ?                                         #",
	"             ^^      ^      ^                 ^^      ^   o  ...   ^^    .....    ^     ##   ##   ####       ^^       ^      ^      ^    o    ##   ##        ##   ##   ##      ^     ^^     ^      ^    ...   ^    ###          ^      ^^     M    #",
	"###################################????###################################################???##???############################################???????????????????????????#############################################????##########################"
]


static func total() -> int:
	return 3


static func obtener(indice: int) -> Dictionary:
	match indice:
		1:
			return {
				"nombre": "Cuevas de Neón",
				"mapa": NIVEL_2,
				"velocidad": 340.0,
				"color_bloques": Color(0.75, 0.55, 1.0),
				"color_fondo": Color(0.8, 0.5, 1.0),
				"color_cielo": Color(0.12, 0.05, 0.25),
			}
		2:
			return {
				"nombre": "Zona Fantasma",
				"mapa": NIVEL_3,
				"velocidad": 380.0,
				"color_bloques": Color(1.0, 0.55, 0.45),
				"color_fondo": Color(1.0, 0.45, 0.4),
				"color_cielo": Color(0.25, 0.04, 0.06),
			}
		_:
			return {
				"nombre": "Despegue",
				"mapa": NIVEL_1,
				"velocidad": 300.0,
				"color_bloques": Color(1.0, 1.0, 1.0),
				"color_fondo": Color(1.0, 1.0, 1.0),
				"color_cielo": Color(0.15, 0.2, 0.7),
			}
