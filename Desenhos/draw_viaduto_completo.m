function draw_viaduto_completo(ax, viaduto, greide, terreno, impedido, info)
[viaduto,impedido,situacao,msg_erro] = trata_informacoes(viaduto, greide, terreno, impedido);
if not(situacao); fprintf([msg_erro '\n']); return; end

[MA,~,~,~,situacao,msg_erro]=cria_viaduto(viaduto,terreno);
if not(situacao); fprintf([msg_erro '\n']); return; end

%Monta o Modelo analitico
[joints,jb,~,~,~,~,~,draw_not,~,~,~,~,~,~,secao] =...
    MA2AMEBP3D( MA );

%Calcula os conessenos diretores
[~,~,lb,r,~] =...
    calc_cossenos(joints,jb);

cla(ax)
%axis(ax,'off')
extruded_view(ax,secao,joints,jb,lb,r,draw_not)
draw_blocos(ax,viaduto,info,joints)
draw_tubuloes(ax,viaduto,info,joints)
draw_fresta_de_laje(ax,joints,jb,r,info,viaduto)
draw_enr_longa(ax,joints,jb,r,info,viaduto)
%xlim([-2 42]); ylim([-10 10]); zlim([-12 10]);
%mygca = gca;
%mygca.Position = [0 0 1 1];
%mygca.CameraViewAngle = 6.1;
%drawnow;
camva(ax,8)

end