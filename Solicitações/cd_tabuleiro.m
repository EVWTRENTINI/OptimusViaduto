function cd = cd_tabuleiro(R,ini,fim,k,r,info)
%Aplica as reações do Fauchart em cargas nas longarinas
%   Considera inclusive inclinação da longaria
[~,Nlonga]=size(info.longarinas.vao(k).longarina);
cd=zeros(Nlonga*3,5);
i=0;
for g=1:Nlonga
   i=i+1;
   barra=info.longarinas.vao(k).longarina(g).membros;

   
%[Barra direcao inicio fim valor]
   cd(i,:)=[barra 3 ini fim R((g-1)*6+3,1)*r(1,1,barra)];%carga em z local
   i=i+1;
   cd(i,:)=[barra 1 ini fim R((g-1)*6+3,1)*r(1,3,barra)];%carga em x local
   i=i+1;
   cd(i,:)=[barra 4 ini fim R((g-1)*6+4,1)];

end
end

