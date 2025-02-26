extends Node

enum ItemTypes {
	DEFAULT,
	KEY,
	QUEST_ITEM,
	TRANSLATOR
}

enum SpeedTypes {
	NONE,
	SLOW,
	NORMAL,
	FAST
}

const SpeedValues = {
	SpeedTypes.NONE: 0.0,
	SpeedTypes.SLOW: 0.1,
	SpeedTypes.NORMAL: 0.05,
	SpeedTypes.FAST: 0.02
}

enum NPCTypes{
	DEFAULT,
	SCIENTIST,
	ARTIO,
	ARTIO_GIRAFFE,
	PERISSO,
	PERISSO_EPONA,
	SEAL_PUP,
	SEAL_MOM,
	INDOHYUS,
	ARMALDO,
	LOVE_SEASHELL,
	LOVE_ARMALDO,
	ROGER,
	NEED_TRANSLATOR,
	NEED_ITEM,
	GIVE_QUEST,
	COMPLETE_QUEST,
	RELATED_TO_QUEST,
	GOT_ITEM_NEEDED
	
}

const COLOR_NPC = Color("#ff9a94")
const COLOR_ITEM = Color("#94b9ff")
const COLOR_LOCATION = Color("#faff94")
const COLOR_SYSTEM = Color("#ffd394")
const COLOR_QUEST = Color("#6495ED")
const COLOR_ATTENTION = Color("#BA55D3")
const COLOR_DREAM = Color("#00B5B5")

func wrap_attention_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_ATTENTION.to_html(), text]

func wrap_quest_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_QUEST.to_html(), text]

func wrap_system_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_SYSTEM.to_html(), text]
	
func wrap_npc_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_NPC.to_html(), text]

func wrap_item_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_ITEM.to_html(), text]
	
func wrap_dream_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_DREAM.to_html(), text]

func wrap_location_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_LOCATION.to_html(), text]
	
func manipulate_string(text : String) -> String:
	var new_text = text
		
	new_text = new_text.replace("@END", "[/color]")
	new_text = new_text.replace("@NPC", "[color=#ff9a94]")
	new_text = new_text.replace("@ITEM", "[color=#94b9ff]")
	new_text = new_text.replace("@LOCATION", "[color=#faff94]")
	new_text = new_text.replace("@SYSTEM", "[color=#ffd394]")
	new_text = new_text.replace("@QUEST", "[color=#6495ED]")
	new_text = new_text.replace("@ATTENTION", "[color=#BA55D3]")
	new_text = new_text.replace("@DREAM", "[color=#00B5B5]")
	
	return new_text
			
