#  Modelagem Conceitual - Refinamento E-commerce 
![img drawio](https://user-images.githubusercontent.com/91800929/190312323-9e635919-eb7b-4491-98c5-36284f9ebdbe.png)
![image](https://user-images.githubusercontent.com/91800929/191736176-09842f1f-e912-46ca-b3aa-9f3f6b960afd.png)

### Descrição da Modelagem Conceitual:

Tem-se um escopo de Venda de Produtos na primeira etapa do projeto de Banco de Dados;
Foi gerado um levantamento de requisitos, com o fito de gerar um cenário que mais faz referência com o mini-mundo, com a seguinte narrativa:

* Os produtos são vendidos em uma única plataforma online, podendo estes ter vendedores distintos ( terceirizados ).
*  Cada produto possui um fornecedor.
*  Um pedido pode conter um ou mais produtos.
*  Um cliente pode se cadastrar com seu CPF ou CNPJ;
*  O endereço do cliente gera o valor de frete;
*  Um cliente pode efetuar mais de um pedido. Este com um período de carência para devolução.
*  Pedidos possuem informações de compra, endereço e status de entrega;
*  Pedido pode ser cancelado;

Passos:
- Foram criadas, preliminarmente, as entidades: Produto, Pedido, Estoque, Fornecedor;
- Forma de pagamento geraria um atributo multivalorado na tabela Clientes, pois um cliente pode ter mais de uma forma de pagamento registrada.
  Por conta disso, foi gerada uma nova entidade "Pagamento",que no modelo Relacional receberá como Chave Estrangeira o identificador do cliente;
- O tipo de conta cadastrada foi implementada no modelo como um atributo de cliente (CNPJ ou CPF)
- Foi gerada uma entidade fraca "Entrega" relacionada com pedido, pois depende do fato do pedido não ser cancelado para ser efetivada;
- Uma entidade Terceiros foi criada para dar ênfase aos vendedores terceirizados;
- Cada produto se enquadra em uma categoria, apesar de poder ser gerada como atributo de Produto, foi implementada como uma entidade;
- Frete é um atributo derivado, visto que depende do endereço do cliente para ser calculado;
