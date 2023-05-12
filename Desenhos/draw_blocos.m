function [] = draw_blocos(ax,viaduto,info,joints)

hold(ax,'on')
passo=10;
for k=1:viaduto.n_apoios
    tf=viaduto.apoio(k).n_pilares;
    for j=1:tf
        A=info.blocos.apoio(k).bloco(j).A;
        H=info.blocos.apoio(k).bloco(j).H;
        no=info.fustes.apoio(k).fuste(j).primeiro_no;
        x=joints(no,1);
        y=joints(no,2);
        zt=joints(no,3);
        zb=zt-H;
        
        X1=x-A/2;
        X2=x-A/2;
        X3=x+A/2;
        X4=x+A/2;
        X5=x-A/2;
        
        Y1=y+A/2;
        Y2=y-A/2;
        Y3=y-A/2;
        Y4=y+A/2;
        Y5=y+A/2;
        
        X=[X1 X2 X3 X4 X5];
        Y=[Y1 Y2 Y3 Y4 Y5];
        Zt=[zt zt zt zt zt];
        Zb=[zb zb zb zb zb];
        
        %%Tampa
        patch(ax,X,...
              Y,...
              Zt,[.5 .5 .5]);
        %%Base
        patch(ax,X,...
              Y,...
              Zb,[.5 .5 .5]);
        %%Lados
        for n=1:length(X)-1
            xx=[X(n) X(n+1) X(n+1) X(n)];
            yy=[Y(n) Y(n+1) Y(n+1) Y(n)];
            zz=[zb zb zt zt];
            patch(ax,xx,yy,zz,[.5 .5 .5]);
        end
    end
end

hold(ax,'off')

end