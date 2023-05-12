function [K,S,Su,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig] = constroi_KeS(joints,jb,jfix,broty,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,nb,lb,r,T)
%Constroi as matrizes de rigidez
%% Calcula parametros basicos para a análise
gln=6;%numero do graus de liberdade dos nós
[nn,~]=size(joints);%numero de nós
[nbroty,~]=size(broty);%numero de barras com rotula em y
[~,nbrig]=size(brig);%numero de barras rigidas
[nbrig_ex,~]=size(brig_ex);%numero de barras rigidas extensiveis
[naflex,~]=size(aflex);%numero de restrições flexiveis
dof=nn*gln;%numero de graus de liberdade totais

%% Inicializa e aloca espaço na memoria

k=zeros(gln*2,gln*2,nb);%matriz de rigidez de elemento coord local
K=zeros(gln*2,gln*2,nb);%matriz de rigidez de elemento coord globais
S=zeros(dof);%matriz de rigidez da estrutura
n_e_rig=zeros(1,nb);%a barra n é rigida?
n_e_rig_ex=zeros(1,nb);%a barra n é rigida extensivel?
cg = zeros(6,12,nb);

restr=zeros(2,nb);%posição inicial e final das restrições na matriz de restrições
ult_restr=0;%ultima restrição salva em "restr"

remove_C=[];%linhas a remover do AA por barras rigidas extensiveis

%% Matriz de rigidez da estrutura
for n=1:nb 
    %% Coordenadas globais das barras   
    bcn(n,:)=[(jb(n,1)*gln-5) (jb(n,1)*gln-4) (jb(n,1)*gln-3) ...
              (jb(n,1)*gln-2) (jb(n,1)*gln-1) (jb(n,1)*gln)   ...
              (jb(n,2)*gln-5) (jb(n,2)*gln-4) (jb(n,2)*gln-3) ...
              (jb(n,2)*gln-2) (jb(n,2)*gln-1) (jb(n,2)*gln)]; 
            
    %% Matriz de rigidez do elemento

    sc1=E(n)*A(n)/lb(n);
    sc2=6*E(n)*Iz(n)/(lb(n)^2);
    sc3=6*E(n)*Iy(n)/(lb(n)^2);
    sc4=G(n)*J(n)/lb(n);
    sc5=2*E(n)*Iy(n)/lb(n);
    sc6=12*E(n)*Iz(n)/(lb(n)^3);
    sc7=12*E(n)*Iy(n)/(lb(n)^3);
    sc8=2*E(n)*Iz(n)/lb(n);
    
 k(:,:,n) =[ sc1   0    0    0    0    0  -sc1   0    0    0    0    0 ;...
              0   sc6   0    0    0   sc2   0  -sc6   0    0    0   sc2;...
              0    0   sc7   0  -sc3   0    0    0  -sc7   0  -sc3   0 ;... 
              0    0    0   sc4   0    0    0    0    0  -sc4   0    0 ;...  
              0    0  -sc3   0 2*sc5   0    0    0   sc3   0   sc5   0 ;... 
              0   sc2   0    0    0 2*sc8   0  -sc2   0    0    0   sc8;...
            -sc1   0    0    0    0    0   sc1   0    0    0    0    0 ;...  
              0  -sc6   0    0    0  -sc2   0   sc6   0    0    0  -sc2;...
              0    0  -sc7   0   sc3   0    0    0   sc7   0   sc3   0 ;...  
              0    0    0  -sc4   0    0    0    0    0   sc4   0    0 ;...  
              0    0  -sc3   0   sc5   0    0    0   sc3   0 2*sc5   0 ;...            
              0   sc2   0    0    0   sc8   0  -sc2   0    0    0 2*sc8];            
    %% Rotula em Y
    for lbry=1:nbroty        
        if broty(lbry,1)==n %A barra atual possui rotula?
            if broty(lbry,2)==1 && broty(lbry,3)==1%birotulada
                krot=zeros(4,4);
            elseif broty(lbry,2)==0 && broty(lbry,3)==1%engaste-rotula
                krot(1,1)=3*E(n)*Iy(n)/lb(n)^3;
                krot(3,3)=krot(1,1);
                krot(1,3)=-krot(1,1);
                krot(3,1)=-krot(1,1);
                krot(1,2)=-3*E(n)*Iy(n)/lb(n)^2;
                krot(2,1)=krot(1,2);
                krot(2,3)=-krot(1,2);
                krot(3,2)=-krot(1,2);
                krot(2,2)=3*E(n)*Iy(n)/lb(n);
                krot(4,1)=0;
                krot(4,2)=0;
                krot(4,3)=0;
                krot(4,4)=0;
                krot(1,4)=0;
                krot(2,4)=0;
                krot(3,4)=0;
            elseif broty(lbry,2)==1 && broty(lbry,3)==0%rotula-engaste
                krot(1,1)=3*E(n)*Iy(n)/lb(n)^3;
                krot(3,3)=krot(1,1);
                krot(1,3)=-krot(1,1);
                krot(3,1)=-krot(1,1);
                krot(1,2)=0;
                krot(2,1)=0;
                krot(2,3)=0;
                krot(3,2)=0;
                krot(2,2)=0;
                krot(4,1)=-3*E(n)*Iy(n)/lb(n)^2;
                krot(4,2)=0;
                krot(4,3)=-krot(4,1);
                krot(4,4)=3*E(n)*Iy(n)/lb(n);
                krot(1,4)=krot(4,1);
                krot(2,4)=0;
                krot(3,4)=-krot(4,1);
            end
            for i=1:4
                if i<=2
                    ik=i*2+1;
                else
                    ik=i*2+3;
                end
                for j=1:4
                    if j<=2
                        jk=j*2+1;
                    else
                        jk=j*2+3;
                    end
                    k(ik,jk,n)=krot(i,j);
                end
            end
        end
    end    
    
    %% Matriz de restrições dos elementos
    for lbrig=1:nbrig
        if brig(lbrig)==n
            n_e_rig(n)=1;%A barra N é rigida? 1 se sim, 0 se não
            break
        end
    end
    for lbrig_ex=1:nbrig_ex
        if brig_ex(lbrig_ex,1)==n
            n_e_rig_ex(n)=1;%A barra N é rigida extensivel? 1 se sim, 0 se não
            break
        end
    end
    
    if nbrig>0 && n_e_rig(n)==1
        L=lb(n);

              % 1  2  3  4  5  6 | 7  8  9 10 11 12 
    cl(:,:,n)=[ 1  0  0  0  0  0  -1  0  0  0  0  0;...1-axial   x
                0  0  0  0  1  0   0  0  0  0 -1  0;...2-rotação y
                0  0 -1  0  L  0   0  0  1  0  0  0;...3-desloc z por rot y
                0  0  0  0  0  1   0  0  0  0  0 -1;...4-rotação z              
                0 -1  0  0  0 -L   0  1  0  0  0  0;...5-desloc y por rot z
                0  0  0  1  0  0   0  0  0 -1  0  0];% 6-torção x
        
        %Anota posição inicial e final da restrição na matriz de restrições
        %de elementos
        
        
        
        %Altera a rigidez da barras rigida extensível
        if n_e_rig_ex(n)==1
            [~,i]=size(remove_C);
            remove_C(i+1)=ult_restr-5;
            k(1,1,n)= brig_ex(lbrig_ex,2);
            k(7,7,n)= brig_ex(lbrig_ex,2);
            k(1,7,n)=-brig_ex(lbrig_ex,2);
            k(7,1,n)=-brig_ex(lbrig_ex,2);
            restr(:,n)=[ult_restr+1;ult_restr+5];
        else
            restr(:,n)=[ult_restr+1;ult_restr+6];
        end
        ult_restr=restr(2,n);%salva o numero da ultima restrição anotada
    end
    
%% Rotação de coordenadas locais para GLOBAIS
    %Rotaciona a matriz de rigidez de elementos
    K(:,:,n) = transpose(T(:,:,n)) * k(:,:,n) * T(:,:,n);
    
    %Rotaciona a matriz de restrições
    if nbrig>0 && n_e_rig(n)==1
        cg1  =cl(:,1:3,n)  *r(:,:,n);
        cg2  =cl(:,4:6,n)  *r(:,:,n);
        cg3  =cl(:,7:9,n)  *r(:,:,n);
        cg4  =cl(:,10:12,n)*r(:,:,n);
        cg(:,:,n)=[cg1 cg2 cg3 cg4];
        %TESTAR cg(:,:,n)=cl(:,:,n)*T(:,:,n);
    end
    
    
%% Monta as matrizes da estrutura
    %Transformar os graus de liberdade de elementos para graus de liberdade da estrutura

    %Monta a matriz de rigidez global da estrutura apartir das matrizes de
    %rigidez globais das barras individuais
    for i=1:gln*2
        for j=1:12       
                S((bcn(n,i)),(bcn(n,j)))=...
                S((bcn(n,i)),(bcn(n,j)))+K(i,j,n);
        end
    end
end

%% Restrições por barra de deslocamento


    
    %Monta matriz de restrições global
    C=zeros(ult_restr,dof);%matriz de restrições de deslocamento das barras
    for n=1:nb
        if nbrig>0 && n_e_rig(n)==1
            jcont=1;
            for j=restr(1,n):restr(2,n)
                for i=1:gln*2
                    if n_e_rig_ex(n)==0
                        C(j,(bcn(n,i)))=cg(jcont,i,n);
                    else
                        C(j,(bcn(n,i)))=cg(jcont+1,i,n);%copia só depois da primeira linha
                    end
                end
                jcont=jcont+1;
            end
        end
        
    end

%% Restrições de deslocamentos

%Adiciona a rigidez dos apoios flexiveis
  
Su=S;%Kglobalu=Matriz de rigidez dos nós não resitritos
%(unrestrained) da estrutura em coordenadas globais

for laflex=1:naflex
    mtx=aflex(laflex,2);
    mty=aflex(laflex,3);
    mtz=aflex(laflex,4);
    mrx=aflex(laflex,5);
    mry=aflex(laflex,6);
    mrz=aflex(laflex,7);
    i=aflex(laflex,1);
    Su(i*6-5,i*6-5)=Su(i*6-5,i*6-5)+mtx;
    Su(i*6-4,i*6-4)=Su(i*6-4,i*6-4)+mty;
    Su(i*6-3,i*6-3)=Su(i*6-3,i*6-3)+mtz;
    Su(i*6-2,i*6-2)=Su(i*6-2,i*6-2)+mrx;
    Su(i*6-1,i*6-1)=Su(i*6-1,i*6-1)+mry;
    Su(i*6-0,i*6-0)=Su(i*6-0,i*6-0)+mrz;
end


%Anota quais nós devem ser removidos da matriz de rigidez por estarem
%vinculados externamente
udf=0;%udf=unrestrained degrees of freedom
rdf=0;%rdf=  restrained degrees of freedom

for n=1:nn
    for j=1:gln
        %Monta um vetor de carregamento contento apenas os nós deslocaveis
        if jfix(n,j)==0
            udf=udf+1;
        else 
            rdf=rdf+1;
            remov_l_c(rdf)=((n-1)*gln+j);
            %remov_l_c=Lista de linhas e colunas a serem removidos
        end
    end
end

%Organiza linhas a serem removidas
rdf_list=sort(remov_l_c,'descend');



%Remove linhas e colunas de Kglobal por estarem fixos

Cu=C;
for n=1:rdf
    Su(rdf_list(n),:)=0;
    Su(:,rdf_list(n))=0;
    Su(rdf_list(n),rdf_list(n))=1;
    Cu(:,rdf_list(n))=0;
end

%% Cálculo dos deslocamentos globais U=inv(K)*F

%invSu=inv(Su);


invSu=invChol_mex(Su);

%invSu=sparseinv(sparse(Su));

%invSu=decomposition(sparse(Su));
%equilibrate(Su);
 %gpuSu=gpuArray(single(Su));
 %gpuinvSu=inv(gpuSu);
 %invSu=gather(gpuinvSu);

Cu=sparse(Cu);
B=invSu*transpose(Cu);%\

M=Cu*B;

invM=inv(M);%testar com invChol_mex(

end
