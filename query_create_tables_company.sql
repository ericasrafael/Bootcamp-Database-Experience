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





