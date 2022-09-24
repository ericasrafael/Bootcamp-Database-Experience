--
-- PROJETO LÓGICO DE BANCO DE DADOS ( E-COMMERCE )
--

-- criação do banco de dados
create database if not exists ecommerce;
-- drop database ecommerce;
-- show databases;
use ecommerce;
show tables;

-- criação das tabelas 

-- cliente
-- cliente não possui FK no modelo relacional, visto que ela se relaciona somente com pedido em cardinalidade 1:N
-- PK de cliente se tornará FK de pedido ( cliente faz 1 ou mais pedidos, pedido pertence a somente 1 cliente )
-- cliente pode ser: pessoa física , pessoa jurídica
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(20),
    Minit char(3),
    Lname varchar(20),
    rua varchar(30),
    N int,
    bairro varchar(20),
    cidade varchar(20),
    CEP int(8),
    UF char(2)
);

alter table clients auto_increment=1;

create table client_cpf(
	idClient_CPF int auto_increment primary key,
    idClient int,
    CPF VARCHAR(11) not null,
    constraint fk_client_cpf foreign key (idClient) references clients(idClient),
    constraint unique_cpf_client unique(CPF)
);

alter table client_CPF auto_increment=1;

create table client_cnpj(
	idClient_CNPJ int auto_increment primary key,
    idClient int,
    CNPJ VARCHAR(15) not null,
    SocialName varchar(255) not null, 
    constraint fk_client_cnpj foreign key (idClient) references clients(idClient),
    constraint unique_cnpj_client unique(CNPJ)
);

alter table client_CNPJ auto_increment=1;


-- desc clients;

-- produto
-- size = dimensão do produto

create table products(
	idProduct int auto_increment primary key,
    Pname varchar(50) not null,
    classification_kids bool default false,
    value_of_product float,
    category enum('Eletrônicos','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(20)
);

alter table products auto_increment=1;

-- payment
-- REFINAMENTO: forma de pagamento, cada forma possui atributos específicos
-- esecializar: cada subclasse vira uma entidade, e recebe uma FK da classe genérica
-- um pedido possui 1 forma de pagamento, e uma forma de pagamendo pode estar associada a vários pedidos 

-- classe genérica

create table payments(
    idPayment int,
    primary key(idPayment)
);

alter table payments auto_increment=1;

-- subclasses: pix, boleto, cartão de crédito

create table payment_boleto(
    idBoleto int auto_increment,
    idPayment int,
    codigo int(50),
    primary key(idBoleto),
    constraint fk_payment_boleto foreign key (idPayment) references payments(idPayment)
);
create table payment_cartao(
    idCartao int auto_increment,
    idPayment int,
    banco varchar(50),
    CCV INT(20),
    validade date,
    conta int(20) unique not null,
    primary key(idCartao),
    constraint fk_payment_cartao foreign key (idPayment) references payments(idPayment)
);
create table payment_pix(
    idPix int auto_increment,
    idPayment int,
    chave varchar(45) not null unique,
    primary key(idPix),
    constraint fk_payment_pix foreign key (idPayment) references payments(idPayment)
);

-- pedido
-- possui: 1 e apenas 1 cliente , 1 ou mais produtos

create table orders(
	idOrder int auto_increment primary key,
    idClient int,
    orderstatusc enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10, 
    idPayment int, 
    constraint fk_orders_client foreign key (idClient) references clients(idClient),
    constraint fk_orders_payment foreign key (idPayment) references payments(idPayment)
);

-- estoque
-- cada id relacionado a uma localidade de estoque
create table storages(
	idStorage int auto_increment primary key,
    storageLocation varchar(255) not null
);

-- OBS: EM COMUM FORNECEDOR E VENDEDOR
-- refinar : especializar : supplier e seller
-- fornecedor

create table suppliers(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    CONSTRAINT unique_supplier_cnpj unique(CNPJ)
);

-- desc suppliers;

-- vendedor
-- REFINAR: cnpj - cpf - especialização
create table sellers(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    location varchar(255),
    CONSTRAINT unique_seller_cnpj unique(CNPJ)
);

-- TABELAS RELATIONSHIP N:M
-- PK das tabelas do relacionamento vão para a tabela gerada, como FK, estas geram sua PK composta

-- produtos vendidos por 1 ou mais vendedores, vendedor vende 1 ou mais produtos
create table product_seller(
	idSeller int,
    idProduct int,
    Quantity int default 1,
    primary key(idSeller,idProduct),
    constraint fk_product_seller foreign key(idSeller) references sellers(idSeller),
	constraint fk_product_product foreign key(idProduct) references products(idProduct)
);

-- desc product_seller;

-- pedidos solicitam 1 ou mais produtos, produto solicitados por 1 ou mais pedidos
create table product_order(
	idOrder int,
    idProduct int,
    Quantity_sold int default 1,
    primary key(idOrder,idProduct),
    constraint fk_product_order_order foreign key(idOrder) references orders(idOrder),
	constraint fk_product_order_product foreign key(idProduct) references products(idProduct)
);

-- estoque armazena 1 ou mais produtos, produto pode está armazenado em 1 ou mais localizações de estoque
create table product_storage(
	idStorage int,
    idProduct int,
    quantity int,
    primary key(idStorage,idProduct),
    constraint fk_product_storage_storage foreign key(idStorage) references storages(idStorage),
	constraint fk_product_storage_product foreign key(idProduct) references products(idProduct)
);

create table product_supplier(
	idSupplier int,
    idProduct int,
    quantity int not null,
    primary key(idSupplier,idProduct),
    constraint fk_product_supplier_supplier foreign key(idSupplier) references suppliers(idSupplier),
	constraint fk_product_supplier_product foreign key(idProduct) references products(idProduct)
);

-- esquema BD armazenado como tabela no MySQL

-- show databases;   -- 'information_schema'
-- use information_schema;
-- show tables;
-- select  *  from  information_schema.table_constraints where constraint_schema = 'ecommerce' ;


-- insertion of values 

use ecommerce;

insert into clients 
(Fname, Minit, Lname,  rua, N, bairro, cidade, CEP, UF)
values
('Maria','M','Silva','Rua Silva de Prata',29,'Cangola','Cidade das Flores','64600344','RJ'),
('Matheus','O','Pimentel','Rua Almeida',289,'Centro','Cidade das Flores','61600000','RJ'),
('Ricardo','F','Silva','Avenida Almeida Vinha',1009,'Centro','Cidade das Flores','61600111','RJ'),
('Julia','S','França','Rua Lareiras',861,'Centro','Cidade das Flores','61600222','RJ'),
('Roberta','G','Assis','Avenida Koller',19,'Centro','Cidade das Flores','61600333','RJ'),
('Isabela','M','Cruz','Rua Almeida das Flores',28,'Cangola','Cidade das Flores','64600000','RJ'),
('Coca Cola','I','LTDA','Rua Estação Central',111,'Central','São Paulo','60000000','SP'),
('Apple Computer','S','LTDA','Rua Porto Seguro',89,'Rainha Isabela II','São Paulo','60000001','SP');

select * from clients;

insert into client_CPF(idClient, CPF)
values
(1,'123456789'),
(2,'987654321'),
(3,'456789130'),
(4,'789123456'),
(5,'987456310'),
(6,'654789123');

insert into client_CNPJ(idClient, CNPJ, SocialName)
values
(7,'45997418000153','Coca Cola Indústrias Ltda'),
(8,'65478912300000','Apple Brasil');

select * from client_CNPJ;

insert into products(Pname, classification_kids, value_of_product, category, avaliação, size)
values
('Fone de Ouvido',FALSE,150.67,'Eletrônicos',4,NULL),
('Barbie Elsa',TRUE,50.99,'Brinquedos',3,NULL),
('Body Carters',TRUE,10,'Vestimenta',5,NULL),
('Microfone Vedo - Youtuber',FALSE,150.67,'Eletrônicos',4,NULL),
('Sofá Retrátil',FALSE,360.89,'Móveis',3,'3X57X80'),
('Farinha de Arroz',FALSE,20.50,'Alimentos',2,NULL),
('Fire Stick Amazon',FALSE,40,'Eletrônicos',3,NULL);

select * from products;


-- cada pedido, uma forma de pagamento, 4 pedidos, 4 formas de pagamento
insert into payments(idPayment) values (1),(2),(3),(4);

select * from payments;

insert into payment_boleto(idPayment, codigo) values (1, 7668146), (3, 5545545);
insert into payment_cartao(idPayment,banco,CCV,validade, conta) values (2, 'Banco do Brasil',321,'2023-08-10',000123456);
insert into payment_pix (idPayment, chave) values (4, 'Julis.France@gmail.com');

insert into orders(idClient, orderstatusc, orderDescription, sendValue, idPayment)
values
(1,default, 'Compra Via Aplicativo', default, 1),
(2, default, 'Compra Via Aplicativo', 50, 2),
(3, 'Confirmado', default, default, 3),
(4, default, 'Compra Via Web Site', 150.66, 4);

select * from orders;

-- quantidade de produtos solicitados em cada pedido
insert into product_order(idOrder,idProduct, Quantity_sold) values (1,1,2),(1,2,1),(2,3,4);

insert into storages( storageLocation )
values 
('Rio de Janeiro'),
('São Paulo' ),
('Brasília' );

select * from  storages;

insert into product_storage( idStorage, idProduct, quantity )
values 
(1,1,1000),
(2,3,500),
(3,4,500),
(3,7,150),
(3,5,700),
(3,2,800),
(3,6,1000);

select * from  product_storage;

insert into suppliers( SocialName , CNPJ, contact)
values 
('Almeida e Filhos',123456789123456,'21985474'),
('Eletrônicos Silva',123456789123489,'21986544'),
('Eletrônicos Valma',176346789123489,'22076544');

select * from  suppliers;

insert into product_supplier( idSupplier , idProduct , quantity )
values 
(1,1,500),
(1,2,400),
(2,4,633),
(3,3,5),
(2,5,10);

select * from  product_supplier;

insert into sellers( SocialName , CNPJ, contact, location )
values 
('Tech Eletronicos', 123456789456321, 219946287, 'Rio de Janeiro'),
('Boutique Durgas', 123456785286321, 219818287, 'Rio de Janeiro'),
('Kids World', 123851389456321, 914546287, 'São Paulo');

select * from  sellers;

insert into product_seller( idSeller, idProduct, Quantity )
values 
(1, 6, 80 ),
(2, 7, 10 );

select * from  product_seller;

-- número de clientes

select count(*) from clients;

-- pedidos dos clientes

select * from clients c, orders o where c.idClient = o.idClient; -- onde id cliente está em pedidos

insert into orders(idClient, orderstatusc, orderDescription, sendValue, idPayment) values (2,default, 'Compra Via Aplicativo', default, 1);
insert into payments values(5);
insert into payment_cartao(idPayment,banco,CCV,validade, conta) values (5, 'CAIXA',001,'2023-05-12',000198654);

select * from product_order; -- products orders

-- somente clientes que fizeram pedidos, contagem de pedidos
select * from payment_boleto;
select Fname, c.idClient, count(*) as number_of_orders from clients c 
join orders o using(idClient)
join product_order po using(idOrder)
group by c.idClient;

-- clientes e seus produtos comprados por boleto
select *
from orders o 
left join payments p using(idPayment)
left join payment_boleto pb using(idPayment)
left join clients c using(idClient)
;



select * from payments 
left join payment_boleto using(idPayment)
left join payment_cartao using(idPayment)
left join payment_pix using(idPayment);

select * from payment_cartao












