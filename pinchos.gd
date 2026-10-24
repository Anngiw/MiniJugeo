extends Area2D
signal toco_al_jugador(pincho)# Declaramos la señal 

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):# Comprobamos si el cuerpo que entra al área está en el grupo "jugador"
		emit_signal("toco_al_jugador", self)
