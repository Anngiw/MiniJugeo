extends CanvasLayer

@onready var label_intentos: Label = $MarginContainer/HBoxContainer/LabelIntentos
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/ProgressBar
@onready var label_porcentaje: Label = $MarginContainer/HBoxContainer/LabelPorcentaje
@onready var label_puntaje: Label = $MarginContainer/HBoxContainer/LabelPuntaje

func actualizar_progreso(porcentaje: float) -> void:
	var valor: float = clamp(porcentaje, 0.0, 100.0)
	progress_bar.value = valor
	label_porcentaje.text = str(int(valor)) + "%"

func actualizar_intentos(intentos: int) -> void:
	label_intentos.text = "Intentos: " + str(intentos)

func actualizar_puntaje(puntaje: int) -> void:
	if label_puntaje:
		label_puntaje.text = "Monedas: " + str(puntaje)
