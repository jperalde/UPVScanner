function croppedImage = detectorQR(frame)
%Esta función se encarga de identificar si hay o no un codigo QR en las
%imagenes extraidas de la webcam y en el caso de haberlas recorta donde se
%encuentra dicho codigo de la imagen Icropped
        
    rect=[200 100 880 500];
    %recorta la imagen en el tamaño marcado por el rectangulo rojo en la 
    %aplicacion para eliminar el fondo y fijar un tamaño semjante para todas las fotos
    
    Icropped = imcrop(frame,rect); 
    %Al querer que detecte un código QR (NEGRO) y separarlo del fondo de la
    %tarjeta gris oscuro se supone un umbral alto de 0.85 utilizando la
    %función imbinarize para pasar a una imagen logica/binaria (0 o 1) la imagen en escala de grises reultante de la funcion rgb2gray 
    bw=imbinarize(rgb2gray(Icropped),"adaptive","Sensitivity",0.85); 
    
    %Se define el structuring element como un cuadrado de 3x3, debido a que
    %se trata de elementos muy pequeños y con resolución no muy alta, por lo que si el SE fuera mayor uniría algunos objetos o los eliminaría 
    SEo=strel ('square',3);
   
    % Realiza la operació Open
    open=imopen(bw,SEo);
    
    %guarda en wb el negativo de la imagen salida del open
    wb=imcomplement(open);
    
    %Vuelve a realizar un open
    wbopen=imopen(wb,SEo);
    
    %mantiene unicamente los primeros 50 objetos con solidez mayor para
    %eliminar objetos con agujeros
    BW2 = bwpropfilt(wbopen,'solidity',50);
    
    %mantiene unicamente los primeros 6 objetos con mayor area para
    %eliminar objetos pequeños que hayan podido quedar
    BW3 = bwpropfilt(BW2,'area',6);
   
    %Extrae las propiedades de Excentricidad, los centroides y las
    %propiedades minimas que se darían con un pie de rey
    %(minferetproperties)
    props=regionprops(BW3, 'MinFeretProperties','Eccentricity','Centroid');
   
    %instancias de los objetos donde se van a guardar el numero de patrones
    %y la posición de sus centroides
    numeroDePatrones=0;
    patronesPosicion=[];
    
    %bucle desde el primer al ultimo objeto guardado en props
    for i=1:size(props)
       
        % Si el diametro minimo esta entre 10 y 11, y tiene una
        % excenyticidad entre 0.19 y 0.45 (baja ya que es un cuadrado sin
        % agujeros), se guarda la posición de su centroide y se suma 1 al
        % numero de patrones
        if props(i).MinFeretDiameter>=10 && props(i).MinFeretDiameter<=11 && props(i).Eccentricity>=0.19 && props(i).Eccentricity<=0.45
           
            numeroDePatrones=numeroDePatrones+1;
            patronesPosicion{numeroDePatrones}=props(i).Centroid;

        end
    end
    
    %si el numero de patrones es mayor o menor que 3 se entiende que no son
    %los patrones del codigo QR y se devuelve un string vacio
    if numeroDePatrones<3||numeroDePatrones>3
        
        croppedImage="";
        return;
        
    else

        %Con la posición de los centroides se calcula cada uno de los
        %parametros que se le van a pasar a la función imcrop
        
        %se toman la posición x del centroide de cada objeto
        x1=patronesPosicion{1}(1);
        x2=patronesPosicion{2}(1);
        x3=patronesPosicion{3}(1);
        
        %Se toma la x minima de entre los 3 (la minima será siempre el
        %patrón superior izquierdo) y se le resta 20 para desplazarlo y que
        %no se recorte parte del codigo.
        x=min([x1 x2 x3])-20;
       
        %se toman la posición y del centroide de cada objeto
        y1=patronesPosicion{1}(2);
        y2=patronesPosicion{2}(2);
        y3=patronesPosicion{3}(2);
        
        %Se toma la y minima de entre los 3 (la minima será siempre el
        %patrón superior izquierdo) y se le resta 20 para desplazarlo y que
        %no se recorte parte del codigo.        
        y=min([y1 y2 y3])-20;
        
        %Se calculan el alto y el ancho de lo que se va a recortar,
        %sumandole un margen de los centroides
        h=max([y1 y2 y3])-min([y1 y2 y3])+45;
        w=max([x1 x2 x3])-min([x1 x2 x3])+45;
        msg=[x y w h];
        
        %para observar una imagen con los patrones marcados, descomentar
        %esta sección 
        
%       j=insertShape(Icropped,"Rectangle",[x1-15 y1-15 30 30],"Color","yellow");
%       k=insertText(j, patronesPosicion{1}+20, 'patrón QR');
%       j2=insertShape(k,"Rectangle",[x2-15 y2-15 30 30],"Color","yellow");
%       k2=insertText(j2, patronesPosicion{2}+20, 'patrón QR');
%       j3=insertShape(k2,"Rectangle",[x3-15 y3-15 30 30],"Color","yellow");
%       k3=insertText(j3, patronesPosicion{3}+20, 'patrón QR');
%       imshow(k3)

        %se recorta la imagen
        croppedImage=imcrop(Icropped,msg);
        return;
    end
end

