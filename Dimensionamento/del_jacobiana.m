function [SF,SM] = del_jacobiana(EpA,Epap,del,fcd,n_conc,d,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd)
%
%
    EpAj=EpA+del(1);
    Epapj=Epap+del(2);
    kj=(Epapj-EpAj)/d/1000;%metros
    if not(abs(EpAj-Epapj)<1E-10)
        xaj=-EpAj/1000/kj;
    else
        xaj=0;
    end
    [SF,SM] = equacao_equilibrio(fcd,n_conc,EpAj,xaj,Epapj,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
end

