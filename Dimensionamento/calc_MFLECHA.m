function [MFLECHA] = calc_MFLECHA(Fk,sp,Mc,info,CIA,xb)
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

FkVEIC = zeros(1,VEICn,'single');
MFLECHA.MULT = zeros(sp,sMc,'single');
MFLECHA.VEIC = zeros(sp,sMc,'single');

nm = ceil(sp/2); %nó do meio
for pVEIC=1:VEICn %montar vetor que anota esforço no nó do meio pra todas as posições de veiculo tipo
    FkVEIC(pVEIC)=Fk(nm,VEICi+pVEIC-1);
end
[~,i_veic_max] = max(FkVEIC); % indice do maximo no vetor FkVEIC
VEICMAXn = VEICi+i_veic_max-1; % indice do caso de carregamento da posição do veiculo tipo de maior momento
for iMc=1:sMc
    %% PP
    MFLECHA.PP = Fk(:,1)*Mc(iMc,1);

    
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
                MFLECHA.MULT(ip,iMc)=MFLECHA.MULT(ip,iMc)+Fk(ip,MULTi+faixa-1)*McCIA;
            end
        end
        
        %Qa %VEIC

        MFLECHA.VEIC(ip,iMc)=Fk(ip,VEICMAXn)*McCIA;


    end
end

MFLECHA.MULT=max(MFLECHA.MULT,[],2);
MFLECHA.VEIC=max(MFLECHA.VEIC,[],2);

end

