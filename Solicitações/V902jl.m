function jl = V902jl(Fv,h,k,jl,viaduto,info)
%Aplica a for�a do vento Fv no v�o k

hpav=viaduto.hpav;
n_longa=viaduto.vao(k).n_longarinas;
n_no=n_longa*2;%numero de n�s em que serao aplicadas as for�as
Fvl=Fv/n_no;%for�a do vento por extremidade de longarina
for g=1:n_longa
    ZCG=-info.longarinas.vao(k).longarina(g).ZCG;
    %m=info.longarinas.vao(k).longarina(g).membros;%membro
    Mv=Fv*(ZCG+hpav+h);%momento do vento
    Mvl=Mv/n_no;%momento do vento por por extremidade de longarina
    
    for j=1:2 %i=1 n� inicial %i=2 n� final
        switch j
            case 1
                no=info.longarinas.vao(k).longarina(g).primeiro_no;
            case 2
                no=info.longarinas.vao(k).longarina(g).ultimo_no;
        end
        glfy=no*6-4;%grau de liberdade de for�a em y
        glmx=no*6-2;%grau de liberdade de momento em x
        
        jl(glfy)=Fvl;
        jl(glmx)=-Mvl;
    end
end
end

