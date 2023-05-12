function [nb,nn,lb,r,T] = calc_cossenos(joints,jb)
%Calcula parametros geometricos basicos
%   Calcula comprimento das barras e cossenos diretores

[nb,~]=size(jb);%numero de barras
[nn,~]=size(joints);%numero de nós
%% Inicializa e aloca espaço na memoria
gln=6;%numero do graus de liberdade dos nós
T=zeros(gln*2,gln*2);%matriz de rotação de elementos
r=zeros(3,3,nb); %matriz de rotação xyz para XYZ "local para global"


for n=1:nb
    %% Comprimento das barras
    lb(n)=((joints(jb(n,1),1)-joints(jb(n,2),1))^2 + ...
           (joints(jb(n,1),2)-joints(jb(n,2),2))^2 + ...
           (joints(jb(n,1),3)-joints(jb(n,2),3))^2)^.5;
    
    %% Cossenos diretores
    rxX(n)=(joints(jb(n,2),1)-joints(jb(n,1),1))/lb(n);
    rxY(n)=(joints(jb(n,2),2)-joints(jb(n,1),2))/lb(n);
    rxZ(n)=(joints(jb(n,2),3)-joints(jb(n,1),3))/lb(n);
          
    %Transformação é yzx? se sim 1 se for zyx é 0    
    tipo_tranf_m(n)=0;
    psi(n)=0;
    if rxZ(n)==1  
        tipo_tranf_m(n)=1;
        psi(n)=0;
    elseif rxZ(n)==-1 
        tipo_tranf_m(n)=1;
        psi(n)=0;
    end

        cpsi(n)=cos(psi(n));
        spsi(n)=sin(psi(n));
        
    if tipo_tranf_m(n)==1
r(:,:,n)=[        1       0        0     ;                             ...
                   0    cpsi(n)   spsi(n) ;                             ...
                   0   -spsi(n)   cpsi(n) ]*                            ...
                                                                        ...
  [(rxX(n)^2+rxZ(n)^2)^.5         rxY(n)            0       ;              ...
       -rxY(n)            (rxX(n)^2+rxZ(n)^2)^.5    0       ;              ...
         0                       0               1       ]*             ...
                                                         ...   
[rxX(n)/(rxX(n)^2+rxZ(n)^2)^.5        0        rxZ(n)/(rxX(n)^2+rxZ(n)^2)^.5; ...
             0                     1                   0              ; ...
-rxZ(n)/(rxX(n)^2+rxZ(n)^2)^.5        0       rxX(n)/(rxX(n)^2+rxZ(n)^2)^.5];
    else
        ryX=(-rxX(n)*rxZ(n)*spsi(n)-rxY(n)*cpsi(n))/(rxX(n)^2+rxY(n)^2)^.5;
        ryY=(-rxY(n)*rxZ(n)*spsi(n)+rxX(n)*cpsi(n))/(rxX(n)^2+rxY(n)^2)^.5;
        ryZ=(spsi(n))*(rxX(n)^2+rxY(n)^2)^.5;
        rzX=(-rxX(n)*rxZ(n)*cpsi(n)+rxY(n)*spsi(n))/(rxX(n)^2+rxY(n)^2)^.5;
        rzy=(-rxY(n)*rxZ(n)*cpsi(n)-rxX(n)*spsi(n))/(rxX(n)^2+rxY(n)^2)^.5;
        rzZ=(cpsi(n))*((rxX(n)^2+rxY(n)^2)^.5);
        
        r(:,:,n)=[rxX(n) rxY(n) rxZ(n);...
                    ryX   ryY   ryZ ;...
                    rzX   rzy   rzZ ];
    end
        %% Matriz de transformação de coordenadas
    for i=1:3
        for j=1:3
            T(i,j,n)=r(i,j,n);
            T(i+3,j+3,n)=r(i,j,n);
            T(i+6,j+6,n)=r(i,j,n);
            T(i+9,j+9,n)=r(i,j,n);
        end
    end
end
end

