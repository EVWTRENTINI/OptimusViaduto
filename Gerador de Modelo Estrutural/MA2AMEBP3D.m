function [joints,jb,jfix,aflex,broty,brig,brig_ex,draw_not,A,E,G,Iz,Iy,J,secao] = MA2AMEBP3D( MA )
%Transforma o modelo analítico MA em variáveis do AMEBP3D
%   MA 
%   para
%   [joints,jb,jfix,aflex,broty,brig,brig_ex,draw_not,A,E,G,Iz,Iy,J,secao]

joints=transpose([MA.joints.x;MA.joints.y;MA.joints.z]);

jb=transpose([MA.memb.b;MA.memb.e]);

jfix=transpose(reshape([MA.joints.vr],6,[]));

cont=0;
for i=1:MA.n.joints
    if not(isempty(MA.joints(i).vf))
        cont=cont+1;
        aflex(cont,:)=[i MA.joints(i).vf];
    end
end

cont_broty=0;
cont_rig=0;
cont_rig_ex=0;
cont_draw_not=0;
for i=1:MA.n.memb
    if not(isempty(MA.memb(i).rb))
        cont_broty=cont_broty+1;
        broty(cont_broty,:)=[i MA.memb(i).rb MA.memb(i).re];
    end
    
    if not(isempty(MA.memb(i).rig))
        cont_rig=cont_rig+1;
        brig(cont_rig)=i;
    end
    
    if not(isempty(MA.memb(i).rig_ex))
        cont_rig_ex=cont_rig_ex+1;
        brig_ex(cont_rig_ex,:)=[i MA.memb(i).rig_ex];
    end
    
    if not(isempty(MA.memb(i).draw_not))
        cont_draw_not=cont_draw_not+1;
        draw_not(cont_draw_not)=i;
    end
    
    secao(i).nos=MA.memb(i).secao;
end
A=[MA.memb.A];
E=[MA.memb.E];
G=[MA.memb.G];
Iz=[MA.memb.Iz];
Iy=[MA.memb.Iy];
J=[MA.memb.J];
end