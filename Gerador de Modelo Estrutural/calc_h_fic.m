function [h_fic] = calc_h_fic(Umi,A,Uar)
%Calcula a espesura ficticia da seção transversal
%   De acordo com a NBR 6118:2014 anexo A
gama_h_fic=1+exp(-7.8+0.1*Umi);
h_fic=gama_h_fic*2*A/Uar;
end

