function [Nombre, DNI,Estado,Centro] = ExtractorDatosQR(imagenQR)
%ExtractorDatosQR devuelve el nombre, DNI, Estado(Activo o no) y Centro del
%alumno
%   Se le ha de pasar una imagen del QR recortada o en todo caso la direccion de la carpeta en la que se encuentra la imagen
    if strcmp(class(imagenQR),"uint8")%si es una imagen
        I=imagenQR;
    elseif strcmp(imagenQR,"")
        Nombre="";
        DNI="";
        Estado="";
        Centro="";
        return
    else
        I=imread(imagenQR);%si se trata del nombre de la foto la lee
    end
    msg = readBarcode(I,"QR-CODE");
    if strcmp(msg,'')
        Nombre="";
        DNI="";
        Estado="";
        Centro="";
        return;
    end

    code =webread(msg); %devuelve el codigo HTML de la web con la información del alumno
    tree = htmlTree(code);
    selector="table";
    subtrees = findElement(tree,selector);%encuentra en el arbol html los elementos table

    str = extractHTMLText(subtrees);
    %
    %Obtener el estado
    %
    stateArray=split(str(1));
    Estado=stateArray(4);
    if strcmp(Estado,'CADUCADO')
        Nombre="";
        DNI="";
        Centro="";
        return;
    end
    %Obtiene los demas datos
    %
    %Obtener el DNI sin letra (porque no tiene)
    %
    pattern=" "|lettersPattern;
    DNI=split(str(3),pattern);
    DNI=DNI(strlength(DNI)>1);
    %
    %Obtener Nombre y apellidos
    %
    str2=split(str(3),"Nombre:");%separa la información del DNI
    strlastname=split(str2(2),",");
    apellidos=strtrim(strlastname(1));
    strname=split(strlastname(2),"ALUMNE/A");%devuelve un array de string en el que el primer valor es el nombre completo del alumno y el segundo el centro
    %guarda el nombre y el apellido dentro del mismo array y los junta en
    %la variable Nombre
    Nombre=strtrim(strname(1));
    Nombre=Nombre+" "+apellidos;
    %
    %Obtener el centro
    %
    strcentro=split(strname(2),"Centro");
    Centro=strtrim(strcentro(2));
    return

end

