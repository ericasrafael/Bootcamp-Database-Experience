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