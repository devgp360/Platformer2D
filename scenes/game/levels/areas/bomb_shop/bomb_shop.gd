extends Node2D
## Script que controla el intercambio de monedas a bombas
##
## Muestra diálogos con un NPC, maneja eventos en el diálogo y agrega bombas y reduce monedas


# Valor de cada bomba y la moneda de pago
@export var bomb_value = 5
@export var bomb_money = "GoldCoin"
# Diálogo de compra
@export var buy_dialogue: DialogueResource
# Diálogo de compra fallida
@export var failed_dialogue: DialogueResource
# Diálogo de compra realizada
@export var success_dialogue: DialogueResource

var _ended = false # Guardamos si ya terminamos la compra
var _responses = [] # Guardamos las respuestas seleccionadas

# Referencia al npc
@onready var npc = $NPC/BigGuy


# Función de inicialización
func _ready():
	# Quitamos colisiones del NPC y escuchamos eventos del diálogo
	npc.disabled_collision(true)
	npc.on_dialogue_ended(_on_dialogue_ended)
	npc.on_response_selected(_on_response_selected)


# Procedemos a comprar una cantidad de bombas
# Si se puede comprar la cantidad, se retorna "true", de lo contrario "false"
# Si el "amount" es "-1", se intentará comprar todas las bombas que se puedan
# (si se compra al menos 1, se retorna "true")
func _buy_bombs(amount: int):
	# Cantidad de monedas disponibles
	var coins = HealthDashboard.points[bomb_money]
	
	if amount < 0:
		# Calculamos la cantidad de bombas que podemos comprar
		amount = int(coins / bomb_value)

	if amount == 0:
		return false # Si la cantidad es 0, retornamos "false" (no se pudo comprar)

	# Compramos una cantidad específica de bombas
	var total = amount * bomb_value
	if  total <= coins:
		# Si el total a gastar es menor que el total de monedas, procedemos a comprar
		HealthDashboard.add_points(bomb_money, -total) # Reducimos las monedas
		HealthDashboard.add_bomb(amount) # Aumentamos las bombas
		return true
	else:
		return false


# Cuando terminamos el diálogo, procedemos a comprar bombas o mostrar el diálogo de finalización
func _on_dialogue_ended():
	if _ended:
		# Reseteamos el diálogo y variables para "volver a comprar"
		_ended = false
		_responses = []
		npc.set_dialogue(buy_dialogue)
	else:
		# Intentamos hacer la compra y finalizamos la conversación
		_ended = true
		var amount = _get_selected_amount()
		var bought = _buy_bombs(amount)
		if bought:
			# Si se pudo comprar, mostramos el diálogo "success"
			npc.set_and_show_dialogue(success_dialogue)
		else:
			# Si no se pudo comprar, mostramos el diálogo "failed"
			npc.set_and_show_dialogue(failed_dialogue)


# Sirve para guardar las respuestas seleccionadas
func _on_response_selected(response: String):
	_responses.append(response)


# Obtenemos la cantidad a comprar, dependiendo de la respuesta seleccionada
func _get_selected_amount():
	var amount = 0
	for r in _responses:
		if (r as String).contains("una"):
			amount = 1
		elif (r as String).contains("tres"):
			amount = 3
		elif (r as String).contains("cinco"):
			amount = 5
		elif (r as String).contains("monedas"):
			amount = -1
	return amount
