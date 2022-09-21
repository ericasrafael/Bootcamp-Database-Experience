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



						