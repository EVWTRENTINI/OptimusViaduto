function [d,v,F,R] = aval_cc(Qf,jl,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig,T,nb,nn)
%Processamento do AMEBP3D - Avalia a estrutura para o caso de carregamento

%% Calcula parametros basicos para a an�lise
gln=6;%numero do graus de liberdade dos n�s

dof=nn*gln;%numero de graus de liberdade totais

%% Inicializa e aloca espa�o na memoria


F=zeros(12,nb);%for�as nas coordenadas globais nas extremidades das barras
Ff=zeros(gln*2,nb); %cargas aplicadas nos n�s em coord globais
P=jl; %cargas aplicadas nos graus de liberdade globais


for n=1:nb 
%% Rota��o de coordenadas locais para GLOBAIS
    
    %Rotaciona a matriz de carregamentos
    Ff(:,n)=transpose(T(:,:,n))*Qf(:,n);
    

%% Transformar os graus de liberdade de elementos para graus de liberdade da estrutura
    
    %Monta monta o vetor em graus de liberdade globais de carregamentos
    for i=1:gln*2
        P((bcn(n,i)),1)=P((bcn(n,i)),1)-Ff(i,n);%joint load and member load
    end

end


%% Restri��es nodais de deslocamentos
%(unrestrained) da estrutura em coordenadas globais

%Remove linhas e colunas de Kglobal por estarem fixos
Pu=P;
for n=1:rdf
    Pu(rdf_list(n),:)=0;
end

%% C�lculo dos deslocamentos globais U=inv(K)*F


d_tio=invSu*Pu;% deslocamentos sem considerar as barras r�gidas
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
    
    %C�lculo for�as nas extremidadesdas dos elementos em coord GLOBAIS
    if n_e_rig(n)==0  %n�o r�gidas
        F(:,n)=(K(:,:,n)*v(:,n))+Ff(:,n);
    else              %r�gidas
        if n_e_rig_ex(n)==0
            F(:,n)=(K(:,:,n)*v(:,n))+Ff(:,n)+...
        	transpose(cg(:,:,n))*lambda(restr(1,n):restr(2,n));
        else
        	F(:,n)=(K(:,:,n)*v(:,n))+Ff(:,n)+...
        	transpose(cg(2:end,:,n))*lambda(restr(1,n):restr(2,n));
        end
    end
    
    %Transferencia das for�as nas extremidades dos elementos para for�as 
    %nos n�s da ESTRUTURA - em uni�o de n�s elas se anulam, caso n�o se
    %anulem � por que existe uma carga externa, ou sejam uma rea��o de
    %apoio.

    
    for i=1:gln*2
        R(bcn(n,i))=R(bcn(n,i))+F(i,n);
    end
  
    
end
%jf vetor de cargas externas, aqui � removido as cargas aplicadas e
%portanto s� restam as rea��es de apoio nele.
R=R-jl;
%jf=Kglobal*del_ug-jl_ml+transpose(AA)*mult_lag; <- Forma alternativa com barra rigida!
%jf=Kglobal*del_ug-jl_ml; <- Forma alternativa sem barra rigida!

end

