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

enum VoiceSounds{
	typing,
	talking
}

@onready var sfx_player = AudioStreamPlayer.new()
@onready var voice_player = AudioStreamPlayer.new()
@onready var soundtrack_player = AudioStreamPlayer.new()

var current_room_audio : AudioStreamMP3

@export var soundtrack_volume = -16

func _ready():
	add_child(sfx_player) 
	add_child(voice_player) 
	soundtrack_player.volume_db = soundtrack_volume
	add_child(soundtrack_player) 

var sfx_sounds = {
		SFXSounds.enter_room : load("res://SFX/sfx_enter_room.ogg"),
		SFXSounds.locked_door : load("res://SFX/sfx_locked_door.ogg"),
		SFXSounds.unlocked : load("res://SFX/sfx_unlocked.ogg"),
		SFXSounds.drop_item : load("res://SFX/sfx_drop_item.ogg"),
		SFXSounds.get_item : load("res://SFX/sfx_get_item.ogg"),
		SFXSounds.got_quest : load("res://SFX/sfx_got_quest.ogg"),
		SFXSounds.give_item : load("res://SFX/sfx_player_gave_item.ogg")
	}

func change_soundtrack(audio: AudioStreamMP3):
	soundtrack_player.stream = audio
	current_room_audio = audio
	soundtrack_player.play()

func play_sfx(sound_type: SFXSounds):
	if sound_type in sfx_sounds:
		sfx_player.stream = sfx_sounds[sound_type]
		sfx_player.play()
		
var voice_sounds = {
		VoiceSounds.typing : load("res://Voices/typing.ogg"),
		VoiceSounds.talking : load("res://Voices/animal.ogg")
	}

func play_voice(voice_type: VoiceSounds):
	if voice_type in voice_sounds:
		voice_player.stream = voice_sounds[voice_type]
		voice_player.play()

func stop_voice():
	voice_player.stop()
