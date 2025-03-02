extends Resource
class_name Item

@export var item_name := "Item Name"
@export var item_type := Types.ItemTypes.KEY

var use_value = null
@export var use_value_description := "Use value description"

func initialize(item_name: String, item_type : Types.ItemTypes, use_value = ""):
	self.item_name = item_name
	self.item_type = item_type
	self.use_value = use_value
	
func set_use_value(use_value, use_value_description : String):
	self.use_value = use_value
	self.use_value_description = use_value_description
