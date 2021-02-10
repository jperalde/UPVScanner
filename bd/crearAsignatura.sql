--crearAsignatura

create table Asignatura(
	nombre varchar(200) not null,
	dia varchar(3) not null,
	inicio varchar(200) not null,
	final varchar(200) not null,
	centro varchar(200) not null,
	edificio varchar(200) not null,
	aula varchar(20) not null,
	alumno varchar(200) not null,
	foreign key (centro) references Aula(centro) ON DELETE CASCADE,
	foreign key (edificio) references Aula(edificio) ON DELETE CASCADE,
	foreign key (aula) references Aula(numero) ON DELETE CASCADE,
	foreign key (alumno) references Alumno(nombre) ON DELETE CASCADE
	
);
