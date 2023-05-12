function [Msd,theta] = momento_max_abs(theta_proc,Mzk,Myk,Mc,LC)
%
%

tol_ang=0.0001; % Tolerancia angular

PPi=LC.PP_ini;
MULTi=LC.MULT_ini;
VEICi=LC.VEIC_ini;
FRENi=LC.FREN_ini;
RFTi=LC.RFT_ini;
V90i=LC.V90_ini;
CEPi=LC.CEP_ini;


PPf=LC.PP_fim;
MULTf=LC.MULT_fim;
VEICf=LC.VEIC_fim;
FRENf=LC.FREN_fim;
RFTf=LC.RFT_fim;
V90f=LC.V90_fim;
CEPf=LC.CEP_fim;


PPn=PPf-PPi+1;
MULTn=MULTf-MULTi+1;
VEICn=VEICf-VEICi+1;
FRENn=FRENf-FRENi+1;
RFTn=RFTf-RFTi+1;
V90n=V90f-V90i+1;
CEPn=CEPf-CEPi+1;



[sMc,~]=size(Mc);  %Numero de combinações de gama
%theta_env=[0 45 90 135 180 225 270 315 360]*pi/180;
%theta_proc=0:30*pi/180:360*pi/180;
n_pontos_env=length(theta_proc);
MzdENV=zeros(1,n_pontos_env,'single');
MydENV=zeros(1,n_pontos_env,'single');
rhoENV=zeros(n_pontos_env,sMc,'single');
thetaENV=zeros(n_pontos_env,sMc,'single');

%% Calcula angulo da resultante de todos os casos de carregamento

n_LC=length(Mzk);
%theta=zeros(1,n_LC);

theta_LC=wrapTo2Pi(atan2(Myk,Mzk));
%rho=sqrt(Myk.^2+Mzk.^2);



%polarplot(theta,rho)
%%



for it=1:length(theta_proc)
    
    theta_limite_max=wrapTo2Pi(theta_proc(it)+pi/2);
    theta_limite_min=wrapTo2Pi(theta_proc(it)-pi/2);

    
    %% Qa
    %Qa MULT
    QaMULT_theta_LC=theta_LC(MULTi:MULTf);
    contido=confere_intervalo(theta_proc(it),theta_limite_max,theta_limite_min,QaMULT_theta_LC,tol_ang);
    ind_MULT=false(1,n_LC);
    ind_MULT(MULTi:MULTf)=contido;
    
    Myk_MULT_max(it)=sum(Myk(ind_MULT));
    Mzk_MULT_max(it)=sum(Mzk(ind_MULT));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Qa_theta_LC_contido=QaMULT_theta_LC(contido);
%         Mzk_MULT=Mzk(MULTi:MULTf);
%         Myk_MULT=Myk(MULTi:MULTf);
%         %Mzk_contido=Mzk_contido(contido);
%         %Myk_contido=Myk_contido(contido);
%         
%         
%         for i=1:MULTn
%             polarplot([0 QaMULT_theta_LC(i)],[0 sqrt(Mzk_MULT(i)^2+Myk_MULT(i)^2)],'k')
%             hold on
%         end
%         Mzk_contido=Mzk_MULT(contido);
%         Myk_contido=Myk_MULT(contido);
%         Qa_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);
% 
%         for i=1:sum(contido)
%             polarplot([0 Qa_theta_LC_contido(i)],[0 Qa_rho_LC_contido(i)],'r')
%         end
%         polarplot([0 theta_proc(it)],[0 3000],'g')
%         polarplot([0 theta_limite_max],[0 3000],'b--')
%         polarplot([0 theta_limite_min],[0 3000],'b--')
%         hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %Qa VEIC
    QaVEIC_theta_LC=theta_LC(VEICi:VEICf);
    Mzk_VEIC=Mzk(VEICi:VEICf);
    Myk_VEIC=Myk(VEICi:VEICf);
    
    vec_theta_procura=zeros(1,VEICn);
    vec_theta_procura(:)=theta_proc(it);
    diferenca_angulo=angdiff(QaVEIC_theta_LC,vec_theta_procura);
    
    contido=and(diferenca_angulo<pi/2-tol_ang,diferenca_angulo>-pi/2+tol_ang);
    diferenca_angulo_contido=diferenca_angulo(contido);
    Mzk_VEIC_contido=Mzk_VEIC(contido);
    Myk_VEIC_contido=Myk_VEIC(contido);
    QaVEIC_rho_LC_contido=sqrt(Mzk_VEIC_contido.^2+Myk_VEIC_contido.^2);
    componente=QaVEIC_rho_LC_contido.*cos(diferenca_angulo_contido);
    [~,ind_VEIC]=max(componente);
    
    if isempty(ind_VEIC)
        Myk_VEIC_max(it)=0;
        Mzk_VEIC_max(it)=0;
    else
        Myk_VEIC_max(it)=Myk_VEIC_contido(ind_VEIC(1));
        Mzk_VEIC_max(it)=Mzk_VEIC_contido(ind_VEIC(1));
    end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     QaVEIC_theta_LC_contido=QaVEIC_theta_LC(contido);
%     Mzk_contido=Mzk_VEIC(contido);
%     Myk_contido=Myk_VEIC(contido);
%     VEIC_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);
%     
%     
%     polarplot([0 theta_proc(it)],[0 6000],'g')
%     hold on
%     
%     polarplot([0 theta_limite_max],[0 6000],'b--')
%     polarplot([0 theta_limite_min],[0 6000],'b--')
%     
%     
%     
%     
%     Mzk_VEIC=Mzk(VEICi:VEICf);
%     Myk_VEIC=Myk(VEICi:VEICf);
%     
%     for i=1:VEICn
%         polarplot([0 QaVEIC_theta_LC(i)],[0 sqrt(Mzk_VEIC(i)^2+Myk_VEIC(i)^2)],'k')
%         %diferenca_angulo(i)*180/pi
%     end
%     
%     for i=1:sum(contido)
%         polarplot([0 QaVEIC_theta_LC_contido(i)],[0 VEIC_rho_LC_contido(i)],'r')
%     end
%     
%     polarplot([0 QaVEIC_theta_LC_contido(ind_VEIC)],[0 VEIC_rho_LC_contido(ind_VEIC)],'b')
%     
%     hold off
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    %Qa %FREN
    QaFREN_theta_LC=theta_LC(FRENi:FRENf);
    QaFREN_theta_LC(2)=QaFREN_theta_LC(1) + pi;
    
    Mzk_FREN=Mzk(FRENi:FRENf);
    Myk_FREN=Myk(FRENi:FRENf);
    
    Mzk_FREN(2)=-Mzk(FRENi:FRENf);
    Myk_FREN(2)=-Myk(FRENi:FRENf);
    
    contido=confere_intervalo(theta_proc(it),theta_limite_max,theta_limite_min,QaFREN_theta_LC,tol_ang);
    
    
    Myk_FREN_max(it)=sum(Myk_FREN(contido));
    Mzk_FREN_max(it)=sum(Mzk_FREN(contido));
    
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         QaFREN_theta_LC_contido=QaFREN_theta_LC(contido);
%         
%         for i=1:FRENn*2
%             polarplot([0 QaFREN_theta_LC(i)],[0 sqrt(Mzk_FREN(i)^2+Myk_FREN(i)^2)],'k')
%             hold on
%         end
%         Mzk_contido=Mzk_FREN(contido);
%         Myk_contido=Myk_FREN(contido);
%         QaFREN_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);
% 
%         for i=1:sum(contido)
%             polarplot([0 QaFREN_theta_LC_contido(i)],[0 QaFREN_rho_LC_contido(i)],'r')
%         end
%         polarplot([0 theta_proc(it)],[0 300000],'g')
%         polarplot([0 theta_limite_max],[0 300000],'b--')
%         polarplot([0 theta_limite_min],[0 300000],'b--')
%         hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        %RFT
    RFT_theta_LC=theta_LC(RFTi:RFTf);
        
    Mzk_RFT=Mzk(RFTi:RFTf);
    Myk_RFT=Myk(RFTi:RFTf);
    
    contido=confere_intervalo(theta_proc(it),theta_limite_max,theta_limite_min,RFT_theta_LC,tol_ang);
    
    
    Myk_RFT_max(it)=sum(Myk_RFT(contido));
    Mzk_RFT_max(it)=sum(Mzk_RFT(contido));
    
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         RFT_theta_LC_contido=RFT_theta_LC(contido);
%         
%         for i=1:RFTn
%             polarplot([0 RFT_theta_LC(i)],[0 sqrt(Mzk_RFT(i)^2+Myk_RFT(i)^2)],'k')
%             hold on
%         end
%         Mzk_contido=Mzk_RFT(contido);
%         Myk_contido=Myk_RFT(contido);
%         RFT_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);
% 
%         for i=1:sum(contido)
%             polarplot([0 RFT_theta_LC_contido(i)],[0 RFT_rho_LC_contido(i)],'r')
%         end
%         polarplot([0 theta_proc(it)],[0 150000],'g')
%         polarplot([0 theta_limite_max],[0 150000],'b--')
%         polarplot([0 theta_limite_min],[0 150000],'b--')
%         hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %VT
    V90_theta_LC=theta_LC(V90i:V90f);
    for i=1:V90n
        V90_theta_LC(V90n+i)=V90_theta_LC(i) + pi;
    end
    
    Mzk_V90=Mzk(V90i:V90f);
    Myk_V90=Myk(V90i:V90f);
    
    for i=1:V90n
        Mzk_V90(V90n+i)=-Mzk_V90(i);
        Myk_V90(V90n+i)=-Myk_V90(i);
    end
    
    
    vec_theta_procura=zeros(1,V90n*2);
    vec_theta_procura(:)=theta_proc(it);
    diferenca_angulo=angdiff(V90_theta_LC,vec_theta_procura);
    
    

    
    contido=and(diferenca_angulo<pi/2-tol_ang,diferenca_angulo>-pi/2+tol_ang);
    diferenca_angulo_contido=diferenca_angulo(contido);
    Mzk_V90_contido=Mzk_V90(contido);
    Myk_V90_contido=Myk_V90(contido);
    V90_rho_LC_contido=sqrt(Mzk_V90_contido.^2+Myk_V90_contido.^2);
    componente=V90_rho_LC_contido.*cos(diferenca_angulo_contido);
    [~,ind_V90]=max(componente);
    
    if isempty(ind_V90)
        Mzk_V90_max(it)=0;
        Myk_V90_max(it)=0;
    else
        Mzk_V90_max(it)=Mzk_V90_contido(ind_V90(1));
        Myk_V90_max(it)=Myk_V90_contido(ind_V90(1));
    end

    
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     V90_theta_LC_contido=V90_theta_LC(contido);
%     Mzk_contido=Mzk_V90(contido);
%     Myk_contido=Myk_V90(contido);
%     V90_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);
%     
%     
%     polarplot([0 theta_proc(it)],[0 25000],'g')
%     hold on
%     
%     polarplot([0 theta_limite_max],[0 25000],'b--')
%     polarplot([0 theta_limite_min],[0 25000],'b--')
%     
%     
%     
%     for i=1:V90n*2
%         polarplot([0 V90_theta_LC(i)],[0 sqrt(Mzk_V90(i)^2+Myk_V90(i)^2)],'k')
%         %diferenca_angulo(i)*180/pi
%     end
%     
%     for i=1:sum(contido)
%         polarplot([0 V90_theta_LC_contido(i)],[0 V90_rho_LC_contido(i)],'r')
%     end
%     
%     polarplot([0 V90_theta_LC_contido(ind_V90)],[0 V90_rho_LC_contido(ind_V90)],'b')
%     
%     hold off
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    
        %CEP
    CEP_theta_LC=theta_LC(CEPi:CEPf);
    for i=1:CEPn
        CEP_theta_LC(CEPn+i)=CEP_theta_LC(i) + pi;
    end
    
    Mzk_CEP=Mzk(CEPi:CEPf);
    Myk_CEP=Myk(CEPi:CEPf);
    
    for i=1:CEPn
        Mzk_CEP(CEPn+i)=-Mzk_CEP(i);
        Myk_CEP(CEPn+i)=-Myk_CEP(i);
    end
    
    
    vec_theta_procura=zeros(1,CEPn*2);
    vec_theta_procura(:)=theta_proc(it);
    diferenca_angulo=angdiff(CEP_theta_LC,vec_theta_procura);
    
    

    
    contido=and(diferenca_angulo<pi/2-tol_ang,diferenca_angulo>-pi/2+tol_ang);
    diferenca_angulo_contido=diferenca_angulo(contido);
    Mzk_CEP_contido=Mzk_CEP(contido);
    Myk_CEP_contido=Myk_CEP(contido);
    CEP_rho_LC_contido=sqrt(Mzk_CEP_contido.^2+Myk_CEP_contido.^2);
    componente=CEP_rho_LC_contido.*cos(diferenca_angulo_contido);
    [~,ind_CEP]=max(componente);
    
    if isempty(ind_CEP)
        Mzk_CEP_max(it)=0;
        Myk_CEP_max(it)=0;
    else
        Mzk_CEP_max(it)=Mzk_CEP_contido(ind_CEP(1));
        Myk_CEP_max(it)=Myk_CEP_contido(ind_CEP(1));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     CEP_theta_LC_contido=CEP_theta_LC(contido);
%     Mzk_contido=Mzk_CEP(contido);
%     Myk_contido=Myk_CEP(contido);
%     CEP_rho_LC_contido=sqrt(Mzk_contido.^2+Myk_contido.^2);
%     
%     
%     polarplot([0 theta_proc(it)],[0 150000],'g')
%     hold on
%     
%     polarplot([0 theta_limite_max],[0 150000],'b--')
%     polarplot([0 theta_limite_min],[0 150000],'b--')
%     
%     
%     
%     for i=1:CEPn*2
%         polarplot([0 CEP_theta_LC(i)],[0 sqrt(Mzk_CEP(i)^2+Myk_CEP(i)^2)],'k')
%         %diferenca_angulo(i)*180/pi
%     end
%     
%     for i=1:sum(contido)
%         polarplot([0 CEP_theta_LC_contido(i)],[0 CEP_rho_LC_contido(i)],'r')
%     end
%     
%     polarplot([0 CEP_theta_LC_contido(ind_CEP)],[0 CEP_rho_LC_contido(ind_CEP)],'b')
%     
%     hold off
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw_envoltoria(Mzk_MULT_max,Myk_MULT_max,theta_proc)
% hold on
% draw_envoltoria(Mzk_VEIC_max,Myk_VEIC_max,theta_proc)
% hold on
% draw_envoltoria(Mzk_FREN_max,Myk_FREN_max,theta_proc)
% hold on
% draw_envoltoria(Mzk_RFT_max,Myk_RFT_max,theta_proc)
% hold on
% draw_envoltoria(Mzk_V90_max,Myk_V90_max,theta_proc)
% hold on
% draw_envoltoria(Mzk_CEP_max,Myk_CEP_max,theta_proc)
% 
% hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iMc=1:sMc
    for it=1:length(theta_proc)

        MzdENV(it)=Mzk(1)*Mc(iMc,1)+Mzk_MULT_max(it)*Mc(iMc,2)+Mzk_VEIC_max(it)*Mc(iMc,2)+Mzk_FREN_max(it)*Mc(iMc,2)+Mzk_RFT_max(it)*Mc(iMc,3)+Mzk_V90_max(it)*Mc(iMc,4)+Mzk_CEP_max(it)*Mc(iMc,5);                        
        MydENV(it)=Myk(1)*Mc(iMc,1)+Myk_MULT_max(it)*Mc(iMc,2)+Myk_VEIC_max(it)*Mc(iMc,2)+Myk_FREN_max(it)*Mc(iMc,2)+Myk_RFT_max(it)*Mc(iMc,3)+Myk_V90_max(it)*Mc(iMc,4)+Myk_CEP_max(it)*Mc(iMc,5);                     
        
        
        rhoENV(it,iMc)=sqrt(MydENV(it)^2+MzdENV(it)^2);
        thetaENV(it,iMc)=wrapTo2Pi(atan2(MydENV(it),MzdENV(it)));
    end
%     polarplot(theta_proc,rhoENV(:,iMc),'r')
%     hold on
%     polarplot(thetaENV(:,iMc),rhoENV(:,iMc),'g')
%     hold off
end

%% Total desta combinação

[rhoENVitmax,itmax]=max(rhoENV);
[Msd,iMcmax]=max(rhoENVitmax);
theta=thetaENV(itmax(iMcmax),iMcmax);

end


function contido=confere_intervalo(theta,theta_max,theta_min,theta_LC,tol_ang)

if and(theta>=pi/2,theta<=3*pi/2)
    contido=and(theta_max-tol_ang>theta_LC,theta_min+tol_ang<theta_LC);
else
    contido=or(theta_max-tol_ang>theta_LC,theta_min+tol_ang<theta_LC);
end

end

function draw_envoltoria(Mzk_max,Myk_max,theta_proc)
    for it=1:length(theta_proc)

        MzdENV(it)=Mzk_max(it);
        MydENV(it)=Myk_max(it);
        
        thetaENV(it)=wrapTo2Pi(atan2(MydENV(it),MzdENV(it)));
        rhoENV(it)=sqrt(MydENV(it)^2+MzdENV(it)^2);

    end
    polarplot(theta_proc,rhoENV)
    hold on
    polarplot(thetaENV,rhoENV)
    hold off

end
