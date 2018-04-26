% Normal Probability Density Function
%
% Borra todo
clear all; clc; close all

% Número de datos aleatorios para generar
n=1000;     
X = randn(n,1).*50 + 500;

% Desviación estandar de los valores aleatorios
s = std(X);         

% Media de los valores aleatorios
m = mean(X);        

% Histograma de X:  a=frecuencia,  b=valor
[a,b]= hist(X,40);  
% ancho de los bins del histograma
bin= b(2)- b(1);    

% Normalizacion de las frecuencias de acuerdo al número de bins
aNormalizado = a./(n*bin); 
bar(b, aNormalizado)

% Define la funcion de distribución normal
f=@(x) exp(-0.5 * ((x - m)./s).^2) ./ (sqrt(2*pi) .* s);

% Grafica la pdf de X (ordenados de menor a mayor)
line(sort(X),f(sort(X)),'color','r')

% La integral de la pdf en el rango de X debe ser 1 o cercana a 1
integral(f,min(X),max(X))
