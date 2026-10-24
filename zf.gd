extends Area2D

# La Zona Fantasma es letal: emite una señal de daño cuando el cubo la toca.
signal toco_al_jugador(zona) 

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		emit_signal("toco_al_jugador", self)
