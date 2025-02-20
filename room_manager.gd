extends Node

func _ready() -> void:
	# KEYS :
	var key = Item.new()
	key.initialize("Blue_Key", Types.ItemTypes.KEY)
	key.use_value = $OutsideRoom
	
	# HOUSE :
	$House.connect_exit("east", $OutsideRoom) 
	$House.connect_exit("path", $EndPath) 
	$House.connect_exit("garden", $Garden,"gate") 
	
	# OUTSIDE:
	$OutsideRoom.add_item(key)
	$OutsideRoom.connect_exit("north", $ShedRoom)
	$OutsideRoom.lock_exit("north", $OutsideRoom)
	$OutsideRoom.connect_exit("east", $Forest)
	
	# FOREST:
	$Forest.connect_exit("south", $EndPath)
	$Forest.connect_exit("inside", $SmallHouse)
	
	
