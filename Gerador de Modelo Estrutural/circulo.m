function [X,Y] = circulo(r,p)
passo=2*pi/(p);
th = 0:passo:2*pi;
X = r * cos(th);
Y = r * sin(th);
end