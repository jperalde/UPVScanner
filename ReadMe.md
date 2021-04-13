
# UPV-Scanner

This project came from the necessity of controlling and restricting the attendance of big groups of people due to the current situation involving COVID-19.
The project's main objective was to design and program a full-stack application, built-in specifically for the Universitat Politécnica de Valéncia (UPV), to facilitate the control of attendance in its classes, courses, etc. 
To do this it was necessary to implement an SQLite database, to simulate the UPV’s real one or as the base for a new one, and a function to manage to do queries with the data extracted from the card; apart from the main functions to detect and collect information on the cards.
The application is a real-time, name and QR-Code detector, designed to be placed outside the classrooms to grant or deny students access depending on the subject they are enrolled in, and also making available a table at the end of the day as an attendance list. For this, it would be necessary the placement of a screen and a webcam.

## Try out

### Executable

To try an executable go to UPVScanner\test.

### Insert into SQL Table

To insert data into the database open the window command window in the 'bd' folder. Type 'sqlite3 test.db'.

´´´
C:\Users\jorge\Desktop\proyecto tdi\bd>sqlite3 test.db
sqlite> .read crearAlumno.sql
sqlite> .read crearAula.sql
sqlite> .read crearAsignatura.sql
sqlite> .read datos.sql
´´´
An example on the SQL functions to write in 'test.db':

´´´
insert into Alumno values('John Snow','123456789');
insert into Aula values('EPSG','1B','20');
insert into Asignatura values ('TDIV','30','14:20','15:50','EPSG','1A','20','John Snow');
´´´

As can be seen in the examples, all the words in the name must have the first letter capitalized.

Another option is to modify the data inside datos.sql and write in cmd '.read datos.sql'.

The file 'hacerfotos.mlapp' is used to obtain test images like the ones that would be obtained in the UPVScanner application.

Translated with www.DeepL.com/Translator (free version)