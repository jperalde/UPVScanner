--crearUsuario
create table Alumno(
	nombre varchar(200) not null,
	dni varchar(20),	
	primary key (nombre,dni)
);
