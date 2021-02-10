--crearAula

create table Aula(
	centro varchar(200) not null,
	edificio varchar(200) not null,
	numero varchar(280) not null,
	primary key (centro,edificio,numero)
);
