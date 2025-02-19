extends Resource
class_name Item

@export var item_name := "Item Name"
@export var item_type := Types.ItemTypes.KEY

func initialize(item_name: String, item_type : Types.ItemTypes):
	self.item_name = item_name
	self.item_type = item_type
