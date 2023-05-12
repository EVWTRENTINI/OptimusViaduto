n_furos=length(sondagem);

for i=1:n_furos
    zmin(i)=sondagem(i).nivel_terreno-length(sondagem(i).Nspt);
end

y=viaduto.W/2*1.1;

x = sondagem(1).x:1:sondagem(end).x;
z = max([sondagem.nivel_terreno]):-.5:min(zmin);
[Xq,Zq] = meshgrid(x,z);

Npstq=Nspt(Xq,Zq);
disc_rig=[max(Npstq)*.99999/5:max(Npstq)*.99999/5:max(Npstq)*.99999];
cnt=contourc(Xq(1,:),Zq(:,1),Npstq,disc_rig);

szc = size(cnt);
idz = 1;
contourNo = 1;
while idz<szc(2)
    izi = cnt(2,idz);
    cnt(2,idz) = nan;
    labelcnt(contourNo)=cnt(1,idz);
    contourXY{contourNo} = cnt(:,idz+1:idz+izi);
    idz = idz+izi+1;
    contourNo = contourNo+1;
end

hold on
plot3([sondagem.x],ones(1,n_furos)*y,[sondagem.nivel_terreno])


for k = 1:contourNo-1
    plot3(contourXY{k}(1,:),ones(1,length(contourXY{k}(1,:)))*y,contourXY{k}(2,:));
    text(contourXY{k}(1,end),y,contourXY{k}(2,end),['   ' num2str(labelcnt(k),2) ' Golpes'])
end



%surf(Xq,Kq/1E9+y,Zq)
% scatter3(rigidez_solo.x,rigidez_solo.K,rigidez_solo.z)



hold off




