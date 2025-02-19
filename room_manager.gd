extends Node

func _ready() -> void:
	# HOUSE :
	var key = Item.new()
	key.initialize("Blue Key", Types.ItemTypes.KEY)
	$House.connect_exit("east", $OutsideRoom)
	$House.add_item(key)
	
