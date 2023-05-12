function [cabo,situacao,msg_erro] = cria_prop_cabos(aa,ZCG,vao,viaduto,lb)
%Cria o traçado dos cabos de protensão
%A referencia do y deve ser a base da longarina

situacao=true;
msg_erro='sem erro';

h1=vao.longarina.h1;%altura da longarina
b3=vao.longarina.b3;%altura da longarina
al=(viaduto.folga-viaduto.junta)/2;%comprimento da longarina alem do centro do apoio
aap=vao.aap;% altura extimada do cg da protensão na ancoragem
danc=viaduto.danc;% distancia entre ancoragens de protensão
ndc=viaduto.disc_cabos;
ntc=aa.n;
centro=ceil((ndc+3)/2);

cabo(ntc).x=0;
cabo(ntc).y=0;

nch=floor(b3/danc);%numero de cabos na horizontal
ncv=ceil(ntc/nch);%numero de cabos na vertical
if floor(ncv/2)==ncv/2%par
  cy(1)=aap-(danc/2+(floor(ncv/2)-1)*danc);
else %impar
  cy(1)=aap-(floor(ncv/2)*danc);
end
for n=2:ncv
	cy(n)=cy(1)+(danc*(n-1));
end
if or(cy(1)<danc/2,cy(ncv)>h1-danc/2)
    situacao=false;
    msg_erro='Ancoragem dos cabos não cabe na longarina';
    return
end

catu=1;%camada atual
ncc=0;%numero de cabos na camada
% figure(201)
% clf(201)
% rectangle('Position', [0, 0, lb+al*2, h1], 'LineWidth', 2);
% hold on
for n=1:ntc
    cabo(n).x(ndc+3)=2*al+lb;
    cabo(n).x(1)=0;
    cabo(n).x(2)=al;
    for i=1:ndc
        cabo(n).x(2+i)=cabo(n).x(1+i)+lb/ndc;
    end
    
    
    cabo(n).y(1)=cy(catu);
    cabo(n).y(ndc+3)=cabo(n).y(1);

    ncc=ncc+1;
    if ncc==nch
        catu=catu+1;
        ncc=0;
    end
    x1=cabo(n).x(1);
    y1=cabo(n).y(1);
    x2=cabo(n).x(centro);
    y2=aa.y(n)+h1+ZCG;
    x3=cabo(n).x(ndc+3);
    y3=cabo(n).y(ndc+3);
    [a,b,c] = parabola(x1,x2,x3,y1,y2,y3);

    for i=1:ndc+3
        cabo(n).y(i)=a*cabo(n).x(i)^2+b*cabo(n).x(i)+c;
    end
    
%     scatter([x1 x2 x3],[y1 y2 y3]);
%     
%     plot(cabo(n).x,cabo(n).y);
    
end
% hold off
end