# Kujira Museum 

## Overview
Este projeto é um jogo desenvolvido na Godot Engine. A ideia foi recriar um jogo no estilo Retro Text Adventure, do início da década de 1980, mas com alguns elementos novos, como música, diversidade de comandos e fotos para NPCs. Para iniciar, me baseei na série de vídeos do canal [jmbiv](https://www.youtube.com/watch?v=wCI650TDhHA&list=PLpwc3ughKbZfkSPko3azFD4dd4IHSiQeE&ab_channel=jmbiv) , mas usei ele apenas para iniciar o projeto. Após isso, adicionei a história, a qual foi baseada no vídeo do [Pirula](https://youtu.be/kOywGhvNruU?si=T7NHoe4I9V6MdIIi) sobre origem das baleias. Apesar de ser simples, ela conta um pouco de história da biologia por meio de features divertidas. Espero que goste ! Para jogar, basta acessar a pasta [Playable](https://www.youtube.com/watch?v=wCI650TDhHA&list=PLpwc3ughKbZfkSPko3azFD4dd4IHSiQeE&ab_channel=jmbiv) e rodar o .exe.

## Project Structure
O repositório contém as seguintes pastas:

- **fonts/** - Contém todas as fontes usadas no jogo.
- **items/** - Armazena os diferentes itens disponíveis no jogo.
- **npcs/** - Contém os dados e configurações dos NPCs.
- **npc_pictures/** - Armazena sprites dos NPCs.
- **quests/** - Contém informações sobre as missões do jogo.
- **scenes/** - Inclui todas as cenas.
- **scripts/** - Contém os scripts da lógica do jogo.
- **sfx/** - Inclui efeitos sonoros utilizados no jogo.
- **visual/** - Contém elementos gráficos para exportar o jogo.
- **soundtrack/** - Armazena a trilha sonora do jogo.
- **voices/** - Contém arquivos de voz para os diálogos.

## Refactoring the Code
Depois de terminar o jogo, percebi que havia uma oportunidade para refatorar o código e facilitar na manutenção. Havia muitos partes hard coded, ou seja, com a variável inserida diretamente no código ao invés de ser acessível no editor. Ademais, para cada NPC estava adicionando um caso no **match**, o que estava fazendo o código ficar cada vez maior. Além de isso não estar de acordo com as boas práticas de programação, afeta também o trabalho de um Game ou Level Designer que trabalharia no jogo, visto que o mesmo teria que pedir ajuda ao desenvolvedor para cada personagem ou sala que desejasse adicionar. 

Por fim, organizei a estrutura baseada nos seguintes scripts:
- **Command Processor/** - Seguindo o SRP do SOLID, essa classe deve ter apenas uma responsabilidade: processar os comandos. No jogo, o player pode inserir vários comandos (ir, falar, usar, etc). Essa classe vai analisar o comando, verificar em qual situação ele se encaixa e retornar um string com o comando de volta. A classe, porém, não tem o resultado os resultados dos comandos (o valor da string que irá retornar): isso é feito pelas outras classes que veremos abaixo, como NPC, Item, Quest, etc. Ademais, a classe também envia signals para comandos específicos, como por exemplo alterar a velocidade texto. Previamente, a construção do texto e outros comandos eram todos feitos nesta classe. Outro conceito do SOLID usado aqui foi o OCP, já que adicionar novos comandos é muito simples: basta adicionar o caso no **match** de **process_command** e escrever a respectiva função. Inventário, missões, saídas, descrever, velocidade e sonhar foram todas funções inéditas comparadas ao tutorial.

## Overview do Mapa
O mapa do jogo é estruturado em diversas áreas interconectadas, cada uma com suas próprias características, NPCs e desafios. Algumas características do mapa incluem:

- **Zonas exploráveis**: Áreas distintas que os jogadores podem visitar.
- **Interações com NPCs**: Algumas zonas contêm personagens que oferecem missões ou itens.
- **Segredos e desafios**: Algumas áreas podem conter puzzles ou itens ocultos.

## Como Adicionar Novas Salas, Personagens e Itens
### Adicionando uma nova sala:
1. Crie uma nova cena na pasta `scenes/`.
2. Adicione os elementos necessários (paredes, portas, objetos interativos).
3. Conecte a sala a outras através de nós `Area2D` e `CollisionShape2D`.
4. Atualize os scripts de transição caso necessário.

### Adicionando um novo personagem:
1. Crie um novo arquivo na pasta `npcs/` com as configurações básicas.
2. Adicione a sprite correspondente em `npc_pictures/`.
3. Defina o comportamento e os diálogos no script correspondente.
4. Configure a posição inicial do NPC dentro de uma cena.

### Adicionando um novo item:
1. Crie um novo arquivo de item na pasta `items/`.
2. Adicione uma sprite correspondente em `visual/`.
3. Configure suas propriedades no sistema de inventário.
4. Defina onde e como o item pode ser obtido no jogo.

---
Este README será atualizado conforme o desenvolvimento do projeto avança.

