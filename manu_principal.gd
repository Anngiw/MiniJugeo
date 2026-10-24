extends CanvasLayer

# Rutas de las escenas de los niveles
@export_file("*.tscn") var nivel_1: String = "res://mundo.tscn"
@export_file("*.tscn") var nivel_2: String = "res://niveles.tscn" 


@onready var btn_jugar: Button = $PantallaCompleta/MarginContainer/VBoxContainer/BtnJugar
@onready var btn_nivel_1: Button = $PantallaCompleta/MarginContainer/VBoxContainer/BtnNivel1
@onready var btn_nivel_2: Button = $PantallaCompleta/MarginContainer/VBoxContainer/BtnNivel2
@onready var btn_nivel_3: Button = $PantallaCompleta/MarginContainer/VBoxContainer/BtnNivel3
@onready var btn_salir: Button = $PantallaCompleta/MarginContainer/VBoxContainer/BtnSalir

func _ready() -> void:
	btn_jugar.pressed.connect(_on_nivel_1_pressed)
	btn_nivel_1.pressed.connect(_on_nivel_1_pressed)
	btn_nivel_2.pressed.connect(_on_nivel_2_pressed)
	btn_salir.pressed.connect(_on_salir_pressed)

func _on_nivel_1_pressed() -> void:
	if nivel_1 != "":
		get_tree().change_scene_to_file(nivel_1)

func _on_nivel_2_pressed() -> void:
	if nivel_2 != "":
		get_tree().change_scene_to_file(nivel_2)

func _on_salir_pressed() -> void:
	get_tree().quit()
