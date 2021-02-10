function [Nombre]=recoNombre(frame)

%recoNombre funciona con un lenguaje OCR previamente entrenado
%con imágenes de varias tarjetas UPV

I=frame;
%I=imread('upv.jpeg');

%Escala de grises
I=rgb2gray(I);
%Umbralización
T = adaptthresh(I,0.4,'ForegroundPolarity','dark');
BW=imbinarize(I,T);
%Negativo para tener objetos en vez de fondo
BW1=imcomplement(BW);
%Rellenar huecos y eliminar objetos pequeños
BW2=imfill(BW1,'holes');
BW3=bwareaopen(BW2,100000);
%Detectar el BoundingBox y utilizarlo para recortar
s = regionprops(BW3,'BoundingBox');
RBW=imcrop(I,s.BoundingBox);
%Umbralización
T = adaptthresh(RBW,0.4,'ForegroundPolarity','dark');
segm= imbinarize(RBW,T);
%Negativo de la imagen
nega=imcomplement(segm);
%Eliminar objetos de 40px o menos (puntos)
sup=bwareaopen(nega,40);
%Reescalado de la imagen para que siempre tenga el mismo tamaño
res=imresize(sup,[500 850]);
%Definir region donde se encuentra el nombre
roi=[220,350,510,60];
%Reconocimiento de caracteres
[ocrI, results] = upvCardOCR(res, roi);
%Resultado en texto
Nombre=results.Text
%Resultado de manera gráfica
%figure
%imshow(ocrI)



end