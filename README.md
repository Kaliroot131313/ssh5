Este script em bash é uma ferramenta de verificação de portas em hosts IP. Ele oferece opções para verificar diferentes tipos de portas, como portas manuais, portas de câmeras, servidores de arquivos, acesso remoto e serviços diversos. Além disso, permite a busca manual de IP e portas.

O usuário escolhe uma opção e, dependendo da escolha, pode inserir manualmente uma porta ou usar configurações predefinidas para tipos específicos de portas. Para a busca manual, o usuário pode especificar um endereço IP e uma porta, com a opção de usar o IP local.

O script então pergunta sobre a quantidade mínima de hosts abertos a serem exibidos e se deseja buscar por IPs próximos à região do usuário. Ele usa o comando nmap para verificar a abertura de portas em hosts aleatórios. Se a opção de busca por região estiver ativada, ele utiliza o serviço de obtenção de IP externo para determinar a região.

Os resultados são exibidos em uma tabela com endereços IP, portas testadas e portas abertas. Além disso, para hosts com portas abertas, é aberto um terminal com detalhes adicionais usando o comando nmap.

O script enfatiza a importância do uso ético e responsável, indicando que a ferramenta deve ser usada de maneira consciente e legal. O uso indevido para invasões ou atividades maliciosas é expressamente desencorajado
