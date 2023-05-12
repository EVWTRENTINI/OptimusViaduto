function draw_problema(ax,greide, impedido, terreno)
fonte_num = 'Cambria Math';
fonte_text = 'Times New Roman';
tamanho_texto = 12;

folga_x = 4;

for i = 1:length(impedido)
    if not(islogical(impedido(i).pista))
        if impedido(i).pista == "false"
            impedido(i).pista = false;
        elseif impedido(i).pista == "true"
            impedido(i).pista = true;
        end
    end
end

xmin = min([terreno.x]);
xmax = max([terreno.x]);
z = [terreno.nivel_terreno]+[terreno.delta_z_impacto];



np = length(terreno);

profundidade = zeros(1,np);
cota_fundacao = zeros(1,np);
for i = 1:np
    profundidade(i) = length(terreno(i).Nspt)-1;
    cota_fundacao(i) = terreno(i).nivel_terreno - length(terreno(i).Nspt)+1;
end

%% Terreno

vt = zeros((np+2)*2,2);

vt(1,1) = xmin-folga_x;
vt(1,2) = interp1([terreno.x],[terreno.nivel_terreno],vt(1,1),"linear","extrap");

vt(end,1) = vt(1,1);
vt(end,2) = interp1([terreno.x],cota_fundacao,vt(1,1),"linear","extrap");

vt(np+2,1) = xmax+folga_x;
vt(np+2,2) = interp1([terreno.x],[terreno.nivel_terreno],vt(np+2,1),"linear","extrap");


vt(np+3,1) = vt(np+2,1);
vt(np+3,2) = interp1([terreno.x],cota_fundacao,vt(np+3,1),"linear","extrap");

for i = 1:np
    vt(1+i,1) = terreno(i).x;
    vt(1+i,2) = terreno(i).nivel_terreno;
    vt((np+2)*2-i,1) = vt(1+i,1);
    vt((np+2)*2-i,2) = interp1([terreno.x],cota_fundacao,vt(1+i,1),"linear","extrap");
end

ft = 1:1:size(vt,1);

cla(ax)
patch(ax,'Faces',ft,'Vertices',vt,'FaceColor',[0.9570 0.9414 0.9219],'EdgeColor','none');
hold(ax,'on')




%% Sondagens
alinhamento = 'left';
texto_antes = ' ';
texto_depois = '';
for i = 1:np
    if i == np
        alinhamento = 'right';
        texto_antes = '';
        texto_depois = ' ';
    end
    for zs = 1:profundidade(i)
        if rem(zs, 2) == 0
            cor = [1 1 1];
        else
            cor = [0 0 0];
        end
        plot(ax,[terreno(i).x terreno(i).x],[terreno(i).nivel_terreno-zs+1 terreno(i).nivel_terreno-zs],'Color',cor,'LineWidth',2)
        text(ax,terreno(i).x,terreno(i).nivel_terreno-zs,[texto_antes num2str(terreno(i).Nspt(zs+1)) texto_depois],'VerticalAlignment','baseline','HorizontalAlignment',alinhamento,'FontName',fonte_num)
    end
end

text(ax,terreno(1).x,terreno(1).nivel_terreno-profundidade(1)/2,'\itN_{spt}','VerticalAlignment','bottom','HorizontalAlignment','center','FontName',fonte_num,'Rotation',90)


%% Greide
vg = transpose([greide.x transpose(flip(vt(2:np+1,1)))]); % Copia do terreno
vg(:,2) = [greide.z transpose(flip(vt(2:np+1,2)))]; % Copia do terreno

vg(end,1) = vg(1,1); % Corrige para o mesmo x do greide - primeiro ponto
vg(length(greide.x)+1,1) = vg(length(greide.x),1); % Corrige para o mesmo x do greide - último ponto

vg(end,2) = interp1([terreno.x],[terreno.nivel_terreno],vg(end,1),"linear","extrap") ;% Corrige para o mesmo z do greide - primeiro ponto
vg(length(greide.x)+1,2) = interp1([terreno.x],[terreno.nivel_terreno],vg(length(greide.x)+1,1),"linear","extrap"); % Corrige para o mesmo z do greide - último ponto

fg = 1:1:size(vg,1);

patch(ax,'Faces',fg,'Vertices',vg,'FaceColor',[0.9375 0.9531 0.9961],'EdgeColor',[0.3008 0.3438 0.7812],'LineStyle','-.')



text(ax,mean(greide.x),interp1(greide.x,greide.z,mean(greide.x)),'\itgreide da pista','VerticalAlignment','top','HorizontalAlignment','center','FontName',fonte_text,'FontSize',tamanho_texto,'Rotation',atand((interp1(greide.x,greide.z,mean(greide.x)+.1)-interp1(greide.x,greide.z,mean(greide.x)-.1))/(.2)))
text(ax,mean(greide.x),(min(greide.z)+max([z]))/2,['\itregião' newline ' \itpermitida '],'VerticalAlignment','middle','HorizontalAlignment','center','FontName',fonte_text,'FontSize',tamanho_texto)

%% Aterro



va = zeros((np+2)*2,2);
va(1,1) = xmin-folga_x;
va(1,2) = interp1([terreno.x],z,va(1,1),"linear","extrap");

va(np+2,1) = xmax+folga_x;
va(np+2,2) = interp1([terreno.x],z,va(np+2,1),"linear","extrap");



for i = 1:np
    va(1+i,1) = terreno(i).x;
    va(1+i,2) = z(i);

end

va(np+3:end,1) =  flip(vt(1:np+2,1));
va(np+3:end,2) =  flip(vt(1:np+2,2));

fa = 1:1:size(vt,1);

patch(ax,'Faces',fa,'Vertices',va,'FaceColor',[0.9336 0.8906 0.8789],'EdgeColor','none')



%% Impedido
nimp = length(impedido);
e_pav = .2;

for i = 1:nimp
    if impedido(i).pista == false
        % Impedido
        zi = interp1([terreno.x],z,impedido(i).xi,"linear","extrap");
        zf = interp1([terreno.x],z,impedido(i).xf,"linear","extrap");
        zt = max([zi zf]) + 1.5;
        zb = min([zi zf]) - 1.5;
        vi = [impedido(i).xi zt;impedido(i).xf zt;impedido(i).xf zb;impedido(i).xi zb];
        fi = 1:1:size(vi,1);
        patch(ax,'Faces',fi,'Vertices',vi,'FaceColor',[0.9961 0.8711 0.8711],'EdgeColor',[0.7578 0.1914 0.1914],'LineStyle','--','LineWidth',1)
        plot(ax,[impedido(i).xi impedido(i).xf],[zt zb],'Color',[0.7578 0.1914 0.1914],'LineStyle','--')
        plot(ax,[impedido(i).xf impedido(i).xi],[zt zb],'Color',[0.7578 0.1914 0.1914],'LineStyle','--')
        text(ax,mean([impedido(i).xi impedido(i).xf]),mean([zt zb]),['\itregião' newline newline ' \itimpedida '],'VerticalAlignment','middle','HorizontalAlignment','center','FontName',fonte_text,'FontSize',tamanho_texto)
    else
        % Pista de rolagem
        zi = interp1([terreno.x],z,impedido(i).xi,"linear","extrap");
        zf = interp1([terreno.x],z,impedido(i).xf,"linear","extrap");
        vi = [impedido(i).xi zi; impedido(i).xi zi+e_pav; mean([impedido(i).xi impedido(i).xf]) mean([zi zf])+e_pav*2; impedido(i).xf zf+e_pav; impedido(i).xf zf];
        fi = 1:1:size(vi,1);
        patch(ax,'Faces',fi,'Vertices',vi,'FaceColor',[0.5078 0.5078 0.5078],'EdgeColor',[0 0 0])
        text(ax,mean([impedido(i).xi impedido(i).xf]),mean([zi zf]),['\it pista de rolagem '],'VerticalAlignment','top','HorizontalAlignment','center','FontName',fonte_text,'FontSize',tamanho_texto,'Rotation',atand((zf-zi)/(impedido(i).xf-impedido(i).xi)))
   
    end
end

%% Linha do solo
plot(ax,vt(2:np+1,1),vt(2:np+1,2),'Color',[0 0 0],'LineWidth',2)
%% Linha aterro
plot(ax,va(2:np+1,1),va(2:np+1,2),'Color',[0 0 0],'LineWidth',1)
%% Texto solo
text(ax,terreno(ceil((np)/2)+1).x,terreno(ceil((np)/2)+1).nivel_terreno,['\itsolo   '],'VerticalAlignment','top','HorizontalAlignment','right','FontName',fonte_text,'FontSize',tamanho_texto,'Rotation',atand((terreno(ceil((np)/2)+1).nivel_terreno-terreno(ceil((np)/2)).nivel_terreno)/(terreno(ceil((np)/2)+1).x-terreno(ceil((np)/2)).x)))
%% Texto aterro
if any(z>0)
    [~,indice] = max([terreno.delta_z_impacto]);
    if indice == np
        indice = np-1;
    end
    text(ax,terreno(indice).x,terreno(indice).nivel_terreno,['\it   aterro'],'VerticalAlignment','bottom','HorizontalAlignment','left','FontName',fonte_text,'FontSize',tamanho_texto,'Rotation',atand((terreno(indice+1).nivel_terreno-terreno(indice).nivel_terreno)/(terreno(indice+1).x-terreno(indice).x)))
end

      
%% Terra armada
esp_solo_bloco = .2; % Espessura de solo sobre o bloco
esp_bloco = .4; % Espessura do bloco de apoio da terra armada
esp_ta = .2; % Espessura da parde de terra armada
esp_solo_ta = .4; % Espessura de solo sobre a terra aramda
esp_laje_ap = .2; % Espessura da laje de aproximação
offset_ta = 1; % Distancia entre eixo do pilar e eixo da terra armada
offset_lj = .4; % Distancia entre o começo da laje de aproximação e o eixo do inicio do greide

    %% 1
% Pó de pedra da terra armada
x1 = xmin-folga_x;
x2 = greide.x(1) - offset_lj;
x3 = x2;
x4 = greide.x(1)-offset_ta;
x5 = x4;
x6 = x1;

z1 = interp1(greide.x,greide.z,x1,"linear","extrap");
z2 = interp1(greide.x,greide.z,x2,"linear","extrap");
z3 = z2 - esp_solo_ta - esp_laje_ap/2;
z4 = z3;
z5 = interp1([terreno.x],z,x5,"linear","extrap");
z6 = interp1([terreno.x],z,x6,"linear","extrap");

vpp = [x1 z1; x2 z2;x3 z3; x4 z4; x5 z5; x6 z6];
fpp = 1:1:size(vpp,1);

patch(ax,'Faces',fpp,'Vertices',vpp,'FaceColor',[0.93 0.93 0.93],'EdgeColor','none') % Pó de pedra, cor original [0.9648 0.9648 0.9648]
% Fitas da terra armada
dist_fitas = .9;
xif = greide.x(1)-offset_ta-esp_ta/2;
xff = xmin-folga_x;
zif = min([(interp1(greide.x,greide.z,x1,"linear","extrap") - esp_laje_ap - esp_solo_ta) (interp1(greide.x,greide.z,x2,"linear","extrap") - esp_laje_ap - esp_solo_ta)]);
for zf = zif-dist_fitas/2:-dist_fitas:max([z5 z6])
    plot(ax,[xif xif-abs(xif-xff)*.2 xif-abs(xif-xff)*.4 xif-abs(xif-xff)*.6 xff],[zf zf-.04 zf-.06 zf-.08 zf-.08],'Color',[0.6406 0.6406 0.6406])
end



% Muro
x1 = greide.x(1)-offset_ta-esp_ta/2;
z1 = interp1(greide.x,greide.z,x1,"linear","extrap") - esp_laje_ap - esp_solo_ta;
x2 = greide.x(1)-offset_ta+esp_ta/2;
z2 = interp1(greide.x,greide.z,x2,"linear","extrap") - esp_laje_ap - esp_solo_ta;
x3 = x2;
x4 = x1;
profundidade_bloco = min([interp1([terreno.x],z,x3,"linear","extrap") interp1([terreno.x],z,x4,"linear","extrap")]) - esp_solo_bloco;
z3 = profundidade_bloco;
z4 = profundidade_bloco;


vta = [x1 z1; x2 z2;x3 z3; x4 z4];
fta = 1:1:size(vta,1);

patch(ax,'Faces',fta,'Vertices',vta,'FaceColor',[0.8594 0.8594 0.8594],'EdgeColor',[0 0 0]) % Muro
    
% Bloco
x1 = greide.x(1)-offset_ta-esp_bloco/2;
z1 = profundidade_bloco;
x2 = greide.x(1)-offset_ta+esp_bloco/2;
z2 = profundidade_bloco;
x3 = x2;
x4 = x1;
z3 = profundidade_bloco - 2*esp_bloco;
z4 = profundidade_bloco - 2*esp_bloco;


vbl = [x1 z1; x2 z2;x3 z3; x4 z4];
fbl = 1:1:size(vbl,1);

patch(ax,'Faces',fbl,'Vertices',vbl,'FaceColor',[0.8594 0.8594 0.8594],'EdgeColor',[0 0 0]) % Bloco

% Laje de aproximação
x1 = greide.x(1) - offset_lj;
z1 = interp1(greide.x,greide.z,x1,"linear","extrap") - esp_solo_ta;
x2 = x1;
z2 = z1 - esp_laje_ap;
x3 = xmin-folga_x;
x4 = x3;
z3 = interp1(greide.x,greide.z,x3,"linear","extrap") - esp_solo_ta - esp_laje_ap;
z4 = z3 + esp_laje_ap;


vlj = [x1 z1; x2 z2;x3 z3; x4 z4];
flj = 1:1:size(vlj,1);
patch(ax,'Faces',flj,'Vertices',vlj,'FaceColor',[0.8594 0.8594 0.8594],'EdgeColor',[0 0 0]) % Laje de aproximação

    %% 2
    % Pó de pedra da terra armada
x1 = xmax+folga_x;
x2 = greide.x(end) + offset_lj;
x3 = x2;
x4 = greide.x(end) + offset_ta;
x5 = x4;
x6 = x1;

z1 = interp1(greide.x,greide.z,x1,"linear","extrap");
z2 = interp1(greide.x,greide.z,x2,"linear","extrap");
z3 = z2 - esp_solo_ta - esp_laje_ap/2;
z4 = z3;
z5 = interp1([terreno.x],z,x5,"linear","extrap");
z6 = interp1([terreno.x],z,x6,"linear","extrap");

vpp = [x1 z1; x2 z2;x3 z3; x4 z4; x5 z5; x6 z6];
fpp = 1:1:size(vpp,1);

patch(ax,'Faces',fpp,'Vertices',vpp,'FaceColor',[0.93 0.93 0.93],'EdgeColor','none') % Pó de pedra, cor original [0.9648 0.9648 0.9648]
% Fitas da terra armada
dist_fitas = .9;
xif = greide.x(end)+offset_ta+esp_ta/2;
xff = xmax+folga_x;
zif = min([(interp1(greide.x,greide.z,x1,"linear","extrap") - esp_laje_ap - esp_solo_ta) (interp1(greide.x,greide.z,x2,"linear","extrap") - esp_laje_ap - esp_solo_ta)]);
for zf = zif-dist_fitas/2:-dist_fitas:max([z5 z6])
    plot(ax,[xif xif+abs(xif-xff)*.2 xif+abs(xif-xff)*.4 xif+abs(xif-xff)*.6 xff],[zf zf-.04 zf-.06 zf-.08 zf-.08],'Color',[0.6406 0.6406 0.6406])
end



% Muro
x1 = greide.x(end)+offset_ta+esp_ta/2;
z1 = interp1(greide.x,greide.z,x1,"linear","extrap") - esp_laje_ap - esp_solo_ta;
x2 = greide.x(end)+offset_ta-esp_ta/2;
z2 = interp1(greide.x,greide.z,x2,"linear","extrap") - esp_laje_ap - esp_solo_ta;
x3 = x2;
x4 = x1;
profundidade_bloco = min([interp1([terreno.x],z,x3,"linear","extrap") interp1([terreno.x],z,x4,"linear","extrap")]) - esp_solo_bloco;
z3 = profundidade_bloco;
z4 = profundidade_bloco;


vta = [x1 z1; x2 z2;x3 z3; x4 z4];
fta = 1:1:size(vta,1);

patch(ax,'Faces',fta,'Vertices',vta,'FaceColor',[0.8594 0.8594 0.8594],'EdgeColor',[0 0 0]) % Muro
    
% Bloco
x1 = greide.x(end)+offset_ta+esp_bloco/2;
z1 = profundidade_bloco;
x2 = greide.x(end)+offset_ta-esp_bloco/2;
z2 = profundidade_bloco;
x3 = x2;
x4 = x1;
z3 = profundidade_bloco - 2*esp_bloco;
z4 = profundidade_bloco - 2*esp_bloco;


vbl = [x1 z1; x2 z2;x3 z3; x4 z4];
fbl = 1:1:size(vbl,1);

patch(ax,'Faces',fbl,'Vertices',vbl,'FaceColor',[0.8594 0.8594 0.8594],'EdgeColor',[0 0 0]) % Bloco

% Laje de aproximação
x1 = greide.x(end) + offset_lj;
z1 = interp1(greide.x,greide.z,x1,"linear","extrap") - esp_solo_ta;
x2 = x1;
z2 = z1 - esp_laje_ap;
x3 = xmax+folga_x;
x4 = x3;
z3 = interp1(greide.x,greide.z,x3,"linear","extrap") - esp_solo_ta - esp_laje_ap;
z4 = z3 + esp_laje_ap;


vlj = [x1 z1; x2 z2;x3 z3; x4 z4];
flj = 1:1:size(vlj,1);
patch(ax,'Faces',flj,'Vertices',vlj,'FaceColor',[0.8594 0.8594 0.8594],'EdgeColor',[0 0 0]) % Laje de aproximação

%%

axis(ax,'equal')


end











