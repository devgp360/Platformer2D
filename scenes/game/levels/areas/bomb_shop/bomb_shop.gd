extends Node2D


# Valor de cada bomba y la moneda de pago
@export var bomb_value = 5
@export var bomb_money = "GoldCoin"
# Diálogo de compra
@export var buy_dialogue: DialogueResource
# Diálogo de compra fallida
@export var failed_dialogue: DialogueResource
# Diálogo de compra realizada
@export var success_dialogue: DialogueResource

var _ended = false

# Referencia al npc
@onready var npc = $NPC/BigGuy


# Función de inicialización
func _ready():
	# Quitamos colisiones del NPC
	npc.disabled_collision(true)
	npc.on_dialogue_ended(_on_dialogue_ended)
	npc.on_response_selected(_on_response_selected)


# Procedemos a comprar una cantidad de bombas
# Si se puede comprar la cantidad, se retorna "true", de lo contrario "false"
# Si el "amount" es "-1", se intentará comprar todas las bombas que se puedan
# (si se compra al menos 1, se retorna "true")
func buy_bombs(amount: int):
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


func _on_dialogue_ended():
	if _ended:
		_ended = false
		npc.set_dialogue(buy_dialogue)
	else:
		_ended = true
		# Test, agregamos 100 monedas de oro
		#HealthDashboard.add_points(bomb_money, 100)
		var bought = buy_bombs(10)
		if bought:
			npc.set_and_show_dialogue(success_dialogue)
		else:
			npc.set_and_show_dialogue(failed_dialogue)


func _on_response_selected(response: String):
	print("response_selecrted: ", response)
