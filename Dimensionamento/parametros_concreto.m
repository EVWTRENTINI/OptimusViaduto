if fck<=50
    alfa_c=0.85;
    lambda=.8;
    Epcu=3.5; % /1000
    n_conc=2; % n do parabola retangulo 6118:2014
    Epc2=2; % /1000
end
if fck>50
    alfa_c=0.85*(1-(fck-50)/200);
    lambda=.8-(fck-50)/400;
    Epcu=2.6+35*((90-fck)/100)^4; % /1000
    n_conc=1.4+23.4*((90-fck)/100)^4; % n do parabola retangulo 6118:2014
    Epc2=(2+.085*(fck-50)^0.53); % /1000
    if Epc2>Epcu
        Epc2=Epcu;
    end
end
fcd=fck/gama_c;