extends Node

enum SFXSounds{
	enter_room,
	unlocked,
	locked_door,
	drop_item,
	get_item,
	got_quest,
	give_item
}

@onready var sfx_player = AudioStreamPlayer.new()

func _ready():
	add_child(sfx_player)  # Adiciona o player na árvore da cena

@export var sfx_sounds = {
		SFXSounds.enter_room : load("res://SFX/sfx_enter_room.ogg"),
		SFXSounds.locked_door : load("res://SFX/sfx_locked_door.ogg"),
		SFXSounds.unlocked : load("res://SFX/sfx_unlocked.ogg"),
		SFXSounds.drop_item : load("res://SFX/sfx_drop_item.ogg"),
		SFXSounds.get_item : load("res://SFX/sfx_get_item.ogg"),
		SFXSounds.got_quest : load("res://SFX/sfx_got_quest.ogg"),
		SFXSounds.give_item : load("res://SFX/sfx_player_gave_item.ogg")
	}

func play_sfx(sound_type: SFXSounds):
	if sound_type in sfx_sounds:
		sfx_player.stream = sfx_sounds[sound_type]
		sfx_player.play()
