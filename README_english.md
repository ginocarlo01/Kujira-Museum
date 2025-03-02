# Kujira Museum

## Overview
This project is a game developed in Godot Engine. The idea was to recreate a game in the Retro Text Adventure style from the early 1980s but with some new elements, such as music, a variety of commands, and photos for NPCs. To start, I based it on the video series from the [jmbiv](https://www.youtube.com/watch?v=wCI650TDhHA&list=PLpwc3ughKbZfkSPko3azFD4dd4IHSiQeE&ab_channel=jmbiv) channel, but I only used it to initiate the project. After that, I added the story, which was based on the video by [Pirula](https://youtu.be/kOywGhvNruU?si=T7NHoe4I9V6MdIIi) about the origin of whales. Although simple, it tells a bit of biology history through fun features. I hope you enjoy it! To play, just access the [Playable](https://github.com/ginocarlo01/Kujira-Museum/tree/main/Playable) folder, extract the file, and run the .exe.

## Project Structure
The repository contains the following folders:

- **fonts/** - Contains all fonts used in the game.
- **items/** - Stores the different items available in the game.
- **npcs/** - Contains NPC data and configurations.
- **npc_pictures/** - Stores NPC sprites.
- **quests/** - Contains information about the game's quests.
- **scenes/** - Includes all scenes.
- **scripts/** - Contains game logic scripts.
- **sfx/** - Includes sound effects used in the game.
- **visual/** - Contains graphical elements for exporting the game.
- **soundtrack/** - Stores the game's soundtrack.
- **voices/** - Contains voice files for dialogues.

## Refactoring the Code
After finishing the game, I realized there was an opportunity to refactor the code and make maintenance easier. Many parts were hardcoded, meaning variables were inserted directly into the code instead of being accessible in the editor. Additionally, for each NPC, I was adding a case in **match**, which was making the code increasingly larger. Besides not following good programming practices, this also affected the work of a Game or Level Designer who would work on the game, as they would have to ask the developer for help with every character or room they wanted to add.

Finally, I structured the code based on the following scripts:
- **Command Processor** - Following SOLID's SRP, this class should have only one responsibility: processing commands. In the game, the player can enter various commands (go, talk, use, etc.). This class analyzes the command, checks its context, and returns a string with the processed command. However, this class does not handle the actual command results (the string value it returns); this is done by other classes such as NPC, Item, Quest, etc. Additionally, the class sends signals for specific commands, such as changing text speed. Previously, text construction and other commands were all handled in this class. Another SOLID principle used here was OCP, as adding new commands is very simple: just add the case in **match** of **process_command** and write the respective function. Inventory, quests, exits, describe, speed, and dream were all new functions compared to the tutorial.
- **Exit** - To connect different **rooms**, I created a script for exits, which have two connections, both leading to different rooms. Additionally, the connection to a room can be locked, either bilaterally or in only one direction. Although this mechanic is not used in the current build, it is already implemented. Functions in this class include:
  - *get_other_room* - Checks the other connected room.
  - *lock_exit_of_room* - Locks the exit in one direction.
  - *is_room_locked* - Checks if the exit is locked.
- **Quest** - To easily organize the game's quests, I used Godot's **Resource** feature, which allowed me to predefine quests with titles and descriptions for later assignment to NPCs.
- **Item** - Again using **Resource**, but this time also including the item type. This is important to differentiate whether an item is a Translator (which unlocks new dialogues) or a Quest Item.
- **Room** - This class also uses **Resource** but is slightly more complex. The room has a name, description, and a specific audio track that plays when the player enters. Additionally, I used the **@tool** feature, allowing editor changes to visually update the room without rebuilding the game. Other attributes include:
  - **exits** - Uses a dictionary where keys are directions (north, south, west, east) and values are **Exit** objects.
  - **npcs** - An array listing all NPCs in the room.
  - **items** - An array listing all items in the room.
  - Text processing is handled here via functions:
    - *get_full_description*
    - *get_room_description*
    - *get_items_description*
    - *get_npcs_description*
    - *get_exits_description*
- **Room Manager** - Determines which items and NPCs are in each room and their connections, ensuring SRP and OCP.
- **Types** - Uses **Autoload**, meaning this class is loaded at game start and can be accessed globally. It stores various universal information such as:
  - **ItemTypes**
  - **SpeedTypes**
  - **SpeedValues**
  - **NPCTypes**
  - Predefined hexadecimal color codes for in-game text.
- **Sound Manager** - Also uses **Autoload**, but for managing SFX, soundtrack, and dialogue sounds. Instead of each class referencing the AudioPlayer, only the Sound Manager does this, ensuring SRP.
- **Player** - This class heavily depends on Command Processor, which is expected in this type of game, and is not a problem. If a processed command requires the inventory, *get_inventory* is called to return all organized items. Despite coupling, the divisions are well-defined.
- **Game** - The game has an Input box for commands. After the user submits a command, a signal is sent to this class, processed by *_on_input_text_submitted*. The text is handled by **Command Processor**, and the result is sent to **Game Info**, which creates the response. The **Game** class orchestrates different game components.
- **Game Info** - Acts as a bridge between the backend and the game's UI. It manages response history with *_delete_history_beyond_limit*. Responses are not preloaded at game start; **Game Info** dynamically creates them via *create_response* and *create_response_with_input*, connecting with **Input Response**.
- **Input Response** - Determines how text appears to the player.
  - *set_text*
  - *_animate_text* - Displays response character by character.
  - *cancel_text_animation* - Stops text animation and instantly fills the response.
  - *set_npc_picture*
  - *_process_all_text* - Processes the response without animation.

## How to Add New Rooms, Characters, Quests, and Items

### Adding a New Room:
1. Open `scenes/game.tscn`.
2. Add a `scenes/room.tscn` object under RoomManager.
3. Modify parameters as needed.
4. Edit `RoomManager.gd` to define items, NPCs, and connections.

### Adding a New Character:
1. Create a new Resource in `NPCs/` with basic settings.
2. Add the corresponding sprite in `NPC_pictures/`.
3. Define behavior and dialogues in the script.


## External Resources:

### Images:

https://kuramatoys.com/horseclaws-kai-kui-yupa-studio-ghibli-laputa-castle-in-the-sky/
https://g1.globo.com/mundo/noticia/2022/12/16/hipopotamo-tenta-engolir-crianca-em-uganda.ghtml
https://jornaldoempreendedor.com.br/destaques/inspiracao/desenvolvendo-sua-mente-forte-como-a-de-um-guerreiro-11-passos-simples/
https://www.em.com.br/internacional/2024/06/6872187-girafa-agarra-bebe-de-2-anos-durante-passeio-em-safari.html
https://aminoapps.com/c/senhor-dos-aneis-o-hobbit/page/item/frodo-bolseiro/K3n4_6WiKID5NZV3g0wZLB5JDJX7bjG3d
https://ortogonline.com/doc/pt_br/OrtogOnLineMag/6/Floresiensis.html
https://www.models-resource.com/nintendo_64/legendofzeldaocarinaoftime/model/589/
https://giventofly.github.io/pixelit/#tryit
https://rogerpayne.com/meet-roger/
https://www.atlasvirtual.com.br/anomalocaris.htm
https://blog.cobasi.com.br/baleia-orca-curiosidades-sobre-a-rainha-dos-mares/
https://pt.wikipedia.org/wiki/Ficheiro:Andrewsarchus_DB.jpg
https://www.autumnacresminipetpigs.com/pet-pigs-common-mistakes-avoid/
https://www.mudchute.org/farm-animals/pigs

### Audio:
https://www.youtube.com/watch?v=ouSUF8hBcnM&ab_channel=Nullfuchs
https://www.youtube.com/watch?v=b_oEDGONSc4&ab_channel=LenaRaine
https://www.youtube.com/watch?v=tYqSewWpzyA&ab_channel=Shinx
https://www.youtube.com/watch?v=qfSJjC8a4GQ
https://www.youtube.com/watch?v=tkuSUN7UCis&ab_channel=analynlazarteblancaflorvlog
https://kenney.nl/assets/category:Audio?sort=update