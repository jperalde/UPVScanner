%
%Con los datos del ExtractorDatosQR comprueba en la base de datos
%
function [Respuesta]=ComprobarBD(Nombre, Centro, Edificio, Aula)
%
%Centro, Edificio y Aula, donde se realiza la asignatura que se comprueban
%en la interfaz de la aplicación.
%Nombre y DNI del alumno se obtienen de ExtractorQR
%Devuelve:
%000= Valores de entrada nulos
%204= No hay clases en ese aula HOY
%401= El alumno no tiene clases hoy
%200= TODO OK DEJA PASAR %POSIBILIDAD DE DEVOLVER LA ASIGNATURA PARA CREAR
%UNA TABLA DE ASISTENCIA
%
    if strcmp(Nombre,"")%si de la variable de entrada Nombre no esta, termina
        Respuesta=000;
        return;
    end     
    today=day(datetime('now'),'dayofyear');%dia del año entre 1 y 366
    hour=datetime('now','Format','HH:mm');%hora actual del dia en hora y minutos
    
    conn = sqlite('C:\Users\jorge\Desktop\proyecto tdi\bd\test.db');%conecta con la base de datos
    queryStudent="select * from Asignatura where alumno='"+Nombre+"' and dia='"+today+"'";%asignaturas que tiene el alumno el día de hoy
    queryClass="select * from Asignatura where dia='"+today+"' and centro='"+Centro+"' and edificio='"+Edificio+"' and aula='"+Aula+"'";%asignaturas hoy en ese aula
    %Realizar las queries a la base de datos
    classesStudent=fetch(conn,queryStudent);%query a la base de datos de asignaturas para saber las clases del alumno
    
    if isempty(classesStudent)%si el alumno no tiene clases se acaba
        Respuesta=401;%Unauthorized
        return
        
    else
        
       classesInPlace=fetch(conn,queryClass);%query a la base de datos de asignaturas para saber las clases del día de hoy
       
       if isempty(classesInPlace)%si no hay nada en ese aula hoy se acaba
           Respuesta=204;%Empty message
           return;
           
       end
       
    end%if classInDate

    booleanmatrix=ismember(classesStudent,classesInPlace);%comprueba las asignaturas que se van a realizar hoy en ese aula y las que tiene alumno matriculadas
    booleanrows=all(booleanmatrix,2);
    for i=height(booleanrows):-1:1
        if booleanrows(i)
            classUPV=classesStudent(i,:);
            startHour=datetime(classUPV(3),'Format','HH:mm');%hora de inicio de la clase
            endHour=datetime(classUPV(4),'Format','HH:mm');%hora de finalización de la clase
            if (hour<endHour)&&(hour>=startHour)%comprueba si la hora de la consulta esta dentro del periodo de la clase
                Respuesta=200;
                return
            else
                Respuesta=401;%Unauthorized
                return
            end%if
        end%if
    end%for
end%function