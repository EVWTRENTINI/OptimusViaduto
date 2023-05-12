function ap=disc_arm_circ(n_bar,fi_l,r)
%Aloja armadura discretizada, ou seja, sem limitações geometricas, na seção circular
[x,y]=circulo(r,n_bar);
if not(mod(n_bar,2))%par
    theta=pi/n_bar+pi/2;
    rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
    xy=[x;y]'*rot;
    
    ap.x=xy(1:end-1,1);
    ap.y=xy(1:end-1,2);
else %impar
    ap.x=y(1:end-1);
    ap.y=x(1:end-1);
end
ap.A=ones(1,n_bar)*fi_l^2*pi/4*1E4;%cm²
ap.n=n_bar;
ap.camada=zeros(1,n_bar);
end