        figure(1)
        clf
        
        Qa_theta_LC_contido=QaMULT_theta_LC(contido);
        Mzk_MULT=Mzk(MULTi:MULTf);
        Myk_MULT=Myk(MULTi:MULTf);
        %Mzk_contido=Mzk_contido(contido);
        %Myk_contido=Myk_contido(contido);
        
        
        for i=1:MULTn
            polarplot([0 QaMULT_theta_LC(i)],[0 sqrt(Mzk_MULT(i)^2+Myk_MULT(i)^2)],'k')
            hold on
        end
        Mzk_contido=Mzk_MULT(contido);
        Myk_contido=Myk_MULT(contido);
        Qa_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);

        for i=1:sum(contido)
            polarplot([0 Qa_theta_LC_contido(i)],[0 Qa_rho_LC_contido(i)],'r')
        end
        polarplot([0 theta_proc(it)],[0 3000],'g')
        polarplot([0 theta_limite_max],[0 3000],'b--')
        polarplot([0 theta_limite_min],[0 3000],'b--')
        hold off