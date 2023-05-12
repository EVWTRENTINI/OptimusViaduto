function [ENV] = smartENV(Fk,sp,Mc,info)
%Controi a envoltória do esforço selecionado para a barra selecionada
%   Checa se determinado esforço construibui para a envoltoria, se sim ele
%   é adicionado se não ele é ignorado.
if length(size(Fk)) == 3
    Fk=reshape(Fk,sp,[]);%Verificar tempo de execução
end

PPi=info.LC.PP_ini;
MULTi=info.LC.MULT_ini;
VEICi=info.LC.VEIC_ini;
FRENi=info.LC.FREN_ini;
RFTi=info.LC.RFT_ini;
V90i=info.LC.V90_ini;
CEPi=info.LC.CEP_ini;
Qai=MULTi;

PPf=info.LC.PP_fim;
MULTf=info.LC.MULT_fim;
VEICf=info.LC.VEIC_fim;
FRENf=info.LC.FREN_fim;
RFTf=info.LC.RFT_fim;
V90f=info.LC.V90_fim;
CEPf=info.LC.CEP_fim;
Qaf=FRENf;

PPn=PPf-PPi+1;
MULTn=MULTf-MULTi+1;
VEICn=VEICf-VEICi+1;
FRENn=FRENf-FRENi+1;
RFTn=RFTf-RFTi+1;
V90n=V90f-V90i+1;
CEPn=CEPf-CEPi+1;

ny=info.LC.MULT_fim-info.LC.MULT_ini+1;


[sMc,~]=size(Mc);               %Numero de combinações de gama

PREENV.MAX=zeros(sp,sMc,'single');
PREENV.MIN=zeros(sp,sMc,'single');

FkVEIC=zeros(1,VEICn);
FkVT=zeros(1,V90n);
FkCEP=zeros(1,CEPn);


% SE trocar a ordem do for fica mais rapido, assim não precisa descobrir o
% maximo novamente pra cada combinação uma vez que não é alterado
for iMc=1:sMc
    %% PP
   
    PREENV.MAX(:,iMc)=Fk(:,1)*Mc(iMc,1);
    PREENV.MIN(:,iMc)=Fk(:,1)*Mc(iMc,1);
    
    for ip=1:sp
        %% Qa %MULT
        
        for faixa=1:ny
            if Fk(ip,MULTi+faixa-1)>0
                PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+Fk(ip,MULTi+faixa-1)*Mc(iMc,2);
            else
                PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)+Fk(ip,MULTi+faixa-1)*Mc(iMc,2);
            end
        end
        
        %Qa %VEIC
        
        for pVEIC=1:VEICn %montar vetor que anota esforço neste ponto pra todas as posições
            FkVEIC(pVEIC)=Fk(ip,VEICi+pVEIC-1);
        end
        maxFkVEIC=max(FkVEIC);
        minFkVEIC=min(FkVEIC);
        if maxFkVEIC>0
            PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+maxFkVEIC*Mc(iMc,2);
        end
        if minFkVEIC<0
            PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)+minFkVEIC*Mc(iMc,2);
        end
        
        %Qa %FREN
        
        PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+abs(Fk(ip,FRENi))*Mc(iMc,2);
        PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)-abs(Fk(ip,FRENi))*Mc(iMc,2);
        
        %% RFT
        
        if Fk(ip,RFTi)>0
            PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+Fk(ip,RFTi)*Mc(iMc,3);
        else
            PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)+Fk(ip,RFTi)*Mc(iMc,3);
        end
        
        %% VT
        
        for iVT=1:V90n %montar vetor que anota esforço neste ponto pra todas as posições
            FkVT(iVT)=abs(Fk(ip,V90i+iVT-1));
        end
        maxFkVT=max(FkVT);
        
        PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+maxFkVT*Mc(iMc,4);
        PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)-maxFkVT*Mc(iMc,4);
        
        %% CEP
        
        if not(Mc(iMc,5))==0
            for iCEP=1:CEPn %montar vetor que anota esforço neste ponto pra todas as posições
                FkCEP(iCEP)=abs(Fk(ip,CEPi+iCEP-1));
            end
            maxFkCEP=max(FkCEP);
            
            PREENV.MAX(ip,iMc)=PREENV.MAX(ip,iMc)+maxFkCEP*Mc(iMc,5);
            PREENV.MIN(ip,iMc)=PREENV.MIN(ip,iMc)-maxFkCEP*Mc(iMc,5);
            
        end
    end
end

ENV.MAX=max(PREENV.MAX,[],2);
ENV.MIN=min(PREENV.MIN,[],2);

end

