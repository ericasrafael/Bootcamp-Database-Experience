--
-- PROJETO LÓGICO DE BANCO DE DADOS ( ORDEM DE SERVIÇO DE OFOCINA MECÂNICA )
--

create database if not exists workshop;
use workshop;

create table cliente(
	idCliente int auto_increment primary key,
    nome varchar(20),
    sobrenome varchar(20),
    rua varchar(30),
    numero int,
    bairro varchar(20),
    cidade varchar(20),
    UF char(2)
);

alter table cliente auto_increment=1;

insert into cliente 
(nome, sobrenome, rua, numero, bairro, cidade, UF) values
('Maria','Silva','Rua Silva de Prata',29,'Cangola','Cidade das Flores','RJ'),
('Matheus','Pimentel','Rua Almeida',289,'Centro','Cidade das Flores','RJ'),
('Ricardo','Silva','Avenida Almeida Vinha',1009,'Centro','Cidade das Flores','RJ'),
('Julia','França','Rua Lareiras',861,'Centro','Cidade das Flores','RJ'),
('Roberta','Assis','Avenida Koller',19,'Centro','Cidade das Flores','RJ'),
('Isabela','Cruz','Rua Almeida das Flores',28,'Cangola','Cidade das Flores','RJ'),
('Coca Cola','LTDA','Rua Estação Central',111,'Central','São Paulo','SP'),
('Apple Computer','LTDA','Rua Porto Seguro',89,'Rainha Isabela II','São Paulo','SP');

create table cliente_fisico(
    CPF char(11) not null,
    idCliente int,
    constraint fk_cpf_client foreign key (idCliente) references cliente(idCliente),
    constraint unique_cpf_client unique(CPF)
);

select * from cliente; -- somente id 7 e 8 clientes CNPJ

insert into cliente_fisico 
(idCliente, CPF) values
(1,'123456789'),
(2,'987654321'),
(3,'456789130'),
(4,'789123456'),
(5,'987456310'),
(6,'654789123');


create table cliente_juridico(
    CNPJ char(15) not null,
    razao_social varchar(45),
    idCliente int,
    constraint fk_cnpj_client foreign key (idCliente) references cliente(idCliente),
    constraint unique_cnpj_client unique(CNPJ)
);

insert into cliente_juridico(idCliente, CNPJ, razao_social) values
(7,'45997418000153','Coca Cola Indústrias Ltda'),
(8,'65478912300000','Apple Brasil');

-- tabela contatos_cliente = atributo multivalorado de cliente
-- cliente pode ter mais de um contato, e um contato pode ser cadastrado mais de uma vez, porém para clientes distintos

create table contatos_cliente(
    telefone varchar(45) not null,
    idCliente int, 
    primary key(idCliente,telefone),
    constraint fk_contato_client foreign key (idCliente) references cliente(idCliente)
);

insert into contatos_cliente (telefone , idCliente ) values
('987654789',1),
('987654789',2),
('987656789',3),
('998754789',4),
('987654620',5),
('987735789',6),
('987658369',7),
('987657359',8),
('987654790',1),
('987600090',5);

create table mecanico(
	idMecanico int primary key auto_increment,
    nome varchar(45),
    rua varchar(45),
    numero int,
    bairro varchar(45),
    cidade varchar(45),
    UF char(2),
    especialidade varchar(45)
);

insert into mecanico 
(nome, rua, numero, bairro, cidade, UF, especialidade ) values
('Mauro Ribeiro','Rua Silva',100,'Cangola','Cidade das Flores','RJ','Calibrador'),
('Jose Neto Assis','Rua Jojo de Ouro',367,'Centro','Cidade das Flores','RJ','Checa Motor'),
('Marcos Andrade','Avenida Pinhozinho',7485,'Centro','Cidade das Flores','RJ','Troca Peças'),
('Romulo Lopes Santos','Rua Limoeiro',825,'Centro','Cidade das Flores','RJ','Troca Óleo'),
('Francisco Filho','Avenida Santos Dummonteiro',888,'Centro','Cidade das Flores','RJ','Manutenção Diária'),
('Sanzio Ferreira','Rua Ricardo San Lima',878,'Cangola','Cidade das Flores','RJ','Pintor de Veículos'),
('Breno Marcos Sousa','Rua Estação Central',222,'Central','São Paulo','SP','Revião Geral'),
('Felipe Lima Matos','Rua Potira',890,'Rainha Isabela II','São Paulo','SP','Conserto Geral');

create table peça(
	idPeça int primary key auto_increment,
    nome varchar(45) not null unique,
    valor_da_peça float
);

insert into peça (nome, valor_da_peça ) values
('Velas de ignição',50.90),
('Filtro de óleo',87.65),
('Pistão',30.50),
('Caixa de câmbio',300),
('Bateria de moto',400),
('Pastilhas dos freios',150.0),
('Embreagem',150.0),
('Correntes',70.50),
('Pneus',200);

create table veiculo(
	idVeiculo int primary key auto_increment,
    modelo varchar(45),
    placa varchar(45),
    idCliente int,
    idMecanico int,
    constraint fk_veiculo_cliente foreign key (idCliente) references cliente(idCliente),
    constraint fk_veiculo_mecanico foreign key (idMecanico) references mecanico(idMecanico)
);

insert into veiculo (modelo, placa, idCliente, idMecanico) values
('Renault Logan Life 1.0 flex manual 5 marchas','BR2E193',3,1),
('Honda City Hatch EXL 1.5 flex CVT','BRA0176',2,3),
('Honda City EX 1.5 flex CVT','OTM2022',4,5),
('Fiat Mobi Like 1.0 flex manual 5 marchas','BRA7S19',3,7),
('Fiat Cronos 1.3 flex manual 5 marchas','HQW5678',5,4),
('Volkswagen Gol 1.0 flex manual 5 marchas','GFZ0011',1,6),
('Honda Biz 110','ABC1234',1,7),
('Honda Pop 110','MMM0000',6,8),
('Scania R500','ERM9864',7,7),
('Volvo FH 540','UIO82563',8,8);

create table os(
	idOs int primary key auto_increment,
    data_emissao varchar(45),
    valor_total_estimado varchar(45),
    data_conclusao varchar(45),
    status_serviço enum('Não Iniciado','Em Andamento','Cancelado pelo Cliente','Concluído') default 'Em Andamento' ,
	idVeiculo int,
    constraint fk_os_veiculo foreign key (idVeiculo) references veiculo(idVeiculo),
    constraint data_conlusao_os check (data_conclusao >= data_emissao)
);

insert into os (data_emissao, valor_total_estimado, data_conclusao, status_serviço, idVeiculo ) values
('2022-02-01',250.0,'2022-02-02','Concluído', 1),
('2022-09-23',300,'2022-09-25',default, 4),
('2022-03-01',100,'2022-03-02','Concluído', 2),
('2022-04-01',150.80,'2022-04-02','Cancelado pelo Cliente', 3),
('2022-05-01',345.98,'2022-05-02','Cancelado pelo Cliente', 4),
('2022-05-01',100.50,'2022-05-02','Concluído', 6),
('2022-09-23',250.0,'2022-09-25',default, 5),
('2022-07-01',145.50,'2022-07-02','Concluído', 7),
('2022-02-01',200,'2022-02-02','Concluído', 8),
('2022-08-01',100,'2022-08-02','Concluído', 7),
('2022-09-24',500,'2022-09-27','Não Iniciado', 9),
('2022-09-23',400,'2022-09-25',default, 10);

create table peças_os(
	idOs int,
    idPeça int,
    quantidade int not null,
    primary key(idos,idPeça),
	constraint fk_OP_os foreign key (idOs) references os(idOs),
    constraint fk_OP_peça foreign key (idPeça) references peça(idPeça)
);

insert into peças_os (idOs, idPeça, quantidade ) values
(1,3,1),
(2,6,1),
(3,3,1),
(4,3,2),
(5,9,4),
(6,3,2),
(7,8,1),
(8,5,1),
(9,3,2),
(10,4,1),
(10,2,2),
(9,9,4),
(7,7,1),
(5,1,1),
(2,3,1);

-- valores tabelados de cada serviço - manter subclasses
-- superclasse serviços não tinha atributos generalizados

create table os_revisao(
	idOs int not null,   -- chave da superclasse
    descriçao varchar(45) not null,
	mao_de_obra float not null default 10,
    primary key(idOs,descriçao),
    constraint fk_revisao_os foreign key (idOs) references os(idOs)
);

insert into os_revisao( idOs, descriçao, mao_de_obra ) values 
(1, 'Troca de Pistão', 20 ),
(2, 'Troca de Pistão', 20 ),
(3, 'Colocar Pastilhas de Freios', default),
(3, 'Troca de Pistão', 10 ),
(6, 'Troca de Pistão', 20 ),
(11, 'Troca de Filtro de Oleo', 10 ),
(12, 'Troca de Pneus', 50 );

create table os_conserto(
	idOs int,  -- chave da superclasse
    descriçao varchar(45),
	mao_de_obra float not null,
    primary key(idOs,descriçao),
    constraint fk_conserto_os foreign key (idOS) references os(idOs)
);

insert into os_conserto( idOs, descriçao, mao_de_obra ) values 
(10, 'Conserto Filtro de óleo', 60 ),
(8, 'Conserto Embreagem', 20 ),
(7, 'Conserto Filtro de óleo', 20 ),
(8, 'Conserto Freios', 20 ),
(11, 'Conserto Volante', 50 );

select * from os; -- veiculo
select * from mecanico; 
select * from veiculo; 
select * from peça;
select * from peças_os;
select * from os_conserto;
select * from os_revisao;
select * from cliente;

select * from cliente 
join veiculo using(idCliente) 
join os using(idVeiculo)
where status_serviço like '%Cancelado%';


-- cliente e mecânicos de serviços cancelados

select concat( c.nome,' ', c.sobrenome ) nome_cliente,
	   m.nome as nome_mecanico, modelo
from mecanico m
join veiculo using(idMecanico)
join os using(idVeiculo)
join cliente c using(idCliente)
where status_serviço like '%Cancelado%';

-- serviços e tipo de cliente que não necessitaram de peças

select *
from os o
where not exists (	select * from peças_os as po where o.idOs = po.idOs ); 

-- listando quantos veículos tem cada cliente 

select 
concat(nome,' ',sobrenome) cliente,
count(*) as numero_de_veiculos
from cliente
left join veiculo using(idCliente)
group by nome
order by numero_de_veiculos desc;

-- comparação valor estimado e valor real cobrado ao cliente 

select 
concat(c.nome,' ',c.sobrenome) as Cliente,
o.idOs,
v.modelo,
o.valor_total_estimado, 
round((quantidade*valor_da_peça + (coalesce(ore.mao_de_obra , 0) + coalesce(oco.mao_de_obra,0))),2) as Valor
from veiculo v 
join os o using(idVeiculo)
join peças_os po using(idOs)
join peça p using(idPeça)
join cliente c using(idCliente)
left join os_revisao ore using(idOs)
left join os_conserto oco using(idOs)
where o.status_serviço not in ('Cancelado pelo Cliente')
group by o.idOs;



