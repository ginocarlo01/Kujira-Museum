extends Node

enum ItemTypes {
	DEFAULT,
	KEY,
	QUEST_ITEM,
	TRANSLATOR
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
	ROGER
}

const COLOR_NPC = Color("#ff9a94")
const COLOR_ITEM = Color("#94b9ff")
const COLOR_SPEECH = Color("#c3ff94")
const COLOR_LOCATION = Color("#faff94")
const COLOR_SYSTEM = Color("#ffd394")
const COLOR_QUEST = Color("#6495ED")
const COLOR_ATTENTION = Color("#BA55D3")

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

func wrap_speech_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_SPEECH.to_html(), text]

func wrap_location_text(text : String) -> String:
	return "[color=#%s]%s[/color]" % [COLOR_LOCATION.to_html(), text]
