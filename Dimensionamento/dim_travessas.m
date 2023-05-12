function [info,situacao,msg_erro]=dim_travessas(ENV,viaduto,info,barra_rigida,xb,tot_ponto,config_draw)
% Dimensiona as travessas

situacao=true;
msg_erro='sem erro';




for it=1:viaduto.n_apoios % indice da travessa
    fck=viaduto.apoio(it).travessa.fck/1E6;
    fyd = viaduto.fyk / viaduto.gama_s; % kN/cm²
    Es=viaduto.Es;%kN/cm²
    alfa_e=viaduto.alfa_e;
    gama_c=viaduto.gama_c;
    c=viaduto.apoio(it).travessa.c;
    b=viaduto.apoio(it).travessa.b;
    h=viaduto.apoio(it).travessa.h;
    d=h*.95-c;
    membros=info.travessas.apoio(it).membros;
    n_membros=length(membros);
    
    %% Dimensionamento a flexão
    
    % Momento fletor positivo
    Aslp=cell(1,n_membros);
    for i=1:n_membros
        Aslp{i}=zeros(1,tot_ponto(membros(i)));
        for j=1:tot_ponto(membros(i))
            if barra_rigida{membros(i)}==1
                Msd=0;
            else
                Msd=ENV.apoio(it).barra(i).MAX.My(j)/1000;%kN.m
                if Msd<0
                    Msd=0;
                end
            end
            [Aslp{i}(j),situacao,msg_erro]=dim_flexao_corrige_fadiga(Msd,0,0,h,b,d,fck,gama_c,alfa_e,fyd,Es);
            if not(situacao)
                msg_erro=[msg_erro '.' 'Travessa em momento positivo, apoio ' num2str(it) ', trecho ' num2str(i) '.'];
                return
            end
        end
    end
    
    info.travessas.apoio(it).Aslp=Aslp;
    
    % Momento fletor negativo
    Asln=cell(1,n_membros);
    for i=1:n_membros
        Asln{i}=zeros(1,tot_ponto(membros(i)));
        for j=1:tot_ponto(membros(i))
            if barra_rigida{membros(i)}==1
                Msd=0;
            else
                Msd=-ENV.apoio(it).barra(i).MIN.My(j)/1000;%kN.m
                if Msd<0
                    Msd=0;
                end
            end
            
            [ Asln{i}(j),situacao,msg_erro]=dim_flexao_corrige_fadiga(Msd,0,0,h,b,d,fck,gama_c,alfa_e,fyd,Es);
            if not(situacao)
                msg_erro=[msg_erro '. Travessa em momento negativo' num2str(it) ', trecho ' num2str(i) '.'];
                return
            end
        end
    end
    
    info.travessas.apoio(it).Asln=Asln;
    
    %% Desenho
    % figure(1234)
    % clf
    % hold on
    % ori=0;
    %
    %
    % for i=1:n_membros
    %     if barra_rigida{membros(i)}==1
    %         cor='g';
    %     else
    %         cor='k';
    %     end
    %     for j=1:tot_ponto(membros(i))-1
    %
    %         plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[0 0],cor)%barra
    %         plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[-ENV.apoio(it).barra(i).MAX.My(j) -ENV.apoio(it).barra(i).MAX.My(j+1)],'r')%esforço
    %         plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[-ENV.apoio(it).barra(i).MIN.My(j) -ENV.apoio(it).barra(i).MIN.My(j+1)],'r')%esforço
    %
    %         plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[-Aslp{i}(j)*30000 -Aslp{i}(j+1)*30000],'b')%armadura
    %         plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[ Asln{i}(j)*30000   Asln{i}(j+1)*30000],'b')%armadura
    %     end
    %
    %     ori=ori+xb(tot_ponto(membros(i)),membros(i));
    % end
    % hold off
    %% Dimensionamento a esforço cortante e torção
    Ast=cell(1,n_membros);
    Aslt=cell(1,n_membros);
    
    for i=1:n_membros
        Ast{i}=zeros(1,tot_ponto(membros(i)));
        Aslt{i}=zeros(1,tot_ponto(membros(i)));
        for j=1:tot_ponto(membros(i))
            if barra_rigida{membros(i)}==1
                Vsd=0;
                Tsd=0;
            else
                Vsd=  max(abs([ENV.apoio(it).barra(i).MAX.Vz(j)/1000 ENV.apoio(it).barra(i).MIN.Vz(j)/1000]));%kN
                Tsd=  max(abs([ENV.apoio(it).barra(i).MAX.Tx(j)/1000 ENV.apoio(it).barra(i).MIN.Tx(j)/1000]));%kN.m
                Mdmax=max(abs([ENV.apoio(it).barra(i).MAX.My(j)/1000 ENV.apoio(it).barra(i).MIN.My(j)/1000]));%kN.m
            end
            A=b*h;
            u=2*b+2*h;
            c1=c+.016+.0125/2;
            Ae=(b-2*c1)*(h-2*c1);
            I=b*h^3/12;
            ymin=-h/2;
            
            
            
            [Ast{i}(j),Aslt{i}(j),situacao,msg_erro] = dim_cisalhamento(Vsd,0,0,Tsd,0,0,0,d,A,u,Ae,I,b,c1,ymin,Mdmax,fck,gama_c);
            if not(situacao)
                msg_erro=[msg_erro '. Travessa ' num2str(it) '.'];
                return
            end
        end
    end
    
    info.travessas.apoio(it).Ast=Ast;
    info.travessas.apoio(it).Aslt=Aslt;
    
%         %% Desenho
%     figure(1235)
%     clf
%     hold on
%     ori=0;
%     
%     
%     for i=1:n_membros
%         if barra_rigida{membros(i)}==1
%             cor='g';
%         else
%             cor='k';
%         end
%         for j=1:tot_ponto(membros(i))-1
%     
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[0 0],cor)%barra
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[abs(ENV.apoio(it).barra(i).MAX.Tx(j)) abs(ENV.apoio(it).barra(i).MAX.Tx(j+1))],'r')%esforço
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[abs(ENV.apoio(it).barra(i).MIN.Tx(j)) abs(ENV.apoio(it).barra(i).MIN.Tx(j+1))],'r')%esforço
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[abs(ENV.apoio(it).barra(i).MAX.Vz(j)) abs(ENV.apoio(it).barra(i).MAX.Vz(j+1))],'g')%esforço
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[abs(ENV.apoio(it).barra(i).MIN.Vz(j)) abs(ENV.apoio(it).barra(i).MIN.Vz(j+1))],'g')%esforço
%             
%             
%             
%             
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[ Ast{i}(j)*100000  Ast{i}(j+1)*100000],'b')%armadura
%             plot([xb(j,membros(i))+ori xb(j+1,membros(i))+ori],[ Aslt{i}(j)*100000   Aslt{i}(j+1)*100000],'k')%armadura
%         end
%     
%         ori=ori+xb(tot_ponto(membros(i)),membros(i));
%     end
%     hold off
    
    
end

end