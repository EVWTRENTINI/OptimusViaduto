function cd=PP2cd(MA,r,viaduto,info,fauchart,GR)
%Calcula e lança o peso proprio dos membros
%   Multiplica a área da seção transversal pelo peso específico do concreto
%   lançando como carga distribuida ao longo do eixo do membro. Calcula
%   tambem o peso próprio da parte enrijecida da longarina, o peso proprio
%   do guarda roda e da pavimentação.


GRPP=GR.PP;
GRCG=GR.CG;
GRB=GR.B;

[~,nvao]=size(info.longarinas.vao);

%cd{MA.n.memb-sum([MA.memb(:).draw_not])}=[];
 cont=0;

%% Area vezes peso especifico
for n=1:MA.n.memb
    if isempty(MA.memb(n).draw_not)
    	%[Barra direcao inicio fim valor]
        cont=cont+1;
        cd{cont}=[n 1 0 1 -25E3*MA.memb(n).A*r(1,3,n)];
        
        cont=cont+1;
        cd{cont}=[n 2 0 1 -25E3*MA.memb(n).A*r(2,3,n)];
        
        cont=cont+1;
        cd{cont}=[n 3 0 1 -25E3*MA.memb(n).A*r(3,3,n)];
    end
end

%% PP por diferença de área do Enrijecimento

for k=1:nvao
    [~,nlonga]=size(info.longarinas.vao(k).longarina);
    for j=1:nlonga
            A=info.longarinas.vao(k).longarina(j).A;
            Aenr=info.longarinas.vao(k).longarina(j).Aenr;
            PP=(Aenr-A)*-25E3;
            n=info.longarinas.vao(k).longarina(j).membros;
            enr=viaduto.vao(k).longarina.enr;
            
            %Começo da barra
            cont=cont+1;
            cd{cont}=[n 1 0 enr PP*r(1,3,n)];
            
            cont=cont+1;
            cd{cont}=[n 2 0 enr PP*r(2,3,n)];
            
            cont=cont+1;
            cd{cont}=[n 3 0 enr PP*r(3,3,n)];
            
            %Final da barra
            cont=cont+1;
            cd{cont}=[n 1 1-enr 1 PP*r(1,3,n)];
            
            cont=cont+1;
            cd{cont}=[n 2 1-enr 1 PP*r(2,3,n)];
            
            cont=cont+1;
            cd{cont}=[n 3 1-enr 1 PP*r(3,3,n)];
    end
    
end
%% PP da laje suprimida da seção estrutural
for k=1:nvao
    hlaje=viaduto.vao(k).laje.h;
    [~,nlonga]=size(info.longarinas.vao(k).longarina);
    for j=1:nlonga
        n=info.longarinas.vao(k).longarina(j).membros;
        A_sup=hlaje*info.longarinas.vao(k).longarina(j).laje_sup;
        %Começo da barra
        cont=cont+1;
        cd{cont}=[n 1 0 1 A_sup*-25E3*r(1,3,n)];
        
        cont=cont+1;
        cd{cont}=[n 2 0 1 A_sup*-25E3*r(2,3,n)];
        
        cont=cont+1;
        cd{cont}=[n 3 0 1 A_sup*-25E3*r(3,3,n)];
        
    end
end

%% PP capa de CBUQ
CBUQ.tabuleiro=0;%inicializa
CBUQ.m=-(viaduto.hpav*24E3+2E3);%24kN/m³ minimo e mais 2kN/m² de capeamento NBR 7188:2013
CBUQ.b=-viaduto.W/2+GRB;
CBUQ.e=viaduto.W/2-GRB;
for k=1:nvao
    CBUQ.tabuleiro=k;
    cont=cont+1;
    cd{cont} = MT2cd(CBUQ,1,fauchart,r,viaduto,info);
end

%% PP guarda roda

%Guarda roda esquerdo
GRe.tabuleiro=0;%inicializa
GRe.m=GRPP/(2*GRCG);
GRe.b=-viaduto.W/2;
GRe.e=-viaduto.W/2+2*GRCG;

%Guarda roda direito
GRd.tabuleiro=0;%inicializa
GRd.m=GRPP/(2*GRCG);
GRd.b=viaduto.W/2-2*GRCG;
GRd.e=viaduto.W/2;

for k=1:nvao
    GRe.tabuleiro=k;
    GRd.tabuleiro=k;
    cont=cont+1;
    cd{cont} = MT2cd(GRe,1,fauchart,r,viaduto,info);%esquerdo
    cont=cont+1;
    cd{cont} = MT2cd(GRd,1,fauchart,r,viaduto,info);%direito
end

%% Concatenação dos pointers em uma unica matriz
cd=vertcat(cd{:});
end

