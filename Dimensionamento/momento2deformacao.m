function y = momento2deformacao(x, Mn, EI)
l = x(2:end) - x(1:end-1);
nn = length(Mn);
nb = nn - 1;

% Determina a equação do momento
% Momento_i = M(i,1) * x + M(i,2)
M = zeros(nb,2);
for i = 1 : nb % Possível paralelizar.
    M(i,1) = (Mn(i+1) - Mn(i))/(l(i));
    M(i,2) = Mn(i) - M(i,1) * x(i);
end

% Determina a equação do teta (rotação)
% Rotação_i = T(i,1) * x^2 + T(i,2) * x + T(i,3)
% T(i,3) + T(i,4) = Constante de integralçao = c1+ci
% T(i,3) = Constante da primeira barra = c1
T = zeros(nb,3);
for i = 1 : nb % Possível paralelizar.
    T(i,1) = M(i,1)/2/EI;
    T(i,2) = M(i,2)/EI;
end

%Calcula as constantes em função de c1
for i = 2 : nb % Possível paralelizar.
    T(i,3) = (T(i-1,1)*x(i)^2+T(i-1,2)*x(i)+T(i-1,3))-(T(i,1)*x(i)^2+T(i,2)*x(i)+T(i,3));
end


% Determina a equação da deformação
% Deformação_i = Y(i,1) * x^3 + Y(i,2) * x^2 + Y(i,3) * x + Y(i,4) 
Y = zeros(nb,4);
for i = 1 : nb % Possível paralelizar.
    Y(i,1) = T(i,1)/3;
    Y(i,2) = T(i,2)/2;
    Y(i,3) = T(i,3);
end

%Calcula as constantes em função de c1
for i = 2 : nb % Possível paralelizar.
    Y(i,4) = (Y(i-1,1)*x(i)^3+Y(i-1,2)*x(i)^2+Y(i-1,3)*x(i)+Y(i-1,4))-(Y(i,1)*x(i)^3+Y(i,2)*x(i)^2+Y(i,3)*x(i)+Y(i,4));
end

i=nb;
C = -(Y(i,1)*x(i+1)^3+Y(i,2)*x(i+1)^2+Y(i,3)*x(i+1)+Y(i,4))/x(i+1);
T(:,3) = T(:,3) + C;
Y(:,3) = Y(:,3) + C;

y = zeros(size(x));
for i = 1 : nb % Possível paralelizar.
    xx = [x(i) x(i+1)];
    y(i:i+1) = Y(i,1).*xx.*xx.*xx + Y(i,2).*xx.*xx + Y(i,3).*xx + Y(i,4);
end
y=-y;
end