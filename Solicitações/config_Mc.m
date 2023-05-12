% Combinação ultima normal
gama_gd=1.35;% desfavoravel, pontes em geral
gama_gf=1.00;% favoravel, pontes em geral

gama_q=1.50;% pontes

            %PP %VT_MULT %RFT %VT  %CEP
Mc=single([gama_gf   gama_q 0.72 0.84 0.00;...1
           gama_gf   1.05   1.20 0.84 0.00;...2
           gama_gf   1.05   0.72 1.40 0.00;...3
           gama_gd   gama_q 0.72 0.84 0.00;...4
           gama_gd   1.05   1.20 0.84 0.00;...5
           gama_gd   1.05   0.72 1.40 0.00;...6
           gama_gf   1.05   0.72 0.84 1.00;...7
           gama_gd   1.05   0.72 0.84 1.00]);%8

       
% Combinação especial ou de construção
gama_gd_esp=1.25;% desfavoravel, pontes em geral
gama_gf_esp=1.00;% favoravel, pontes em geral

psi_2 = .3; % para combinaçao quase permanente, flecha 02/03/23, não conferido se tem .3 hardcodado em algum outro lugar, mudado so na envoltoria.
