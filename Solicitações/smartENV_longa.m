function [ENV] = smartENV_longa(Fk,sp,Mc,info,CIA,xb)
%Controi a envoltória do esforço selecionado para a barra selecionada
%   Checa se determinado esforço construibui para a envoltoria, se sim ele
%   é adicionado se não ele é ignorado.

Vlonga=xb(sp);

Fk=reshape(Fk,sp,[]);%Verificar tempo de execução

PPi=info.LC.PP_ini;
MULTi=info.LC.MULT_ini;
VEICi=info.LC.VEIC_ini;

PPf=info.LC.PP_fim;
MULTf=info.LC.MULT_fim;
VEICf=info.LC.VEIC_fim;

PPn=PPf-PPi+1;
MULTn=MULTf-MULTi+1;
VEICn=VEICf-VEICi+1;

ny=info.LC.MULT_fim-info.LC.MULT_ini+1;

[sMc,~]=size(Mc);    %Numero de combinações de gama

PREENV.MAX=zeros(sp,sMc,'single');
PREENV.MIN=zeros(sp,sMc,'single');

FkVEIC=zeros(1,VEICn);

for iMc=1:sMc
    %% PP
    
    PREENV.MAX(:,iMc)=Fk(:,1)*Mc(iMc,1);
    PREENV.MIN(:,iMc)=Fk(:,1)*Mc(iMc,1);
    
    for ip=1:sp
        McCIA=Mc(iMc,2);
        %verifica se o ponto esta a menos de 5 metros do apoio
        if or(xb(ip)<=5,(Vlonga-xb(ip))<=5) 
            McCIA=Mc(iMc,2)*CIA;
        end
        %% Qa
        %Qa %MULT
        
        for faixa=1:ny
            if Fk(ip,MULTi+faixa-1)>0
                PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+Fk(ip,MULTi+faixa-1)*McCIA;
            else
                PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)+Fk(ip,MULTi+faixa-1)*McCIA;
            end
        end
        
        %Qa %VEIC
        
        for pVEIC=1:VEICn %montar vetor que anota esforço neste ponto pra todas as posições
            FkVEIC(pVEIC)=Fk(ip,VEICi+pVEIC-1);
        end
        maxFkVEIC=max(FkVEIC);
        minFkVEIC=min(FkVEIC);
        if maxFkVEIC>0
            PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+maxFkVEIC*McCIA;
        end
        if minFkVEIC<0
            PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)+minFkVEIC*McCIA;
        end
    end
end

ENV.MAX=max(PREENV.MAX,[],2);
ENV.MIN=min(PREENV.MIN,[],2);

end

