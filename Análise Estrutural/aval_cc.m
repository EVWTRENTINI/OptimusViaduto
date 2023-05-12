function [d,v,F,R] = aval_cc(Qf,jl,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig,T,nb,nn)
%Processamento do AMEBP3D - Avalia a estrutura para o caso de carregamento

%% Calcula parametros basicos para a análise
gln=6;%numero do graus de liberdade dos nós

dof=nn*gln;%numero de graus de liberdade totais

%% Inicializa e aloca espaço na memoria


F=zeros(12,nb);%forças nas coordenadas globais nas extremidades das barras
Ff=zeros(gln*2,nb); %cargas aplicadas nos nós em coord globais
P=jl; %cargas aplicadas nos graus de liberdade globais


for n=1:nb 
%% Rotação de coordenadas locais para GLOBAIS
    
    %Rotaciona a matriz de carregamentos
    Ff(:,n)=transpose(T(:,:,n))*Qf(:,n);
    

%% Transformar os graus de liberdade de elementos para graus de liberdade da estrutura
    
    %Monta monta o vetor em graus de liberdade globais de carregamentos
    for i=1:gln*2
        P((bcn(n,i)),1)=P((bcn(n,i)),1)-Ff(i,n);%joint load and member load
    end

end


%% Restrições nodais de deslocamentos
%(unrestrained) da estrutura em coordenadas globais

%Remove linhas e colunas de Kglobal por estarem fixos
Pu=P;
for n=1:rdf
    Pu(rdf_list(n),:)=0;
end

%% Cálculo dos deslocamentos globais U=inv(K)*F


d_tio=invSu*Pu;% deslocamentos sem considerar as barras rígidas
if nbrig>0
    %lambda=M\(Cu*d_tio);%multiplicador de lagrange
    lambda=invM*(Cu*d_tio);%multiplicador de lagrange invM
    d=d_tio-B*lambda;
else
    d=d_tio;
end


%% Transferencia dos graus de liberdade da ESTRUTURA para elementos

R=zeros(dof,1);

for n=1:nb
    %Transferencia dos deslocamentos na ESTRUTURA para os elementos
    for i=1:gln*2
        v(i,n)=d(bcn(n,i));
    end
    
    %Cálculo forças nas extremidadesdas dos elementos em coord GLOBAIS
    if n_e_rig(n)==0  %não rígidas
        F(:,n)=(K(:,:,n)*v(:,n))+Ff(:,n);
    else              %rígidas
        if n_e_rig_ex(n)==0
            F(:,n)=(K(:,:,n)*v(:,n))+Ff(:,n)+...
        	transpose(cg(:,:,n))*lambda(restr(1,n):restr(2,n));
        else
        	F(:,n)=(K(:,:,n)*v(:,n))+Ff(:,n)+...
        	transpose(cg(2:end,:,n))*lambda(restr(1,n):restr(2,n));
        end
    end
    
    %Transferencia das forças nas extremidades dos elementos para forças 
    %nos nós da ESTRUTURA - em união de nós elas se anulam, caso não se
    %anulem é por que existe uma carga externa, ou sejam uma reação de
    %apoio.

    
    for i=1:gln*2
        R(bcn(n,i))=R(bcn(n,i))+F(i,n);
    end
  
    
end
%jf vetor de cargas externas, aqui é removido as cargas aplicadas e
%portanto só restam as reações de apoio nele.
R=R-jl;
%jf=Kglobal*del_ug-jl_ml+transpose(AA)*mult_lag; <- Forma alternativa com barra rigida!
%jf=Kglobal*del_ug-jl_ml; <- Forma alternativa sem barra rigida!

end

