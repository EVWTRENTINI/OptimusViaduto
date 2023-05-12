function draw_tubuloes(ax,viaduto,info,joints)
%
%
hold(ax,'on')
passo=10;
for k=1:viaduto.n_apoios
    tf=viaduto.apoio(k).n_pilares;
    r=viaduto.apoio(k).fustes.d/2;
    for j=1:tf
        %nó da base
             no=info.fustes.apoio(k).fuste(j).ultimo_no;
        %coordenadas da base
        xb=joints(no,1);
        yb=joints(no,2);
        zb=joints(no,3);
        zr=zb+.2;
        zt=zb+info.tubuloes.apoio(k).tubulao(j).ht;
        R=info.tubuloes.apoio(k).tubulao(j).diam/2;
        
        [Yb,Xb] = circulo(R, passo);
        Zb=zeros(size(Xb));
        
        patch(ax,(Xb+xb),...
              (Yb+yb),...
              (Zb+zb),[.5 .5 .5]);
          
          for n=1:passo
            x=[Xb(n) Xb(n+1) Xb(n+1) Xb(n)]+xb;
            y=[Yb(n) Yb(n+1) Yb(n+1) Yb(n)]+yb;
            z=[zb zb zr zr];
            patch(ax,x,y,z,[.5 .5 .5]);
          end
          
          
          
          [Yt,Xt] = circulo(r, passo);
          
          for n=1:passo
            x=[Xb(n+1) Xt(n+1) Xt(n) Xb(n)]+xb;
            y=[Yb(n+1) Yt(n+1) Yt(n) Yb(n)]+yb;
            z=[zr zt zt zr];
            patch(ax,x,y,z,[.5 .5 .5]);
          end
    end
end
hold(ax,'off')
end

