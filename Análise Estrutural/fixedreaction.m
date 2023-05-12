function f_fem = fixedreaction(cd,cc,ct,jb,joints,broty,A,E)
[nb,~]=size(jb);
[nbcd,~]=size(cd);
[nbcc,~]=size(cc);
[nbct,~]=size(ct);
f_fem=zeros(nb,12);
[nbroty,~]=size(broty);%numero de barras com rotula em y
barracarregada=0;
for linhacd=1:nbcd%Cagas distribuidas
    n=cd(linhacd,1);
    barracarregada=0;
    %Comprimento das barras
    lb(n)=((joints(jb(n,1),1)-joints(jb(n,2),1))^2 + ...
        (joints(jb(n,1),2)-joints(jb(n,2),2))^2 + ...
        (joints(jb(n,1),3)-joints(jb(n,2),3))^2)^.5;
    for i=1:6 %Percorre os graus de liberdade
        if cd(linhacd,2)==i %Verifica se o carregamento esta na posição i
            p=cd(linhacd,5)*(lb(n)*cd(linhacd,4)-lb(n)*cd(linhacd,3));
            ar=(lb(n)*cd(linhacd,4)-lb(n)*cd(linhacd,3))/2+lb(n)*cd(linhacd,3);
            l=lb(n);
            br=l-ar;
            a=cd(linhacd,3)*l;
            b=l-cd(linhacd,4)*l;
            c=l-a-b;
            
            if cd(linhacd,2)==1%Verifica se é força em x
                f_fem(n,i)=f_fem(n,i)-p*br/l;
                f_fem(n,i+6)=f_fem(n,i+6)-p*ar/l;
                barracarregada=1;
            end
            
            if cd(linhacd,2)==2 %Verifica se é força em y
                ma=-cd(linhacd,5)/12/l^2*(4*l*((b+c)^3-b^3)-3*((b+c)^4-b^4));
                mb=+cd(linhacd,5)/12/l^2*(4*l*((a+c)^3-a^3)-3*((a+c)^4-a^4));
                f_fem(n,6)=f_fem(n,6)  +ma;
                f_fem(n,12)=f_fem(n,12)+mb;
                f_fem(n,2)=f_fem(n,2)+(+ma+mb-cd(linhacd,5)*c*br)/l;%corrigindo pra distribuida
                f_fem(n,8)=f_fem(n,8)-(cd(linhacd,5)*c+(+ma+mb-cd(linhacd,5)*c*br)/l);%corrigindo pra distribuida
                barracarregada=1;
            end
            if cd(linhacd,2)==3 %Verifica se é força em z
                for lbry=1:nbroty
                    if broty(lbry,1)==n %A barra atual possui rotula? SE SIM
                        if broty(lbry,2)==1 && broty(lbry,3)==1 && barracarregada==0%birotulada
                            f_fem(n,3)=f_fem(n,3)-p*br/l;
                            f_fem(n,9)=f_fem(n,9)-p*ar/l;
                            barracarregada=1;
                        elseif broty(lbry,2)==0 && broty(lbry,3)==1 && barracarregada==0%engaste-rotula
                            ma=-((cd(linhacd,5)/(8*l^2))*(b^4-(b+c)^4+2*c*l^2*(2*b+c)));
                            f_fem(n,5)=f_fem(n,5)  -ma;
                            f_fem(n,3)=f_fem(n,3)+(+ma-cd(linhacd,5)*c*br)/l;
                            f_fem(n,9)=f_fem(n,9)-(cd(linhacd,5)*c+(+ma-cd(linhacd,5)*c*br)/l);
                            barracarregada=1;
                        elseif broty(lbry,2)==1 && broty(lbry,3)==0 && barracarregada==0%rotula-engaste
                            mb=((cd(linhacd,5)/(8*l^2))*(a^4-(a+c)^4+2*c*l^2*(2*a+c)));
                            f_fem(n,11)=f_fem(n,11)  -mb;
                            f_fem(n,3)=f_fem(n,3)+(+mb-cd(linhacd,5)*c*br)/l;
                            f_fem(n,9)=f_fem(n,9)-(cd(linhacd,5)*c+(+mb-cd(linhacd,5)*c*br)/l);
                            barracarregada=1;
                        end
                    end
                end
                if barracarregada==0%A BARRA FOI CARREGADA COMO SE TIVESSE ROTULA? SE AINDA NAO EH PQ NAO EH ROTULADA
                    %biengastada
                    ma=-cd(linhacd,5)/12/l^2*(4*l*((b+c)^3-b^3)-3*((b+c)^4-b^4));
                    mb=+cd(linhacd,5)/12/l^2*(4*l*((a+c)^3-a^3)-3*((a+c)^4-a^4));
                    f_fem(n,5)=f_fem(n,5)  -ma;
                    f_fem(n,11)=f_fem(n,11)-mb;
                    f_fem(n,3)=f_fem(n,3)+(+ma+mb-cd(linhacd,5)*c*br)/l;
                    f_fem(n,9)=f_fem(n,9)-(cd(linhacd,5)*c+(+ma+mb-cd(linhacd,5)*c*br)/l);
                    barracarregada=1;
                end
                
                
                
            end
            
            if cd(linhacd,2)==4%Verifica se é momento em x
                f_fem(n,4)=f_fem(n,4)-p*br/l;
                f_fem(n,10)=f_fem(n,10)-p*ar/l;
                barracarregada=1;
            end
            if cd(linhacd,2)==5 %Verifica se é momento em y
            end
            if cd(linhacd,2)==6 %Verifica se é momento em z
            end
        end
    end
end


for linhacc=1:nbcc%Cargas concentradas
    n=cc(linhacc,1);
    barracarregada=0;
    %Comprimento das barras
    lb(n)=((joints(jb(n,1),1)-joints(jb(n,2),1))^2 + ...
        (joints(jb(n,1),2)-joints(jb(n,2),2))^2 + ...
        (joints(jb(n,1),3)-joints(jb(n,2),3))^2)^.5;
    for i=1:6 %Percorre os graus de liberdade
        if cc(linhacc,2)==i %Verifica se o carregamento esta na posição i
            p=cc(linhacc,4);
            a=lb(n)*cc(linhacc,3);
            l=lb(n);
            b=l-a;
            
            if cc(linhacc,2)==1%Verifica se é força em x
                f_fem(n,i)=f_fem(n,i)-p*b/l;
                f_fem(n,i+6)=f_fem(n,i+6)-p*a/l;
                barracarregada=1;
            end
            if cc(linhacc,2)==2 %Verifica se é força em y
                ma=-p*a*b^2/l^2;
                mb=+p*a^2*b/l^2;
                f_fem(n,i)=f_fem(n,i)-p*b/l^3*(l^2-a^2+a*b);
                f_fem(n,i+6)=f_fem(n,i+6)-p*a/l^3*(l^2-b^2+a*b);
                f_fem(n,6)=f_fem(n,6)  +ma;
                f_fem(n,12)=f_fem(n,12)+mb;
                barracarregada=1;
            end
            if cc(linhacc,2)==3 %Verifica se é força em z
                
                for lbry=1:nbroty
                    if broty(lbry,1)==n %A barra atual possui rotula? SE SIM
                        if broty(lbry,2)==1 && broty(lbry,3)==1%birotulada
                            f_fem(n,i)=f_fem(n,i)-p*b/l;
                            f_fem(n,i+6)=f_fem(n,i+6)-p*a/l;
                            barracarregada=1;
                        elseif broty(lbry,2)==0 && broty(lbry,3)==1%engaste-rotula
                            ma=p*a*b/2/l^2*(l+b);
                            f_fem(n,i)=f_fem(n,i)-p*b/l-ma/l;
                            f_fem(n,i+6)=f_fem(n,i+6)-p*a/l+ma/l;
                            f_fem(n,5)=f_fem(n,5)+ma;
                            barracarregada=1;
                        elseif broty(lbry,2)==1 && broty(lbry,3)==0%rotula-engaste
                            mb=-p*a*b/2/l^2*(l+a);
                            f_fem(n,i)=f_fem(n,i)-p*b/l-mb/l;
                            f_fem(n,i+6)=f_fem(n,i+6)-p*a/l+mb/l;
                            f_fem(n,11)=f_fem(n,11)+mb;
                            barracarregada=1;
                        end
                    end
                end
                if barracarregada==0 %A barra atual possui rotula? SE NÃO
                    %biengastada
                    ma=+p*a*b^2/l^2;
                    mb=-p*a^2*b/l^2;
                    f_fem(n,i)=f_fem(n,i)-p*b/l^3*(l^2-a^2+a*b);
                    f_fem(n,i+6)=f_fem(n,i+6)-p*a/l^3*(l^2-b^2+a*b);
                    f_fem(n,5)=f_fem(n,5)  +ma;
                    f_fem(n,11)=f_fem(n,11)+mb;
                    barracarregada=1;
                end
                
            end
            if cc(linhacc,2)==4%Verifica se é momento em x
                f_fem(n,4)=f_fem(n,4)-p*b/l;
                f_fem(n,10)=f_fem(n,10)-p*a/l;
                barracarregada=1;
            end
            if cc(linhacc,2)==5 %Verifica se é momento em y
                for lbry=1:nbroty
                    if broty(lbry,1)==n %A barra atual possui rotula? SE SIM
                        if broty(lbry,2)==1 && broty(lbry,3)==1%birotulada
                            f_fem(n,3)=f_fem(n,3)+(-p)/l;
                            f_fem(n,9)=f_fem(n,9)+(+p)/l;
                            barracarregada=1;
                        elseif broty(lbry,2)==0 && broty(lbry,3)==1%engaste-rotula
                            ma=-p/2/l^2*(3*b^2-l^2);
                            f_fem(n,3)=f_fem(n,3)+(-ma-p)/l;
                            f_fem(n,9)=f_fem(n,9)+(+ma+p)/l;
                            f_fem(n,5)=f_fem(n,5)+ma;
                            barracarregada=1;
                        elseif broty(lbry,2)==1 && broty(lbry,3)==0%rotula-engaste
                            mb=+p/2/l^2*(l^2-3*a^2);
                            f_fem(n,3)=f_fem(n,3)+(-mb-p)/l;
                            f_fem(n,9)=f_fem(n,9)+(+mb+p)/l;
                            f_fem(n,11)=f_fem(n,11)+mb;
                            barracarregada=1;
                        end
                    end
                end
                if barracarregada==0  %A barra atual possui rotula? SE NÃO
                    ma=-p*b/l^2*(3*b-2*l);
                    mb=p*a/l^2*(2*l-3*a);
                    ra=-(ma+mb+p)/l;
                    rb=-ra;
                    f_fem(n,5)=f_fem(n,5)  +ma;
                    f_fem(n,11)=f_fem(n,11)+mb;
                    f_fem(n,3)=f_fem(n,3) +ra;
                    f_fem(n,9)=f_fem(n,9) +rb;
                    barracarregada=1;
                end
                
                
                
            end
            if cc(linhacc,2)==6 %Verifica se é momento em z
                ma=-p*b/l^2*(3*b-2*l);
                mb=p*a/l^2*(2*l-3*a);
                ra=(ma+mb+p)/l;
                rb=-ra;
                f_fem(n,6)=f_fem(n,6)  +ma;
                f_fem(n,12)=f_fem(n,12)+mb;
                f_fem(n,2)=f_fem(n,2) +ra;
                f_fem(n,8)=f_fem(n,8) +rb;
                barracarregada=1;
            end
        end
    end
end


for linhact=1:nbct%Cargas de temperatura
    n=ct(linhact,1);
    %Comprimento das barras
    lb(n)=((joints(jb(n,1),1)-joints(jb(n,2),1))^2 + ...
        (joints(jb(n,1),2)-joints(jb(n,2),2))^2 + ...
        (joints(jb(n,1),3)-joints(jb(n,2),3))^2)^.5;
    f_fem(n,1)=f_fem(n,1)+ct(linhact,3)*ct(linhact,2)*E(n)*A(n);
    f_fem(n,7)=f_fem(n,7)-ct(linhact,3)*ct(linhact,2)*E(n)*A(n);
end