create database if not exists company;

show databases;

use company;
show tables;

select * from information_schema.table_constraints
	where constraint_schema = 'company';

create table employee (
	fname varchar(20) not null,
    minit char,
    lname varchar(20) not null,
    ssn char(9) not null,
    birth_date date,
    address varchar(50),
    sex char,
    salary decimal(10,2),
    super_ssn char(9),
    dno int not null,
    constraint check_salary_employee check (salary > 2000.0),
    primary key (ssn)
);

-- adicionando chave estrangeira a employee referente aos supervisores de cada funcionário
-- obs: os empregados que são supervisores não possuem supervisores neste contexto, ou seja, super_ssn é nulo para eles

alter table employee 
	add constraint fk_employee_super_ssn 
	foreign key(super_ssn) references employee(ssn)
    on delete set null
    on update cascade;
    
alter table employee modify dno int not null default 1;

desc employee;

create table department (
	dname varchar(20) not null unique,
    dnumber int not null,
    mgr_ssn char(9) not null,
    mgr_start_date date not null,
    dept_create_date date not null,
    constraint check_create_date check (dept_create_date < mgr_start_date),
    primary key (dnumber),
    constraint fk_mgr_ssn foreign key (mgr_ssn) references employee(ssn)
);

desc department;

create table dept_locations (
	dnumber int not null,
    dlocation varchar(20) not null,
    primary key (dnumber,dlocation),
    constraint fk_dept_locations foreign key (dnumber) references department(dnumber)
);

desc dept_locations;

create table project (
	pname varchar(20) not null unique,
    pnumber int not null,
    plocation varchar(20),
    dnum int not null,
    primary key (pnumber),
    constraint fk_project_dept foreign key (dnum) references department(dnumber)
);

desc project;

create table works_on (
	essn char(9) not null,
    pno int not null,
    hours decimal(3,1) not null,
    primary key(essn,pno),
    constraint fk_employee foreign key (essn) references employee(ssn),
    constraint fk_project foreign key (pno) references project(pnumber)
);

desc works_on;

create table dependent (
	essn char(9) not null,
	dname varchar(20) not null,
    sex char,
    birth_date date,
    relationship varchar(10),
    primary key (essn, dname),
    constraint fk_dependent foreign key (essn) references employee(ssn)
);

desc dependent;

use company;
show tables;

-- obs: super_ssn deve já está cadastrado como employee antes de ser inserido como super_ssn
insert into employee values ('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, null, 5);

insert into employee values	('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 123456789, 5),
                            ('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 333445555, 4),
                            ('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, null, 4),
                            ('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 987654321, 5),
                            ('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5),
                            ('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 123456789, 4),
                            ('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

select * from employee;

insert into dependent values (333445555, 'Alice', 'F', '1986-04-05', 'Daughter'),
							 (333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
                             (333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
                             (987654321, 'Abner', 'M', '1942-02-28', 'Spouse'),
                             (123456789, 'Michael', 'M', '1988-01-04', 'Son'),
                             (123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
                             (123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');
                             
select * from dependent;

insert into department values ('Research', 5, 333445555, '1988-05-22','1986-05-22'),
							   ('Administration', 4, 987654321, '1995-01-01','1994-01-01'),
                               ('Headquarters', 1, 888665555,'1981-06-19','1980-06-19');
select * from department;

insert into dept_locations values (1, 'Houston'),
								 (4, 'Stafford'),
                                 (5, 'Bellaire'),
                                 (5, 'Sugarland'),
                                 (5, 'Houston');
                                 
select * from dept_locations;

insert into project values ('ProductX', 1, 'Bellaire', 5),
						   ('ProductY', 2, 'Sugarland', 5),
						   ('ProductZ', 3, 'Houston', 5),
                           ('Computerization', 10, 'Stafford', 4),
                           ('Reorganization', 20, 'Houston', 1),
                           ('Newbenefits', 30, 'Stafford', 4);
select * from project;
                           
insert into works_on values (123456789, 1, 32.5),
							(123456789, 2, 7.5),
                            (666884444, 3, 40.0),
                            (453453453, 1, 20.0),
                            (453453453, 2, 20.0),
                            (333445555, 2, 10.0),
                            (333445555, 3, 10.0),
                            (333445555, 10, 10.0),
                            (333445555, 20, 10.0),
                            (999887777, 30, 30.0),
                            (999887777, 10, 10.0),
                            (987987987, 10, 35.0),
                            (987987987, 30, 5.0),
                            (987654321, 30, 20.0),
                            (987654321, 20, 15.0),
                            (888665555, 20, 0.0);
select * from works_on;

-- EXECUTANDO ALGUMAS QUERIES

-- gerente e departamento que supervisiona 
select ssn, fname, dname 
from employee e, department d 
where (e.ssn = d.mgr_ssn);

-- dependentes dos empregrados
select fname, dname, relationship 
from employee, dependent 
where essn = ssn;

select birth_date, address 
from employee
where fname = 'John' and minit='B' and lname='Smith';

-- departamento específico
select * 
from department 
where dname = 'Research';

select fname, lname, address, dname -- nome, sobrenome e endereço do empregado
from employee, department
where dname='Research' and dnumber=dno; -- que trabalha em determinado departamento = Research

select pname, essn, fname, hours  -- nome dos projeto, id dos funcionários que trabalham nos projetos, nomes deles, e horas trabalhadas nos projetos
from project, works_on, employee 
where pnumber = pno and essn = ssn;


-- Expressões e concatenação de strings

-- departamentos presentes em Stafford e id dos seus gerentes
select dname as Department_Name, -- department
	   mgr_ssn as Manager, 		 -- employee
       address 					 -- employee
from department d, dept_locations l, employee e
where d.dnumber = l.dnumber 
and dlocation='Stafford'; -- dept_locations

-- recuperando todos os gerentes que trabalham em Stafford
select dname as Department_Name, 			 -- department 
	   concat(Fname, ' ', Lname) as Manager  -- employee
from department d, dept_locations l, employee e
where d.dnumber = l.dnumber -- linkando department com locations
and dlocation='Stafford' -- dept_locations
and mgr_ssn = e.ssn;  -- os empregados devem ser gerentes

-- recuperando todos os gerentes, seus departamentos e seus nomes
select dname as Department_Name, 
		concat(fname, ' ', lname) as Manager, 
		dlocation  
from department d, dept_locations l, employee e
where d.dnumber = l.dnumber 
and mgr_ssn = e.ssn;

select pnumber, dnum, lname, address, birth_date 
from department d, project p, employee e
where d.dnumber = p.dnum 
and p.plocation='Stafford' 
and mgr_ssn = e.ssn;

SELECT * FROM employee WHERE dno IN (1,5);

select * from department where dname = 'Research' or dname = 'Administration';

select birth_date, address 
from employee 
where fname='John' 
and minit='B' 
and lname='Smith';

-- recolhendo o valor do INSS
select fname, lname, salary, salary*0.011 as INSS from employee;
select fname, lname, salary, round(salary*0.011,2) as INSS from employee;

select * 
from employee e, works_on as w, project as p
where (e.ssn = w.essn and w.pno=p.pnumber);

select concat(fname, ' ', lname) as Complete_name, 
		salary, 
		salary*1.1 as increased_salary
from employee e, works_on as w, project as p
where (e.ssn = w.essn and w.pno=p.pnumber and p.pname='ProductX');

-- definir um aumento de salário para os gerentes que trabalham no projeto associado ao ProdutoX
select concat(fname, ' ', lname) as Complete_name, salary, round(1.1*salary,2) as increased_salary
from employee e, works_on as w, project as p
where (e.ssn = w.essn and w.pno=p.pnumber and p.pname='ProductX');

-- recuperando dados dos empregados que trabalham para o departamento de pesquisa
select fname, lname, address 
from employee, department
where dname = 'Research' and dnumber = dno;

select concat(fname, ' ', lname) as Complete_Name, dname as Department_Name, address 
	from employee, department 
    where dno = dnumber 
    and address like '%Houston%';

select fname, lname 
from employee 
where (salary > 3000.00 and salary < 40000);

select fname, lname 
from employee 
where (salary between 20000 and 40000);


-- SUBQUERIES 

use company;
show tables;

-- projetos em que Smith trabalha
select pno, hours 
from works_on, employee
where essn = ssn and lname='Smith';

-- projetos em que Smith gerencia
select pnumber 
from project, department, employee
where dnum=dnumber and mgr_ssn = ssn and lname='Smith';

select * from employee;

-- retornar todos os projetos que Smith trabalha e gerencia
select distinct pnumber 
from project where pnumber in 
		(select pnumber from project, department, employee
        where dnum =dnumber and mgr_ssn = ssn and lname='Smith')
        or 
        pnumber in
        (select pno from works_on, employee
        where essn = ssn and lname='Smith');
        
-- comparação com apenas um atributo
select distinct essn from works_on 
where (pno,hours) in (select pno, hours from works_on where essn = '123456789');

-- recuperando os maiores salários se comparados ao departamento 5
select lname, fname, salary 
from employee
where salary > all (select salary from employee where dno=5); -- retorna TRUE se TODOS os valores da subconsulta atenderem à condição

select lname, fname, salary 
from employee
where salary = any (select salary from employee where dno=5); -- retorna TRUE se QUALQUER um dos valores da subconsulta atender à condição (dno=5)

select lname, fname, salary 
from employee
where salary < all (select salary from employee where dno=5);  -- retorna TRUE se TODOS os valores da subconsulta atenderem à condição

select * from employee where dno=5;

-- empregados que possuem dependentes
select e.fname, e.lname 
from employee as e
where exists (	select * from dependent as d 
				where e.ssn=d.essn and e.sex = d.sex ); -- verificando se id do employee está em dependent
                
-- recuperando nome de empregados que não possuem dependentes
select concat(e.fname,' ', e.lname) as Employee
	from employee as e
	where not exists (	select * from dependent as d 
						where e.ssn=d.essn
					  ); 
                      
-- gerentes com dependentes
select e.fname, e.lname 
	from employee as e
	where exists (	select * from dependent as d 
                    where e.ssn=d.essn
				 )
                 and
                 exists (select * from department
                 where ssn = mgr_ssn); 
                 
-- acima de um n° de dependentes
select e.fname, e.lname 
	from employee as e
	where exists (	select * from dependent as d 
                    where e.ssn=d.essn
				 )>=2; 
                 
-- recuperando o ssn de todos empregados que trabalham nos projetos 1,2 ou 3
select distinct Essn from works_on where Pno in (1,2,3);
						





