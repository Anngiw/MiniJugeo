extends Node2D
# Construye los bloques del MAPA. Las filas de "#" seguidas se juntan en un solo cuerpo,
# para que el personaje no se enganche en las uniones entre bloques.

const CELDA = 64


func construir_bloques(mapa: Array, color: Color):
	for fila in mapa.size():
		var col = 0
		var linea: String = mapa[fila]
		while col < linea.length():
			if linea[col] == "#":
				var fin = col
				while fin + 1 < linea.length() and linea[fin + 1] == "#":
					fin += 1
				crear_bloque(col, fin, fila, color)
				col = fin + 1
			else:
				col += 1


func crear_bloque(col_ini: int, col_fin: int, fila: int, _color: Color):
	var cantidad_bloques = col_fin - col_ini + 1
	var ancho = cantidad_bloques * CELDA
	var cuerpo = StaticBody2D.new()
	cuerpo.position = Vector2(col_ini * CELDA + ancho / 2.0, (fila + 0.5) * CELDA)
	
	var forma = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(ancho, CELDA)
	forma.shape = rect
	cuerpo.add_child(forma)
	
	# Creamos cada tile individual de 64x64 perfectamente ajustado
	var textura_ladrillo = load("res://assets/la.png")
	for i in range(cantidad_bloques):
		var dibujo = TextureRect.new()
		dibujo.texture = textura_ladrillo
		dibujo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		dibujo.size = Vector2(CELDA, CELDA)
		# Posicionamos cada bloque uno al lado del otro
		dibujo.position = Vector2(-ancho / 2.0 + (i * CELDA), -CELDA / 2.0)
		cuerpo.add_child(dibujo)
		
	add_child(cuerpo)
