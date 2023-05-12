function [cc] = cc_tabuleiro(x,R,k,r,info)
%Aplica as reações do Fauchar em cargas nas longarinas
%   Considera inclusive inclinação da longaria
Vlong=info.longarinas.vao(k).longarina(1).xe-info.longarinas.vao(k).longarina(1).xb;
CIV=calc_CIV(Vlong);
[~,Nlonga]=size(info.longarinas.vao(k).longarina);
cc=zeros(Nlonga*3,4);
i=0;
for g=1:Nlonga
   i=i+1;
   barra=info.longarinas.vao(k).longarina(g).membros;
   posicao=x/Vlong;
   
   %cc=[Barra direcao posicao valor];
   cc(i,:)=[barra 3 posicao R((g-1)*6+3,1)*r(1,1,barra)*CIV];%carga em z local
   i=i+1;
   cc(i,:)=[barra 1 posicao R((g-1)*6+3,1)*r(1,3,barra)*CIV];%carga em x local
   i=i+1;
   cc(i,:)=[barra 4 posicao R((g-1)*6+4,1)*CIV];

end
end

