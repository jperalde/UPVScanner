Para probar una versión ejecutable acceder a la carpeta UPVScanner\test.
------------------------------------------------------------------------------------
Para insertar datos en la base de datos abrir la ventana de comandos de window en la carpeta 'bd'. Escribir 'sqlite3 test.db'.
------------------------------------------------------------------------------------
C:\Users\jorge\Desktop\proyecto tdi\bd>sqlite3 test.db
sqlite> .read crearAlumno.sql
sqlite> .read crearAula.sql
sqlite> .read crearAsignatura.sql
sqlite> .read datos.sql
---------------------------------------------------------------------------------
Un ejemplo de las funciones a escribir:
-----------------------------------------------------------------------------------
insert into Alumno values('Jorge Peral De León','23847618');
insert into Aula values('EPSG','1B','20');
insert into Asignatura values ('TDIV','30','14:20','15:50','EPSG','1A','20','Jorge Peral De León');
-----------------------------------------------------------------------------------------------------
Como se puede observar en los ejemplos todas las palabras del nombre han de llevar la primera letra en Mayúscula.
------------------------------------------------------------------------------------
Otra opción es modificar los datos dentro de datos.sql y escribir en cmd '.read datos.sql'.
------------------------------------------------------------------------------------
El archivo 'hacerfotos.mlapp' sirve para obtener imagenes de prueba como las que se obtendrían en la aplicación UPVScanner.