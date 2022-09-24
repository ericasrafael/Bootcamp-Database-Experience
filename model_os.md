#  Modelagem Conceitual -  OS de Oficina Mecânica

- Modelagem puramente conceitual 


![Diagrama sem nome drawio](https://user-images.githubusercontent.com/91800929/190407762-79ca83dd-d20c-4903-96f8-a4840ebb9c60.png)


- Modelagem EER


![model-EER-OS](https://user-images.githubusercontent.com/91800929/192072204-4eb83dde-79ab-48dc-a66f-1d3b9958d3bd.png)

### Descrição da Modelagem Conceitual:

Neste projeto, tem-se o escopo de gerenciamento de Ordem de Serviço de uma Oficina Mecânica;
Foi gerado um levantamento de requisitos, com o fito de gerar um cenário que mais faz referência com o mini-mundo:

Narrativa:
- Sistema de controle e gerenciamento de execução de ordens de serviço em uma oficina mecânica
- Clientes levam veículos à oficina mecânica para serem consertados ou para passarem por revisões  periódicas
- Cada veículo é designado a uma equipe de mecânicos que identifica os serviços a serem executados e preenche uma OS com data de entrega.
- A partir da OS, calcula-se o valor de cada serviço, consultando-se uma tabela de referência de mão-de-obra
- O valor de cada peça também irá compor a OSO cliente autoriza a execução dos serviços
- A mesma equipe avalia e executa os serviços
- Os mecânicos possuem código, nome, endereço e especialidade
- Cada OS possui: n°, data de emissão, um valor, status e uma data para conclusão dos trabalhos.

Passos:
- Foram criadas, preliminarmente, as entidades: Cliente, Mecânico, Veículo, OS(Ordem de Serviço), Peças e Serviços - As duas últimas foram criadas 
  pelo fato do requisito especificar que uma ordem de serviço pode conter mais de um serviço e peça;
- Foi gerado um fluxo que resultasse que cada identificador das entidades estivesse contida na tabela de OS;
- Existem atrubutos específicos para cada tipo de serviço, como valor de mão de obra. Por esse motivo, foi gerada uma especialização de serviço,
  dessa forma, cada subclasse, que seria cada tipo de serviço fornecido, teria seus atributos específicos;



