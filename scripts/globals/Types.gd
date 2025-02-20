extends Node

enum ItemTypes {
	KEY,
	QUEST_ITEM
}

const COLOR_NPC = Color("#ff9a94")
const COLOR_ITEM = Color("#94b9ff")
const COLOR_SPEECH = Color("#c3ff94")
const COLOR_LOCATION = Color("#faff94")
const COLOR_SYSTEM = Color("#ffd394")

func wrap_system_text(text : String) -> String:
	
	return "[color=%s]%s[/color]"
