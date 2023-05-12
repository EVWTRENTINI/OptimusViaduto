function jl = Ff2jl(Ff,k,jl,r,viaduto,info)
%Aplica a força de frenagem Ff no vão k
%   
hpav=viaduto.hpav;
n_longa=viaduto.vao(k).n_longarinas;
n_no=n_longa*2;%numero de nós em que serao aplicadas as forças
Ffl=Ff/n_no;%força de frenagem por extremidade de longarina
for g=1:n_longa
    ZCG=-info.longarinas.vao(k).longarina(g).ZCG;
    m=info.longarinas.vao(k).longarina(g).membros;%membro
    Mf=Ff*(ZCG+hpav)*r(1,1,m);%momento de frenagem
    Mfl=Mf/n_no;%momento de frenagem por por extremidade de longarina
    
    for j=1:2 %i=1 nó inicial %i=2 nó final
        switch j
            case 1
                no=info.longarinas.vao(k).longarina(g).primeiro_no;
            case 2
                no=info.longarinas.vao(k).longarina(g).ultimo_no;
        end
        glfx=no*6-5;%grau de liberdade de força em X
        glfz=no*6-3;%grau de liberdade de força em Z
        glmy=no*6-1;%grau de liberdade de momento em Y
        jl(glfx)=Ffl*r(1,1,m);
        jl(glfz)=Ffl*r(1,3,m);
        jl(glmy)=Mfl;
    end
end
end

