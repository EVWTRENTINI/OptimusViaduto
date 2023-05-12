function [EpA,Epap,situacao,msg_erro] = det_estado_deformacao(secao,fck,gama_c,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw)
%Determina o estado de deformação
%   

situacao=true;
msg_erro='sem erro';

mult_jacobiana = .9;
parametros_concreto

[Nrdmax,Nrdmin] = Nrdmax_Nrdmin(secao,ap,aa,fcd,Epc2,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);


for mult_jacobiana = [.9 .8 .5]
    if and(Nrdmin<=Nsd,Nsd<=Nrdmax)
        vmax=max(secao(:,2));
        vmin=min(secao(:,2));
        halfa=vmax-vmin;%usa para desenho
        d=vmax-min(ap.y);  %metros
        EpA=0;
        Epap=0;
        cont=0;%conttestes
        limite_dif_norma=1E-2;
        limite_iteracoes=100;
        normp_prox=limite_dif_norma+1;%só pra entrar no while
        if config_draw.estado_def
            figure
        end
        while (normp_prox>limite_dif_norma && cont<limite_iteracoes)
            cont=cont+1;
            if cont==1
                del=1;
            else
                del=1E-5;
            end
            k=(Epap-EpA)/d/1000;%metros
            if not(abs(EpA-Epap)<1E-10)
                xa=-EpA/1000/k;
            else
                xa=0;%não existe
            end
            [SF,SM] = equacao_equilibrio(fcd,n_conc,EpA,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);

            [SFb,SMb] = del_jacobiana(EpA,Epap,[-del/2 0],fcd,n_conc,d,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            [SFf,SMf] = del_jacobiana(EpA,Epap,[+del/2 0],fcd,n_conc,d,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            j11=(SFf-SFb)/del;
            j21=(SMf-SMb)/del;
            [SFb,SMb] = del_jacobiana(EpA,Epap,[0 -del/2],fcd,n_conc,d,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            [SFf,SMf] = del_jacobiana(EpA,Epap,[0 +del/2],fcd,n_conc,d,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            j12=(SFf-SFb)/del;
            j22=(SMf-SMb)/del;

            j=[j11 j12;j21 j22];
            inv_j=inv(j)*mult_jacobiana;

            EpA_Epap_prox=[EpA;Epap]-inv_j*[SF;SM];

            EpA_prox=EpA_Epap_prox(1);
            Epap_prox=EpA_Epap_prox(2);
            k_prox=(Epap_prox-EpA_prox)/d/1000;%metros
            if not(abs(EpA_prox-Epap_prox)<1E-10)
                xa_prox=-EpA_prox/1000/k_prox;
            else
                xa_prox=0;
            end

            normp=sqrt(SF^2+SM^2);

            [SF_prox,SM_prox] = equacao_equilibrio(fcd,n_conc,EpA_prox,xa_prox,Epap_prox,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            normp_prox=sqrt(SF_prox^2+SM_prox^2);

            damping=1;
            if cont>1
                while normp_prox>normp
                    damping=damping/2;
                    if damping<1E-10
                        break
                    end
                    EpA_Epap_prox=[EpA;Epap]-inv_j*damping*[SF;SM];
                    EpA_prox=EpA_Epap_prox(1);
                    Epap_prox=EpA_Epap_prox(2);
                    k_prox=(Epap_prox-EpA_prox)/d/1000;%metros
                    if not(abs(EpA_prox-Epap_prox)<1E-10)
                        xa_prox=-EpA_prox/1000/k_prox;
                    else
                        xa_prox=0;
                    end
                    [SF_prox,SM_prox] = equacao_equilibrio(fcd,n_conc,EpA_prox,xa_prox,Epap_prox,Epcu,Epc2,secao,vmax,ap,aa,Nsd,Msd,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
                    normp_prox=sqrt(SF_prox^2+SM_prox^2);
                end
            end

            EpA=EpA_Epap_prox(1);
            Epap=EpA_Epap_prox(2);

            if config_draw.estado_def
                k=(Epap-EpA)/d/1000;%metros
                if not(abs(EpA-Epap)<1E-10)
                    xa=-EpA/1000/k;
                else
                    xa=0;
                end

                fa=gca;
                draw_def_especifica_mesma_janela
            end
        end
        if cont==limite_iteracoes
            situacao=false;
            msg_erro=[' não são iguais dentro do limite de iterações'];
        end

    end
    if not(EpA < -Epcu)
        break
    end
end

end

